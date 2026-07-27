package com.lib.flutter_pcm_sound;

import android.os.Build;
import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;
import android.media.AudioAttributes;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.util.Log; // [BeaverTalk debug] underrun 계측

import androidx.annotation.NonNull;

import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicLong; // [BeaverTalk fix] 재생/피드 락 분리용 큐 잔량 카운터
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
    private static final int MAX_FRAMES_PER_BUFFER = 200;

    // [BeaverTalk patch] AudioTrack underrun 방지용 버퍼 배수.
    // 원본은 getMinBufferSize() 최소치를 그대로 setBufferSizeInBytes 에 넘겨, 재생 스레드가
    // 잠깐만 밀려도 underrun("라디오 신호 안 좋을 때처럼" 버벅임)이 났다. 안드로이드 전용 증상.
    // 최소치의 배수로 실제 재생 쿠션을 확보한다. 부족하면 이 값을 6~8로 올린다.
    // 근거: docs/2026-07-26_1517_android-audiotrack-underrun-buffer-fix.md
    private static final int BUFFER_MULTIPLIER = 4; // 무난한 기준(마이크 격리 테스트용)

    private MethodChannel mMethodChannel;
    private Handler mainThreadHandler = new Handler(Looper.getMainLooper());
    private Thread playbackThread;
    private volatile boolean mShouldCleanup = false;

    private AudioTrack mAudioTrack;
    private int mNumChannels;
    private int mSampleRate; // [BeaverTalk debug] 큐 깊이 ms 환산용
    private int mMinBufferSize;
    private boolean mDidSetup = false;

    // [BeaverTalk fix] 재생 스레드와 feed() 가 더 이상 mSamples 락을 공유하지 않도록,
    // 공유 상태를 lock-free 로 바꿨다. 큐 잔량은 O(n) 스캔 대신 add/take 때 O(1) 로 가감.
    private volatile long mFeedThreshold = 8000;
    private final AtomicLong mTotalFeeds = new AtomicLong(0);
    private final AtomicLong mQueuedBytes = new AtomicLong(0); // mSamples 에 남은 총 바이트
    private long mLastLowBufferFeed = 0; // 재생 스레드 전용
    private long mLastZeroFeed = 0;      // 재생 스레드 전용

    // [BeaverTalk fix] 작은 8ms write 를 모아 큰 덩어리로 write(코얼레싱)하기 위한 상태.
    private byte[] mScratch;            // 청크 결합용 재사용 버퍼(입력 레이트, 재생 스레드 전용)
    private int mMaxChunkBytes;         // 한 청크 최대 바이트(오버플로 가드)
    private int mCoalesceTargetBytes;   // 한 번 write 에 모을 목표 바이트(~300ms)

    // [BeaverTalk fix] non-fast track 회피: 24kHz 입력을 기기 네이티브(48kHz)로 업샘플해 write.
    // 트랙 레이트가 네이티브와 같아야 fast track 이 되어 write() 지연(~130ms)이 사라진다.
    private int mUpsample;              // 업샘플 배수(24k→48k = 2, 그 외 1)
    private byte[] mScratchOut;         // 업샘플 결과(출력 레이트) 버퍼

    // [BeaverTalk fix] 큐가 비어도 트랙을 놀리지 않도록 채워 넣는 무음(출력 레이트 ~20ms).
    // AudioFlinger 가 유휴 트랙을 active list 에서 빼면(BUFFER TIMEOUT) 재활성화에 ~130ms 걸려
    // write 가 정지한다 → 무음으로 계속 먹여 트랙을 살려둔다.
    private byte[] mSilence;

    // [BeaverTalk 계측] 스트림 인플레이션 측정.
    // 가설: 큐가 5ms 만 비어도 20ms 무음을 주입 → 뒤 오디오가 영구히 밀려 백로그가 단조 증가.
    // 검증 핵심 = (쓴 오디오ms + 쓴 무음ms) / 경과ms 가 1.0 을 넘는가, 그리고 무음이
    // "발화 중 짧은 구멍"(런 길이 1~3)인가 "턴 사이 정상 무음"(런 길이 큼)인가.
    private long mStatsStartMs, mLastStatsMs;
    private long mWroteAudioBytes, mWroteSilenceBytes;
    private long mSilFills, mSilRun, mSilRun1, mSilRun2_3, mSilRun4_10, mSilRunBig;
    private long mHeadAtStart = -1;

    /** 무음 런이 끝났을 때 길이를 히스토그램에 넣는다(발화 중 구멍 vs 턴 사이 무음 구분). */
    private void closeSilenceRun() {
        if (mSilRun <= 0) return;
        if (mSilRun == 1) mSilRun1++;
        else if (mSilRun <= 3) mSilRun2_3++;
        else if (mSilRun <= 10) mSilRun4_10++;
        else mSilRunBig++;
        mSilRun = 0;
    }

    /** 5초마다 인플레이션 통계 로그. 무음 경로에서도 불려야 하므로 양쪽 모두에서 호출한다. */
    private void maybeLogStats(int trackRate) {
        long now = SystemClock.elapsedRealtime();
        if (mLastStatsMs == 0) { mStatsStartMs = now; mLastStatsMs = now; return; }
        if (now - mLastStatsMs < 5000) return;
        mLastStatsMs = now;
        long elapsed = now - mStatsStartMs;
        int bytesPerMs = trackRate * 2 * mNumChannels / 1000;
        long audMs = mWroteAudioBytes / bytesPerMs;
        long silMs = mWroteSilenceBytes / bytesPerMs;
        // AudioTrack 이 실제로 재생한 양(프레임) — 우리가 "쓴" 양과 비교해 지연이 어디 쌓였는지 본다.
        long playedMs = -1;
        try {
            long head = mAudioTrack.getPlaybackHeadPosition() & 0xFFFFFFFFL;
            if (mHeadAtStart < 0) mHeadAtStart = head;
            playedMs = (head - mHeadAtStart) * 1000L / trackRate;
        } catch (Throwable ignored) {}
        long wrote = audMs + silMs;
        Log.w("BeaverTalkPCM", "PCMSTATS elapsed=" + elapsed + "ms wroteAud=" + audMs
            + "ms wroteSil=" + silMs + "ms wrote/elapsed=" + (elapsed > 0 ? (wrote * 100 / elapsed) : 0)
            + "% played=" + playedMs + "ms silFills=" + mSilFills
            + " silRuns 1:" + mSilRun1 + " 2-3:" + mSilRun2_3 + " 4-10:" + mSilRun4_10
            + " >10:" + mSilRunBig + " qChunks=" + mSamples.size());
    }

    // Thread-safe queue for storing audio samples
    private final LinkedBlockingQueue<ByteBuffer> mSamples = new LinkedBlockingQueue<>();

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
                    mSampleRate = sampleRate;

                    // [BeaverTalk fix] 기기 네이티브 출력 레이트에 맞춰 트랙을 만든다(fast track).
                    // 24kHz 입력은 2배 업샘플해 48kHz 로 재생. 네이티브가 44.1k 등이면 배수 1(무변환).
                    int nativeRate = AudioTrack.getNativeOutputSampleRate(AudioManager.STREAM_MUSIC);
                    mUpsample = 1; // [test] 48k 업샘플이 오히려 write 를 210ms 로 악화 → 24k 유지
                    int trackRate = sampleRate * mUpsample;

                    // 코얼레싱/업샘플 버퍼(재생 스레드 전용). scratch 는 입력 1초, out 은 출력 1초.
                    int bytesPerSec = sampleRate * 2 * mNumChannels;
                    mMaxChunkBytes = MAX_FRAMES_PER_BUFFER * 2 * mNumChannels;
                    mCoalesceTargetBytes = 0; // [test] 코얼레싱 비활성 — 작은 write 가 더 나음
                    mScratch = new byte[bytesPerSec];                 // 입력(24k) 1s
                    mScratchOut = new byte[bytesPerSec * mUpsample];  // 출력(48k) 1s
                    mSilence = new byte[bytesPerSec * mUpsample * 20 / 1000]; // 출력 ~20ms 무음(0)

                    // Cleanup existing resources if any
                    if (mAudioTrack != null) {
                        cleanup();
                    }

                    int channelConfig = (mNumChannels == 2) ?
                        AudioFormat.CHANNEL_OUT_STEREO :
                        AudioFormat.CHANNEL_OUT_MONO;

                    mMinBufferSize = AudioTrack.getMinBufferSize(
                        trackRate, channelConfig, AudioFormat.ENCODING_PCM_16BIT);

                    if (mMinBufferSize == AudioTrack.ERROR || mMinBufferSize == AudioTrack.ERROR_BAD_VALUE) {
                        result.error("AudioTrackError", "Invalid buffer size.", null);
                        return;
                    }

                    // [BeaverTalk patch] 최소치 그대로 쓰지 않고 배수로 쿠션 확보 (underrun 방지).
                    int trackBufferSize = mMinBufferSize * BUFFER_MULTIPLIER;
                    Log.w("BeaverTalkPCM", "setup: inRate=" + sampleRate + " nativeRate=" + nativeRate
                        + " trackRate=" + trackRate + " up=" + mUpsample
                        + " minBuf=" + mMinBufferSize + "B trackBuf=" + trackBufferSize + "B mult=" + BUFFER_MULTIPLIER);

                    if (Build.VERSION.SDK_INT >= 23) { // Android 6 (Marshmallow) and above
                        mAudioTrack = new AudioTrack.Builder()
                            .setAudioAttributes(new AudioAttributes.Builder()
                                    .setUsage(AudioAttributes.USAGE_MEDIA)
                                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                                    .build())
                            .setAudioFormat(new AudioFormat.Builder()
                                    .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                                    .setSampleRate(trackRate) // [BeaverTalk fix] 네이티브 레이트
                                    .setChannelMask(channelConfig)
                                    .build())
                            .setBufferSizeInBytes(trackBufferSize)
                            .setTransferMode(AudioTrack.MODE_STREAM)
                            .build();
                    } else {
                        mAudioTrack = new AudioTrack(
                            AudioManager.STREAM_MUSIC,
                            trackRate, // [BeaverTalk fix] 네이티브 레이트
                            channelConfig,
                            AudioFormat.ENCODING_PCM_16BIT,
                            trackBufferSize,
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
                    mQueuedBytes.set(0); // [BeaverTalk fix] 큐 잔량 카운터도 리셋
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
                    List<ByteBuffer> chunks = split(buffer, MAX_FRAMES_PER_BUFFER);

                    // [BeaverTalk fix] mSamples(LinkedBlockingQueue) 는 스레드-안전하므로 락 없이 add.
                    // 재생 스레드가 이 add 때문에 블록되지 않는다(예전 synchronized 병목 제거).
                    for (ByteBuffer chunk : chunks) {
                        mSamples.add(chunk);
                    }
                    mQueuedBytes.addAndGet(buffer.length); // 청크 remaining 합 == buffer.length
                    mTotalFeeds.incrementAndGet();

                    result.success(true);
                    break;
                }
                case "setFeedThreshold": {
                    long feedThreshold = ((Number) call.argument("feed_threshold")).longValue();

                    mFeedThreshold = feedThreshold; // [BeaverTalk fix] volatile, 락 불필요

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

        int lastUnderrun = 0; // [BeaverTalk debug] underrun 카운트 변화 추적
        long loopCount = 0;   // [BeaverTalk debug] 하트비트용 반복 카운터
        long lastEnd = 0;     // [BeaverTalk debug] 직전 반복 종료 시각(gap 측정)

        while (!mShouldCleanup) {
            ByteBuffer data = null;

            // [BeaverTalk debug] write 와 write 사이 공백(gap) = 스레드가 CPU 를 뺏겼거나 큐가 빈 시간.
            long tGapStart = SystemClock.elapsedRealtime();
            long gapMs = (lastEnd > 0) ? (tGapStart - lastEnd) : 0;

            try {
                // [BeaverTalk fix] 무한 블록 대신 짧게 poll. 데이터 없으면 무음을 써서 트랙을 살려둔다.
                data = mSamples.poll(5, TimeUnit.MILLISECONDS);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                continue;
            }

            // [BeaverTalk debug] take 소요 = 큐가 비어 Dart 피드를 기다린 시간(A).
            long tAfterTake = SystemClock.elapsedRealtime();
            long takeMs = tAfterTake - tGapStart;

            // [BeaverTalk fix] 큐가 비었다 → 무음을 채워 AudioTrack 을 계속 active 로 유지.
            // 이러면 AudioFlinger 가 트랙을 빼지 않아(BUFFER TIMEOUT 방지) 재활성화 130ms 정지가 안 난다.
            if (data == null) {
                mAudioTrack.write(mSilence, 0, mSilence.length, AudioTrack.WRITE_BLOCKING);
                lastEnd = SystemClock.elapsedRealtime();
                // [BeaverTalk 계측] 무음 주입 1회. 런 길이로 "발화 중 구멍" vs "턴 사이"를 가른다.
                mSilFills++;
                mSilRun++;
                mWroteSilenceBytes += mSilence.length;
                maybeLogStats(mSampleRate * mUpsample);
                if (takeMs > 60) {
                    Log.w("BeaverTalkPCM", "SILENCE-FILL waited=" + takeMs + "ms (큐 빔, 트랙 유지)");
                }
                continue;
            }
            // [BeaverTalk 계측] 오디오가 다시 나왔다 → 직전 무음 런을 히스토그램에 확정.
            closeSilenceRun();

            // [BeaverTalk fix] 코얼레싱: 방금 꺼낸 청크에 이어, 지금 큐에 바로 있는 청크들을
            // (블록 없이 poll) scratch 에 모아 목표(~300ms)까지 채운 뒤 "한 번에" write 한다.
            // write 호출당 붙는 HAL 지연(~130ms)을 청크 수백 개가 아니라 write 한 번에만 물리게 해
            // 재생이 실시간을 넉넉히 따라잡게 만든다.
            int total = data.remaining();
            data.get(mScratch, 0, total);
            while (total < mCoalesceTargetBytes && total + mMaxChunkBytes <= mScratch.length) {
                ByteBuffer more = mSamples.poll(); // 비블록: 지금 있는 것만
                if (more == null) break;
                int r = more.remaining();
                more.get(mScratch, total, r);
                total += r;
            }
            mQueuedBytes.addAndGet(-total); // 꺼낸 만큼 잔량 감산 (O(1))

            // [BeaverTalk fix] 입력(24k) → 출력(48k) 업샘플: 각 프레임을 mUpsample 번 복제.
            // 트랙이 네이티브 레이트라 fast track → write() 지연이 거의 없어진다.
            int outLen;
            if (mUpsample == 1) {
                outLen = total;
                System.arraycopy(mScratch, 0, mScratchOut, 0, total);
            } else {
                int frameBytes = 2 * mNumChannels;
                outLen = 0;
                for (int i = 0; i < total; i += frameBytes) {
                    for (int u = 0; u < mUpsample; u++) {
                        System.arraycopy(mScratch, i, mScratchOut, outLen, frameBytes);
                        outLen += frameBytes;
                    }
                }
            }
            mAudioTrack.write(mScratchOut, 0, outLen, AudioTrack.WRITE_BLOCKING);
            mWroteAudioBytes += outLen; // [BeaverTalk 계측]
            maybeLogStats(mSampleRate * mUpsample);

            // [BeaverTalk debug] write 소요 = AudioTrack/HAL 이 데이터를 받는 데 걸린 시간.
            long tAfterWrite = SystemClock.elapsedRealtime();
            long writeMs = tAfterWrite - tAfterTake;
            lastEnd = tAfterWrite;
            // fast track 이면 write 가 짧아야 정상. 여전히 100ms대면 이 가설도 틀린 것.
            if (gapMs > 60 || takeMs > 60 || writeMs > 60) {
                Log.w("BeaverTalkPCM", "STALL gap=" + gapMs + "ms take=" + takeMs
                    + "ms write=" + writeMs + "ms inBytes=" + total + " outBytes=" + outLen
                    + " qLeft~" + mSamples.size() + "ch");
            }

            // [BeaverTalk debug] AudioTrack 내부 버퍼가 실제로 바닥났는지(underrun) 계측.
            // 버벅이는 순간 이 카운트가 오르면 underrun 확정, 안 오르면 원인은 딴 데(리샘플링 등).
            if (Build.VERSION.SDK_INT >= 24) {
                int u = mAudioTrack.getUnderrunCount();
                if (u != lastUnderrun) {
                    // qChunks: underrun 순간 native 큐에 남은 청크 수(1청크≈8.3ms).
                    // ~0 이면 Dart 가 안 먹여서 굶음(A, 위쪽 문제), 크면 native 가 못 빼는 것(B, 여기 문제).
                    int qChunks = mSamples.size();
                    Log.w("BeaverTalkPCM", "UNDERRUN count=" + u + " (+" + (u - lastUnderrun)
                        + ") qChunks=" + qChunks + " (~" + (qChunks * 200 * 1000 / (mSampleRate)) + "ms)");
                    lastUnderrun = u;
                }
            }

            // [BeaverTalk debug] ~5초마다 큐 깊이 하트비트 (1분에 걸쳐 큐가 자라는지 추세 확인).
            if (++loopCount % 600 == 0) {
                int qChunks = mSamples.size();
                Log.w("BeaverTalkPCM", "HEARTBEAT loop=" + loopCount + " qChunks=" + qChunks
                    + " (~" + (qChunks * 200 * 1000 / mSampleRate) + "ms) underruns=" + lastUnderrun);
            }

            // [BeaverTalk fix] 예전엔 여기서 synchronized(mSamples) 로 큐 전체를 O(n) 스캔했고,
            // feed() 도 같은 락을 잡아 재생 스레드가 피드 순간마다 블록 → underrun 이었다.
            // 이제 락 없이 O(1) 카운터로 잔량을 읽는다.
            long remainingFrames = mQueuedBytes.get() / (2 * mNumChannels);
            long totalFeeds = mTotalFeeds.get();
            long feedThreshold = mFeedThreshold;

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
