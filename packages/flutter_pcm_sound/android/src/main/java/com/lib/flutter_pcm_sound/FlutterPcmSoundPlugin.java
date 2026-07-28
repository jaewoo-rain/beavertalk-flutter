package com.lib.flutter_pcm_sound;

import android.os.Build;
import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;
import android.media.AudioAttributes;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;

import androidx.annotation.NonNull;

import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;
import java.io.StringWriter;
import java.io.PrintWriter;
import java.nio.ByteBuffer;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * FlutterPcmSoundPlugin implements a "one pedal" PCM sound playback mechanism.
 * Playback starts automatically when samples are fed and stops when no more samples are available.
 */
public class FlutterPcmSoundPlugin implements
    FlutterPlugin,
    MethodChannel.MethodCallHandler
{
    private static final String CHANNEL_NAME = "flutter_pcm_sound/methods";

    // (beavertalk patch) Upstream split every feed into 200-BYTE pieces (the name
    // said "frames" but split() measures bytes), so one ~500ms feed became ~120
    // ByteBuffer objects — and the playback thread walked the whole queue after
    // each 200-byte write. Cost grew with buffer depth, i.e. the deeper we
    // buffered to survive UI jank, the more we loaded the very thread we were
    // protecting. 4KB pieces (~85ms @24kHz mono) keep the low-buffer event
    // reasonably fine-grained while cutting object churn ~20x.
    private static final int MAX_CHUNK_BYTES = 4096;

    // (beavertalk patch) AudioTrack's own buffer is the last line of defense
    // against an underrun; the platform minimum is often only ~50-100ms. Give it
    // real headroom so a late feed doesn't glitch immediately.
    private static final int TARGET_TRACK_BUFFER_MS = 250;

    private MethodChannel mMethodChannel;
    private Handler mainThreadHandler = new Handler(Looper.getMainLooper());
    private Thread playbackThread;
    private volatile boolean mShouldCleanup = false;

    private AudioTrack mAudioTrack;
    private int mNumChannels;
    private int mMinBufferSize;
    private boolean mDidSetup = false;

    private long mFeedThreshold = 8000;
    private long mTotalFeeds = 0;
    private long mLastLowBufferFeed = 0;
    private long mLastZeroFeed = 0;

    // Thread-safe queue for storing audio samples
    private final LinkedBlockingQueue<ByteBuffer> mSamples = new LinkedBlockingQueue<>();

    // (beavertalk patch) Running byte count of everything not yet handed to
    // AudioTrack, so the playback thread never has to walk mSamples just to
    // measure it (upstream did that after every single write — O(n) per chunk,
    // under the same lock the main thread takes in `feed`). Includes the chunk
    // currently being written, so the number never dips mid-write.
    private long mQueuedBytes = 0;

    // (beavertalk patch) Diagnostics for the "buffer keeps growing / stutter gets
    // worse over time" investigation. Read via the `getStats` method.
    private int mSampleRate = 0;
    private int mTrackBufferBytes = 0;

    // Log level enum (kept for potential future use)
    private enum LogLevel {
        NONE,
        ERROR,
        STANDARD,
        VERBOSE
    }

    private LogLevel mLogLevel = LogLevel.VERBOSE;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        BinaryMessenger messenger = binding.getBinaryMessenger();
        mMethodChannel = new MethodChannel(messenger, CHANNEL_NAME);
        mMethodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        mMethodChannel.setMethodCallHandler(null);
        cleanup();
    }

    @Override
    @SuppressWarnings("deprecation") // Needed for compatibility with Android < 23
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        try {
            switch (call.method) {
                case "setLogLevel": {
                    result.success(true);
                    break;
                }
                case "setup": {
                    int sampleRate = call.argument("sample_rate");
                    mNumChannels = call.argument("num_channels");

                    // Cleanup existing resources if any
                    if (mAudioTrack != null) {
                        cleanup();
                    }

                    int channelConfig = (mNumChannels == 2) ?
                        AudioFormat.CHANNEL_OUT_STEREO :
                        AudioFormat.CHANNEL_OUT_MONO;

                    mMinBufferSize = AudioTrack.getMinBufferSize(
                        sampleRate, channelConfig, AudioFormat.ENCODING_PCM_16BIT);

                    if (mMinBufferSize == AudioTrack.ERROR || mMinBufferSize == AudioTrack.ERROR_BAD_VALUE) {
                        result.error("AudioTrackError", "Invalid buffer size.", null);
                        return;
                    }

                    // (beavertalk patch) Headroom: at least TARGET_TRACK_BUFFER_MS of
                    // audio, and never below the platform minimum.
                    mSampleRate = sampleRate;
                    int targetBytes = (sampleRate * mNumChannels * 2 * TARGET_TRACK_BUFFER_MS) / 1000;
                    mTrackBufferBytes = Math.max(mMinBufferSize, targetBytes);

                    if (Build.VERSION.SDK_INT >= 23) { // Android 6 (Marshmallow) and above
                        mAudioTrack = new AudioTrack.Builder()
                            .setAudioAttributes(new AudioAttributes.Builder()
                                    .setUsage(AudioAttributes.USAGE_MEDIA)
                                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                                    .build())
                            .setAudioFormat(new AudioFormat.Builder()
                                    .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                                    .setSampleRate(sampleRate)
                                    .setChannelMask(channelConfig)
                                    .build())
                            .setBufferSizeInBytes(mTrackBufferBytes)
                            .setTransferMode(AudioTrack.MODE_STREAM)
                            .build();
                    } else {
                        mAudioTrack = new AudioTrack(
                            AudioManager.STREAM_MUSIC,
                            sampleRate,
                            channelConfig,
                            AudioFormat.ENCODING_PCM_16BIT,
                            mTrackBufferBytes,
                            AudioTrack.MODE_STREAM);
                    }

                    if (mAudioTrack.getState() != AudioTrack.STATE_INITIALIZED) {
                        result.error("AudioTrackError", "AudioTrack initialization failed.", null);
                        mAudioTrack.release();
                        mAudioTrack = null;
                        return;
                    }

                    // reset
                    mSamples.clear();
                    mQueuedBytes = 0;
                    mShouldCleanup = false;

                    // start playback thread
                    playbackThread = new Thread(this::playbackThreadLoop, "PCMPlaybackThread");
                    playbackThread.setPriority(Thread.MAX_PRIORITY);
                    playbackThread.start();

                    mDidSetup = true;

                    result.success(true);
                    break;
                }
                case "feed": {

                    // check setup (to match iOS behavior)
                    if (mDidSetup == false) {
                        result.error("Setup", "must call setup first", null);
                        return;
                    }

                    byte[] buffer = call.argument("buffer");

                    // Split for better performance
                    List<ByteBuffer> chunks = split(buffer, MAX_CHUNK_BYTES);

                    // Push samples
                    synchronized (mSamples) {
                        for (ByteBuffer chunk : chunks) {
                            mSamples.add(chunk);
                        }
                        mQueuedBytes += buffer.length;
                        mTotalFeeds += 1;
                    }

                    result.success(true);
                    break;
                }
                // (beavertalk patch) O(1) diagnostics snapshot: how much audio is
                // waiting, in how many pieces, and how many underruns AudioTrack has
                // seen since setup. Lets the app log whether any of these creep up
                // over a 5-minute call.
                case "getStats": {
                    Map<String, Object> stats = new HashMap<>();
                    long queuedBytes;
                    int chunks;
                    synchronized (mSamples) {
                        queuedBytes = mQueuedBytes;
                        chunks = mSamples.size();
                    }
                    AudioTrack track = mAudioTrack;
                    stats.put("queued_bytes", queuedBytes);
                    stats.put("chunks", chunks);
                    stats.put("underruns", track != null ? track.getUnderrunCount() : -1);
                    stats.put("track_buffer_bytes", mTrackBufferBytes);
                    stats.put("total_feeds", mTotalFeeds);
                    result.success(stats);
                    break;
                }
                case "setFeedThreshold": {
                    long feedThreshold = ((Number) call.argument("feed_threshold")).longValue();

                    synchronized (mSamples) {
                        mFeedThreshold = feedThreshold;
                    }

                    result.success(true);
                    break;
                }
                case "release": {
                    cleanup();
                    result.success(true);
                    break;
                }
                default:
                    result.notImplemented();
                    break;
            }


        } catch (Exception e) {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            e.printStackTrace(pw);
            String stackTrace = sw.toString();
            result.error("androidException", e.toString(), stackTrace);
            return;
        }
    }

    /**
     * Cleans up resources by stopping the playback thread and releasing AudioTrack.
     */
    private void cleanup() {
        // stop playback thread
        if (playbackThread != null) {
            mShouldCleanup = true;
            playbackThread.interrupt();
            try {
                playbackThread.join();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            playbackThread = null;
            mDidSetup = false;
        }
    }

    /**
     * Invokes the 'OnFeedSamples' callback with the number of remaining frames.
     */
    private void invokeFeedCallback(long remainingFrames) {
        Map<String, Object> response = new HashMap<>();
        response.put("remaining_frames", remainingFrames);
        mMethodChannel.invokeMethod("OnFeedSamples", response);
    }

    /**
     * The main loop of the playback thread.
     */
    private void playbackThreadLoop() {
        android.os.Process.setThreadPriority(android.os.Process.THREAD_PRIORITY_AUDIO);

        mAudioTrack.play();

        while (!mShouldCleanup) {
            ByteBuffer data = null;
            try {
                // blocks indefinitely until new data
                data = mSamples.take();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                continue;
            }

            // write
            int written = data.remaining();
            mAudioTrack.write(data, written, AudioTrack.WRITE_BLOCKING);

            long remainingFrames;
            long totalFeeds;
            long feedThreshold;

            // grab shared data
            // (beavertalk patch) The chunk just written leaves the backlog here, and
            // the backlog is a running counter — no walk over mSamples.
            synchronized (mSamples) {
                mQueuedBytes -= written;
                if (mQueuedBytes < 0) mQueuedBytes = 0; // paranoia (clear() races)
                remainingFrames = mQueuedBytes / (2 * mNumChannels);
                totalFeeds = mTotalFeeds;
                feedThreshold = mFeedThreshold;
            }

            // check for events
            boolean isLowBufferEvent = (remainingFrames <= feedThreshold) && (mLastLowBufferFeed != totalFeeds);
            boolean isZeroCrossingEvent = (remainingFrames == 0) && (mLastZeroFeed != totalFeeds);

            // send events
            if (isLowBufferEvent || isZeroCrossingEvent) {
                if (isLowBufferEvent) {mLastLowBufferFeed = totalFeeds;}
                if (isZeroCrossingEvent) {mLastZeroFeed = totalFeeds;}
                mainThreadHandler.post(() -> invokeFeedCallback(remainingFrames));
            }
        }

        mAudioTrack.stop();
        mAudioTrack.flush();
        mAudioTrack.release();
        mAudioTrack = null;
    }


    /** Splits into at most `maxSize`-BYTE views sharing `buffer` (no copy). */
    private List<ByteBuffer> split(byte[] buffer, int maxSize) {
        List<ByteBuffer> chunks = new ArrayList<>();
        int offset = 0;
        while (offset < buffer.length) {
            int length = Math.min(buffer.length - offset, maxSize);
            ByteBuffer b = ByteBuffer.wrap(buffer, offset, length);
            chunks.add(b);
            offset += length;
        }
        return chunks;
    }
}
