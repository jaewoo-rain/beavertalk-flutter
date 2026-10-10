package com.lib.flutter_pcm_sound;

import android.os.Build;
import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTimestamp;
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
import io.flutter.plugin.common.StandardMethodCodec;

/**
 * FlutterPcmSoundPlugin implements a "one pedal" PCM sound playback mechanism.
 * Playback starts automatically when samples are fed and stops when no more samples are available.
 */
public class FlutterPcmSoundPlugin implements
    FlutterPlugin,
    MethodChannel.MethodCallHandler
{
    private static final String CHANNEL_NAME = "flutter_pcm_sound/methods";
    // [BeaverTalk fix 2026-08-13] 한 조각의 **바이트** 상한.
    //
    // ⛔ 예전 이름은 `MAX_FRAMES_PER_BUFFER = 200` 이었는데 **단위가 어긋나 있었다**:
    //   `split()` 은 이 값을 **바이트**로 쓰고(`Math.min(len - offset, maxSize)`),
    //   `mMaxChunkBytes` 는 **프레임**으로 보고 `×2×채널` 을 곱했다. 즉 실제 조각은
    //   200B(=100프레임)인데 코얼레싱 한계는 400B 로 계산됐다. 이름을 바이트로 통일한다.
    //
    // ## 왜 200B 가 문제였나 (실측으로 확정)
    //   feed 1회 72,000B ÷ 200B = **조각 360개**, 초당 25회 → **9,000 객체/초**
    //   (ByteBuffer + ArrayList 원소 + LinkedBlockingQueue 노드)
    //   `feed` 핸들러는 **안드로이드 UI 스레드**에서 돈다 → 힙 압박 → GC 정지 누적 →
    //   UI 스레드 정체 → **모든 채널 호출이 대기**한다.
    //   실측(6분 라이브 통화): 아무 일도 안 하는 `ping` 왕복이 4ms → **3,155ms**.
    //   원본 주석은 `// Split for better performance` 뿐인데, 그건 **콜백(풀) 모델** 전제로
    //   보인다 — 우리는 푸시 모델이라 잘게 쪼개서 얻는 게 없다.
    //
    // ## 왜 "안 쪼개기"가 아니라 4,800B 인가 — 두 상한 사이에서 골랐다
    //   ⛔ 위: `mScratch` 가 **1초치(48,000B)** 다. Dart 의 feed 상한이 72,000B 이므로
    //      안 쪼개면 `data.get(mScratch, 0, total)` 에서 **넘친다**(즉시 크래시).
    //   ⛔ 아래: `write()` 는 WRITE_BLOCKING 이라 조각이 클수록 재생 스레드가 **한 번에
    //      오래 잡힌다**. 그 구간이 `clear()`(barge-in)의 `write_in_flight` 창이다.
    //   ⇒ **100ms 분량(24kHz mono = 4,800B)** 으로 잡는다. 트랙 버퍼가 이미 ~166ms
    //     (minBuf×4)라 그보다 짧아 응답성 손해가 그 안에 묻히고, 할당은
    //     9,000 → **375 객체/초(96% 감소)** 가 된다.
    //   ⚠ 스테레오면 같은 바이트가 50ms 가 된다(우리는 mono). 상한의 성격은 그대로다.
    private static final int MAX_CHUNK_BYTES = 4800;

    // [BeaverTalk patch] AudioTrack underrun 방지용 버퍼 배수.
    // 원본은 getMinBufferSize() 최소치를 그대로 setBufferSizeInBytes 에 넘겨, 재생 스레드가
    // 잠깐만 밀려도 underrun("라디오 신호 안 좋을 때처럼" 버벅임)이 났다. 안드로이드 전용 증상.
    // 최소치의 배수로 실제 재생 쿠션을 확보한다. 부족하면 이 값을 6~8로 올린다.
    // 근거: docs/2026-07-26_1517_android-audiotrack-underrun-buffer-fix.md
    private static final int BUFFER_MULTIPLIER = 4; // 무난한 기준(마이크 격리 테스트용)

    private MethodChannel mMethodChannel;
    private Handler mainThreadHandler = new Handler(Looper.getMainLooper());

    // ⭐⭐ [계측 2026-09-03] **안드로이드 메인 루퍼 심박계.**
    //
    //   ⛔ 왜 필요한가 — 우리는 5분 내내 **틀린 스레드를 재고 있었다.**
    //     실측(통화로그.txt): 386초 지점에 `Choreographer: Skipped 139 frames`(= 메인 2.3초
    //     정지)가 찍힌 바로 그 창에서 Dart 이벤트루프 지연(`elLagMax`)은 **17ms** 였다.
    //     두 값이 같은 스레드일 수 없다 ⇒ "Dart 가 평평하니 메인도 괜찮다"는 추론이
    //     성립한 적이 없다. 그런데 앱에는 메인 루퍼를 재는 계기가 **하나도 없었다.**
    //
    //   ⭐ 이 프로브가 답하는 질문은 하나다:
    //       `ping` 왕복(4ms→2,858ms, 지수 1.65)이 **메인 루퍼 적체를 그대로 받는가.**
    //         따라간다 → 레코더가 메인을 물고 있는 것이 원인. 확정
    //         안 따라간다 → 레코더 무죄. 범인은 엔진 메시징 쪽
    //     에이전트 둘이 이 지점에서 정반대로 답했고 소스만으로는 못 갈렸다. 재서 끝낸다.
    //
    //   ⚠ **블로킹하지 않는다.** ping 안에서 메인을 기다리면 그 대기가 곧 ping 값이 되어
    //     측정이 측정을 오염시킨다. 대신 20ms 자기재게시 프로브를 따로 돌려 «예정보다
    //     얼마나 늦게 실행됐나»의 최대값을 모아 두고, ping 이 그걸 가져가며 리셋한다.
    //   ⚠ 20ms 는 Dart 쪽 `_elProbeTimer`(normalcall_controller.dart)와 **일부러 같은 주기**다.
    //     같은 주기로 재야 두 숫자를 나란히 놓고 읽을 수 있다.
    private static final long MAIN_PROBE_PERIOD_MS = 20;
    private long mainProbeMaxLateMs = 0;
    private long mainProbeNextAtMs = 0;
    private boolean mainProbeRunning = false;

    private final Runnable mainProbe = new Runnable() {
        @Override
        public void run() {
            if (!mainProbeRunning) return;
            long now = SystemClock.uptimeMillis();
            long late = now - mainProbeNextAtMs;   // 예정 시각 대비 지각
            if (late > mainProbeMaxLateMs) mainProbeMaxLateMs = late;
            // ⚠ 지각분을 더해 다음 예정을 잡는다 — 안 그러면 지각이 누적돼 계속 커진다.
            mainProbeNextAtMs = now + MAIN_PROBE_PERIOD_MS;
            mainThreadHandler.postAtTime(this, mainProbeNextAtMs);
        }
    };

    private void startMainProbe() {
        if (mainProbeRunning) return;
        mainProbeRunning = true;
        mainProbeMaxLateMs = 0;
        mainProbeNextAtMs = SystemClock.uptimeMillis() + MAIN_PROBE_PERIOD_MS;
        mainThreadHandler.postAtTime(mainProbe, mainProbeNextAtMs);
    }

    private void stopMainProbe() {
        mainProbeRunning = false;
        mainThreadHandler.removeCallbacks(mainProbe);
    }
    private Thread playbackThread;
    private volatile boolean mShouldCleanup = false;

    private AudioTrack mAudioTrack;
    private int mNumChannels;
    private int mSampleRate; // [BeaverTalk debug] 큐 깊이 ms 환산용
    private int mMinBufferSize;
    private int mTrackBufferBytes = 0; // (beavertalk patch) getStats 계측용 — 실제 트랙 버퍼 크기
    private boolean mDidSetup = false;

    // [BeaverTalk fix] 재생 스레드와 feed() 가 더 이상 mSamples 락을 공유하지 않도록,
    // 공유 상태를 lock-free 로 바꿨다. 큐 잔량은 O(n) 스캔 대신 add/take 때 O(1) 로 가감.
    private volatile long mFeedThreshold = 8000;
    private final AtomicLong mTotalFeeds = new AtomicLong(0);
    private final AtomicLong mQueuedBytes = new AtomicLong(0); // mSamples 에 남은 총 바이트
    private long mLastLowBufferFeed = 0; // 재생 스레드 전용
    private long mLastZeroFeed = 0;      // 재생 스레드 전용

    // [BeaverTalk fix] AudioTrack 에 이미 넘긴(=아직 스피커에서 안 나온) 출력 프레임 수.
    //
    // ⚠ 이게 없으면 remainingFrames 가 **mSamples 큐만** 세어, AudioTrack 버퍼
    //   (minBufferSize × BUFFER_MULTIPLIER — 기기에 따라 최대 800ms 넘는다) 만큼을
    //   통째로 빠뜨린다. Dart 는 그 값으로 "재생이 끝났나"를 판단해 마이크를 여는데
    //   (_audioDrained), 실제로는 스피커가 아직 울리는 중이라 비버 목소리를 그대로
    //   되먹는다 → 그게 user 발화로 전사되고 → 모델이 자기 말에 답하고 → 무한 루프.
    //   실측 call_id=855(2026-08-01): 유저 턴의 절반이 비버 대사였다.
    private final AtomicLong mWrittenOutFrames = new AtomicLong(0);

    // [BeaverTalk barge-in] clear() 세대 카운터.
    //
    // ⚠ 큐를 비우고 AudioTrack 을 flush 하는 것만으로는 부족하다. 재생 스레드는 이미
    //   mSamples 에서 청크를 **꺼내 들고**(mScratch 로 복사한 뒤) write 로 향하는 중일 수
    //   있는데, 그건 큐에도 트랙에도 없어서 어느 쪽을 지워도 안 지워진다. 그대로 두면
    //   취소된 턴의 마지막 조각이 flush 직후에 스피커로 나간다 —
    //   "끊었는데 비버가 한 마디 더 하는" 증상이 정확히 이것이다.
    //
    //   그래서 재생 스레드는 poll 직후 이 값을 읽어 두고, write 직전에 다시 비교한다.
    //   달라져 있으면 그 버퍼를 **버린다**. 이미 write 안으로 들어간 것만 남고, 그건
    //   write 한 번의 소요(수십 ms)로 상한이 잡힌다.
    private final AtomicLong mClearGen = new AtomicLong(0);

    // [BeaverTalk barge-in] 큐에서 꺼냈지만 아직 write 하지 않은 입력 바이트.
    //
    // ⚠ 이게 없으면 잔량 계산에 **구멍**이 생긴다. 재생 스레드는 큐에서 꺼내는 즉시
    //   mQueuedBytes 를 감산하는데, 그 오디오가 mWrittenOutFrames 에 잡히는 건 write 가
    //   끝난 뒤다. 그 사이(업샘플 루프 + write, 실측 STALL 로그 기준 수 ms~60ms) 그 바이트는
    //   **어느 쪽에도 안 세어진다.** 평소엔 무해하지만 clear() 가 하필 그때 들어오면
    //   frames_discarded 가 그만큼 적게 나가고, Dart 원장이 "그만큼 더 들었다"로 계산해
    //   서버 대화 이력에 사용자가 듣지도 않은 문장이 들은 것으로 박힌다.
    private final AtomicLong mPolledNotWrittenBytes = new AtomicLong(0);

    // [BeaverTalk barge-in] 재생 스레드가 실오디오를 **쓰기로 확정했는가**
    // (= gen 재검사를 통과할 참이거나, 이미 write() 안에 있다).
    //
    // clear() 가 "실제로 조용해진 시각"을 보고할 수 있는지를 가른다. 이 구간에 걸리면
    // 그 데이터는 우리 flush **뒤에** 트랙으로 들어가고(=잠깐 소리가 남고), 재생 스레드가
    // 세대 변화를 보고 스스로 회수(flushTrackNow)할 때까지 기다려야 진짜 무음이 된다.
    // 그 회수는 clear() 가 반환한 뒤에 일어나므로 반환값에 담을 수 없다 — 대신 "지금
    // 그 창에 있다"는 사실을 알려서, 호출부가 측정 지점을 hal_drained 가 아니라
    // clear_returned(하한)로 낮추게 한다.
    //
    // ⚠ 이름이 "write 중"이 아니라 "쓰기로 확정"인 것이 중요하다. gen 재검사 **이전에**
    //   세워야 clear() 와 Dekker 짝이 되어 창이 닫힌다(설정 위치의 주석 참조).
    //   write() 진입 직전으로 늦추면 그 사이에 끼어든 clear 가 false 를 읽고 hal_drained
    //   로 잘못 보고한다.
    //
    // 무음 write 는 일부러 표시하지 않는다. 무음이 flush 뒤에 새어도 들리지 않는다.
    private volatile boolean mAudioWritePending = false;

    /**
     * 트랙 버퍼를 지금 비운다(트랙은 살려 둔다).
     *
     * flush() 는 재생 중에는 no-op 이라 pause → flush → play 순서가 필수다.
     * 재생 헤드가 0 으로 돌아가므로 mWrittenOutFrames 도 같이 맞춘다 — 안 맞추면
     * in-flight(= written − head) 가 영구히 부풀어 마이크가 다시는 안 열린다.
     *
     * clear() 핸들러(플랫폼 스레드)와 재생 스레드 양쪽에서 부른다. 둘이 겹쳐도
     * 각 호출은 pause/flush/play 를 온전히 수행하고, 잘못된 상태는
     * IllegalStateException 으로 떨어져 여기서 흡수된다.
     */
    private void flushTrackNow(String why) {
        AudioTrack track = mAudioTrack;
        if (track == null) return;
        try {
            track.pause();
            track.flush();
            track.play();
            mWrittenOutFrames.set(0);
            Log.w("BeaverTalkPCM", "flushTrackNow: " + why);
        } catch (IllegalStateException e) {
            // 트랙 해제 경합 — 어차피 소리는 안 난다.
            Log.w("BeaverTalkPCM", "flushTrackNow skipped — " + e);
        }
    }

    /** 실제 잔여 재생량(입력 레이트 프레임) = 대기 큐 + 꺼내둔 것 + AudioTrack 미방출분. */
    private long remainingInputFrames() {
        // setup 전이면 mNumChannels/mUpsample 이 0 이라 나눗셈이 터진다(호출 경로상
        // 일어나면 안 되지만, 여기서 죽으면 재생 스레드가 통째로 멈춘다).
        if (mNumChannels <= 0 || mUpsample <= 0) return 0;
        long queued =
            (mQueuedBytes.get() + mPolledNotWrittenBytes.get()) / (2 * mNumChannels);
        AudioTrack track = mAudioTrack;
        if (track == null) return queued;
        long inFlightOut;
        try {
            // getPlaybackHeadPosition 은 32bit 랩어라운드 카운터라 부호 없는 값으로 읽는다.
            long head = track.getPlaybackHeadPosition() & 0xFFFFFFFFL;
            inFlightOut = mWrittenOutFrames.get() - head;
        } catch (Throwable ignored) {
            return queued; // 트랙 해제 경합 → 큐만으로 폴백(예전 동작)
        }
        if (inFlightOut < 0) inFlightOut = 0; // 랩어라운드/flush 직후 방어
        // 출력은 업샘플된 레이트라 입력 프레임으로 되돌린다(Dart 는 24k 기준으로 센다).
        return queued + inFlightOut / mUpsample;
    }

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
        // ⭐ [BeaverTalk fix 2026-08-14] 이 채널을 **전용 백그라운드 큐**로 뺀다.
        //
        // 실기기 실측(408초 대화판)에서 결정적 증거가 나왔다:
        //     queue 272,788B(5.7초 분량)  ·  PUMP: engine now 0ms  ·  빈채널왕복 2,858ms
        //     그리고 logcat: "Skipped 139 frames! ... too much work on its main thread."
        // **오디오는 Dart 에 다 와 있는데 네이티브로 못 내려간다.** 도착 문제가 아니라
        // 플랫폼 채널이 메인 스레드 줄에 서 있다가 2.4~3.1초씩 밀리는 것이다.
        //
        // ⛔ 채널은 **가해자가 아니라 피해자다.** 무엇이 메인 스레드를 막든(우리 실측으로는
        //   AudioRecord 가 열려 있는 것 자체였다) 오디오가 그 줄에 서 있는 한 굶는다.
        //   그래서 원인을 못 없애도 **오디오를 그 줄에서 빼는 것**은 할 수 있다.
        //   조용한 통화(2026-08-13 오전 6판)에서는 채널에 실을 오디오가 거의 없어서
        //   이게 안 보였다 — 대화가 있는 실기기 판에서야 드러났다.
        //
        // ── 동시성 감사 (이 변경 전에 확인한 것) ─────────────────────────────
        // 이 큐는 **직렬(serial)** 이다. 핸들러끼리는 여전히 서로 겹치지 않는다
        // (setup/feed/clear/release 가 동시에 돌지 않는다). 바뀌는 것은 「핸들러가 도는
        // 스레드가 메인이 아니다」 하나뿐이고, **핸들러↔재생스레드**는 원래부터 교차
        // 스레드였다. 그 공유 상태는 이미 다 보호돼 있다:
        //   mSamples          LinkedBlockingQueue
        //   mQueuedBytes · mWrittenOutFrames · mClearGen · mPolledNotWrittenBytes · mTotalFeeds
        //                     AtomicLong
        //   mShouldCleanup · mFeedThreshold · mAudioWritePending   volatile
        //   mSampleRate/mNumChannels/mUpsample/mScratch*/mSilence  setup 에서 **playbackThread.start()
        //                     이전에** 쓴다 → 스레드 시작이 happens-before 를 준다
        //   mDidSetup · mTrackBufferBytes  핸들러 전용(같은 직렬 큐) → 순서 보장
        // ⚠ 남는 것 하나: mAudioTrack 이 plain 필드다(재생 스레드 종료 시 null 대입).
        //   **이건 이 변경으로 새로 생긴 위험이 아니다** — 예전에도 메인↔재생 교차였다.
        //   스레드 수도 안 늘었다(핸들러 1 + 재생 1). 별건으로 다룬다.
        //
        // ⛔ 그리고 아래 invokeFeedCallback 은 **메인 스레드에 그대로 둔다**(:841 부근).
        //   나가는 invokeMethod 는 플랫폼 스레드에서 부르는 것이 안전한 계약이고,
        //   그 콜백은 백스톱이다 — 주 경로는 Dart 의 40ms 푸시 타이머다.
        mMethodChannel = new MethodChannel(
                messenger,
                CHANNEL_NAME,
                StandardMethodCodec.INSTANCE,
                messenger.makeBackgroundTaskQueue());
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
                    // 단위를 통일했다 — split 과 **같은 바이트 값**을 쓴다(예전엔 2배로 어긋났다).
                    mMaxChunkBytes = MAX_CHUNK_BYTES;
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
                    mTrackBufferBytes = trackBufferSize; // getStats 계측용
                    Log.w("BeaverTalkPCM", "setup: inRate=" + sampleRate + " nativeRate=" + nativeRate
                        + " trackRate=" + trackRate + " up=" + mUpsample
                        + " minBuf=" + mMinBufferSize + "B trackBuf=" + trackBufferSize + "B mult=" + BUFFER_MULTIPLIER);

                    // [BeaverTalk AEC] 통화 용도 오디오로 열지 여부. **기본은 false(=종전 동작)**.
                    //
                    // true 로 가면 플랫폼 AEC 가 참조할 다운링크가 생긴다. 대신 같이 바뀌는 게 있다:
                    //   - 볼륨 스트림이 미디어 → 통화로 넘어간다(볼륨 키가 조절하는 대상이 바뀐다)
                    //   - 기본 라우팅이 리시버(귀에 대는 구멍)로 빠질 수 있다 → 스피커 강제가 필요하다
                    //     (MainActivity.setVoiceCallMode 가 담당한다)
                    // 그래서 인자로 받아 런타임에 켜고 끈다 — 리그가 리빌드 없이 전/후를 재야 한다.
                    Boolean voiceArg = call.argument("voice_call_audio");
                    boolean voiceCallAudio = voiceArg != null && voiceArg;
                    Log.w("BeaverTalkPCM", "setup: voiceCallAudio=" + voiceCallAudio);

                    if (Build.VERSION.SDK_INT >= 23) { // Android 6 (Marshmallow) and above
                        mAudioTrack = new AudioTrack.Builder()
                            .setAudioAttributes(new AudioAttributes.Builder()
                                    .setUsage(voiceCallAudio
                                            ? AudioAttributes.USAGE_VOICE_COMMUNICATION
                                            : AudioAttributes.USAGE_MEDIA)
                                    .setContentType(voiceCallAudio
                                            ? AudioAttributes.CONTENT_TYPE_SPEECH
                                            : AudioAttributes.CONTENT_TYPE_MUSIC)
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
                            voiceCallAudio
                                ? AudioManager.STREAM_VOICE_CALL
                                : AudioManager.STREAM_MUSIC,
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
                    mPolledNotWrittenBytes.set(0); // [BeaverTalk barge-in] 직전 통화의 이월분 제거
                    // 새 트랙이라 playbackHead 도 0 부터 — 누적 write 카운터를 같이 리셋해야
                    // in-flight 계산이 어긋나지 않는다(안 하면 직전 통화분만큼 과대계상).
                    mWrittenOutFrames.set(0);
                    mShouldCleanup = false;

                    // start playback thread
                    playbackThread = new Thread(this::playbackThreadLoop, "PCMPlaybackThread");
                    playbackThread.setPriority(Thread.MAX_PRIORITY);
                    playbackThread.start();

                    mDidSetup = true;
                    // ⭐ [계측] 메인 루퍼 심박계를 통화와 같은 수명으로 돌린다(위 mainProbe 주석).
                    startMainProbe();

                    result.success(true);
                    break;
                }
                case "ping": {
                    // [계측] 핸들러 자체는 여전히 아무 일도 안 한다 — **채널 왕복**을 재려면
                    // 여기서 일하면 안 된다.
                    // ⭐ 다만 메인 루퍼 심박계가 모아 둔 «최대 지각»을 같이 실어 보낸다
                    //   (위 mainProbe 주석 참조). 한 줄에서 두 숫자가 나와야
                    //   «ping 이 메인 적체를 그대로 받는가»를 눈으로 대조할 수 있다.
                    long mainLate = mainProbeMaxLateMs;
                    mainProbeMaxLateMs = 0;             // 창마다 리셋(최대값 창 계측)
                    Map<String, Object> pong = new HashMap<>();
                    pong.put("main_late_ms", mainLate);
                    pong.put("main_probe", mainProbeRunning);
                    result.success(pong);
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

                    // [BeaverTalk fix] mSamples(LinkedBlockingQueue) 는 스레드-안전하므로 락 없이 add.
                    // 재생 스레드가 이 add 때문에 블록되지 않는다(예전 synchronized 병목 제거).
                    for (ByteBuffer chunk : chunks) {
                        mSamples.add(chunk);
                    }
                    mQueuedBytes.addAndGet(buffer.length); // 청크 remaining 합 == buffer.length
                    mTotalFeeds.incrementAndGet();

                    // [BeaverTalk fix] enqueue 직후 잔량(frames)을 돌려준다.
                    // Dart 가 콜백(핑퐁)을 기다리지 않고 능동적으로 채우려면 native 큐가 지금
                    // 얼마나 남았는지 알아야 한다. 이미 오가는 메서드 채널 응답에 값만 실으므로
                    // 추가 홉/추가 메인스레드 왕복이 없다. 예전엔 그냥 true 였다.
                    result.success(remainingInputFrames());
                    break;
                }
                // (beavertalk patch) O(1) diagnostics snapshot: how much audio is
                // waiting, in how many pieces, and how many underruns AudioTrack has
                // seen since setup. Lets the app log whether any of these creep up
                // over a 5-minute call. 락프리 카운터를 쓰므로 synchronized 가 없다.
                case "getStats": {
                    Map<String, Object> stats = new HashMap<>();
                    AudioTrack track = mAudioTrack;
                    stats.put("queued_bytes", mQueuedBytes.get());
                    stats.put("chunks", mSamples.size());
                    stats.put("underruns",
                        (track != null && Build.VERSION.SDK_INT >= 24) ? track.getUnderrunCount() : -1);
                    stats.put("track_buffer_bytes", mTrackBufferBytes);
                    stats.put("total_feeds", mTotalFeeds.get());
                    result.success(stats);
                    break;
                }
                case "setFeedThreshold": {
                    long feedThreshold = ((Number) call.argument("feed_threshold")).longValue();

                    mFeedThreshold = feedThreshold; // [BeaverTalk fix] volatile, 락 불필요

                    result.success(true);
                    break;
                }
                // [BeaverTalk barge-in] 트랙을 죽이지 않고 대기 중인 재생을 즉시 버린다.
                //
                // release() 는 스레드까지 내려서 재기동에 setup() + 정착 대기가 붙는다.
                // barge-in 은 턴마다 일어나므로 그 비용을 낼 수 없다. 여기서는 트랙을
                // 살려둔 채 큐와 트랙 버퍼만 비운다 — 무음 keep-alive 도 그대로 돌아
                // AudioFlinger 가 트랙을 유휴로 빼는(재활성화 ~130ms) 일이 없다.
                //
                // 반환값 frames_discarded = **입력 프레임**(PCM24k 기준) 이다. 출력 프레임이
                // 아니다. 대기 큐 + 트랙 미방출분을 모두 포함하며, 비우기 **직전** 값이다.
                // 이 숫자가 "사용자가 실제로 어디까지 들었는가"의 근거가 되므로 추정이면
                // 안 된다 — 큐만 세면 트랙 버퍼(기기에 따라 800ms 초과)를 통째로 빠뜨려
                // call_id=855 자기-대화 루프와 같은 종류의 오차가 난다.
                case "clear": {
                    Map<String, Object> res = new HashMap<>();
                    AudioTrack track = mAudioTrack;
                    if (!mDidSetup || track == null) {
                        // setup 전이면 버릴 것도 없다. 에러가 아니다 — barge-in 이 통화
                        // 시작 직후에 들어올 수 있고, 그때 예외를 던지면 호출부가 폴백으로
                        // 떨어져 정확도만 잃는다.
                        res.put("frames_discarded", 0);
                        result.success(res);
                        break;
                    }

                    // ⭐ [계측] **네이티브 내부 소요**를 따로 잰다(2026-08-13).
                    //   호출부의 `폐기` 는 지금까지 한 덩어리였다: 플랫폼채널 왕복 +
                    //   네이티브 내부. 그래서 통화 내내 늘어나는 것을 봐도 **어디가
                    //   늘어나는지 못 갈랐다.** 여기 값이 평평한데 호출부 값만 크면
                    //   원인은 스레드 스케줄링(왕복)이고, 여기가 같이 크면 pause/flush 다.
                    long nativeT0 = System.nanoTime();

                    // ① 비우기 전에 잰다. 순서가 뒤바뀌면 항상 0 이 나온다.
                    long discarded = remainingInputFrames();

                    // ①-b HAL 잔량 — "취소 수신 → 실제 무음"을 재려면 이게 필요하다.
                    //
                    // flush() 는 **AudioTrack 버퍼**만 비운다. 이미 믹서/HAL 로 넘어간
                    // 오디오는 못 지우고 그대로 스피커에서 울린다. 그래서 flush 가 끝난
                    // 시점 = 무음 시점이 아니다. 그 차이를 안 세면 실효지연이 실제보다
                    // 낙관적으로 보고된다 — 목표(50~120ms) 판정이 걸려 있는 값이라
                    // 추정으로 두면 안 된다.
                    //
                    // getPlaybackHeadPosition = 트랙 버퍼에서 소비된 프레임,
                    // getTimestamp().framePosition = 실제로 제시됐거나 제시가 확정된 프레임.
                    // 둘의 차이가 곧 HAL 파이프라인에 남아 있는 양이다.
                    //
                    // ⚠ javadoc: "A timestamp may be temporarily unavailable while the audio
                    //   clock is stabilizing, or during and immediately after a route change.
                    //   A timestamp is permanently unavailable for a given route if the route
                    //   does not support timestamps." → 못 받을 수 있다. 그때는 0 을 주되
                    //   **모른다는 사실(hal_residual_known=0)을 같이 보고**한다. 0 을 조용히
                    //   섞으면 지연이 실제보다 좋아 보인다.
                    long halResidualMs = 0;
                    boolean halKnown = false;
                    try {
                        AudioTimestamp ts = new AudioTimestamp();
                        if (track.getTimestamp(ts)) {
                            long head = track.getPlaybackHeadPosition() & 0xFFFFFFFFL;
                            long behind = head - ts.framePosition;
                            if (behind < 0) behind = 0;
                            int outRate = mSampleRate * mUpsample;
                            if (outRate > 0) halResidualMs = behind * 1000L / outRate;
                            halKnown = true;
                        }
                    } catch (Throwable ignored) {
                        // 진단이 취소를 막으면 안 된다.
                    }

                    // ② 재생 스레드가 이미 꺼내 든 청크를 무효화한다(위 mClearGen 주석).
                    mClearGen.incrementAndGet();

                    // ③ 대기 큐 + 재생 스레드가 꺼내 들고 있던 것.
                    mSamples.clear();
                    mQueuedBytes.set(0);
                    mPolledNotWrittenBytes.set(0);

                    // ④ 트랙 내부 버퍼.
                    //    근거(AudioTrack javadoc, android-36.1 SDK 소스 실물 확인):
                    //      flush() — "Flushes the audio data currently queued for playback.
                    //      Any data that has been written but not yet presented will be
                    //      discarded. **No-op if not stopped or paused**, or if the track's
                    //      creation mode is not MODE_STREAM."
                    //      → 재생 중에 그냥 부르면 아무 일도 안 일어난다. pause 가 필수다.
                    //      우리 트랙은 MODE_STREAM 이다(setup 의 setTransferMode).
                    //      pause() — "Data that has not been played back will not be discarded."
                    //      → pause 만으로는 안 지워지고, 그래서 flush 가 따로 필요하다.
                    //      stop() 이 아니라 pause() 인 이유는 stop() 이 스트리밍 모드에서
                    //      남은 버퍼를 끝까지 내보내고 멈추기 때문이다 — 그러면 끊는 의미가 없다.
                    //
                    //    ⑤ flush() 는 재생 헤드를 0 으로 되돌리므로 mWrittenOutFrames 도 같이
                    //       맞춰야 한다. 근거(getPlaybackHeadPosition javadoc, 같은 SDK 소스):
                    //       "It is reset to zero by flush(), reloadStaticData(), and stop()."
                    //       안 맞추면 in-flight(= written − head) 가 영구히 부풀어
                    //       remainingInputFrames() 가 0 으로 안 내려간다 → 마이크가 다시는
                    //       안 열리고 통화 종료 배수도 막힌다.
                    //       ⚠ 여기서 0 으로 놓는 것만으로는 부족하다 — 재생 스레드가 write()
                    //         안에 있을 때 여기를 지나가면 스레드가 깨어나 다시 부풀린다.
                    //         그쪽 증가에도 세대 가드가 걸려 있다(playbackThreadLoop 참조).
                    //    ④⑤ 를 한 곳에 모아 둔다 — 재생 스레드도 같은 절차를 쓰므로
                    //       두 경로가 갈라지면 한쪽만 헤드 리셋을 빠뜨리게 된다.
                    flushTrackNow("clear: discarded=" + discarded + " inFrames");
                    res.put("frames_discarded", discarded);
                    // 호출부가 "실제 무음" 시각을 계산하는 데 쓴다. known=0 이면 값이 아니라
                    // **모른다**는 뜻이므로, 호출부는 그걸 리포트에 드러내야 한다.
                    res.put("hal_residual_ms", halResidualMs);
                    // 이 창에 걸렸으면 실제 무음은 flush 완료보다 늦다(위 mAudioWritePending 주석).
                    // ⚠ gen 증가 **뒤에** 읽어야 Dekker 짝이 성립한다. 순서를 바꾸지 마라.
                    res.put("write_in_flight", mAudioWritePending ? 1 : 0);
                    res.put("hal_residual_known", halKnown ? 1 : 0);
                    res.put("native_ms", (System.nanoTime() - nativeT0) / 1000000L);
                    result.success(res);
                    break;
                }
                case "release": {
                    stopMainProbe();   // ⭐ [계측] 심박계도 같이 내린다(통화 밖에선 안 돈다)
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
                // 오디오 분기와 같은 이유로 write 전후의 세대를 비교한다(아래 write 뒤 주석).
                final long genBeforeSilence = mClearGen.get();
                mAudioTrack.write(mSilence, 0, mSilence.length, AudioTrack.WRITE_BLOCKING);
                // 무음도 스피커에서 나가는 실제 시간을 차지한다 — 실오디오가 이 뒤에
                // 붙으면 그만큼 늦게 들린다. in-flight 에 반드시 포함해야 한다.
                // 단 write 중에 clear() 가 돌았으면 이 무음도 flush 로 사라졌다.
                if (genBeforeSilence == mClearGen.get()) {
                    mWrittenOutFrames.addAndGet(mSilence.length / (2 * mNumChannels));
                }
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

            // [BeaverTalk barge-in] 이 버퍼가 "언제 큐를 떠났는지"를 표시해 둔다.
            // write 직전에 다시 비교해, 그 사이 clear() 가 돌았으면 버린다.
            final long genAtPoll = mClearGen.get();

            // [BeaverTalk fix] 코얼레싱: 방금 꺼낸 청크에 이어, 지금 큐에 바로 있는 청크들을
            // (블록 없이 poll) scratch 에 모아 목표(~300ms)까지 채운 뒤 "한 번에" write 한다.
            // write 호출당 붙는 HAL 지연(~130ms)을 청크 수백 개가 아니라 write 한 번에만 물리게 해
            // 재생이 실시간을 넉넉히 따라잡게 만든다.
            // ⛔ **scratch 를 넘길 수 없다.** `mScratch` 는 1초치인데 조각 상한이 바뀌면
            //   (설정·다른 샘플레이트) 여기서 넘쳐 **재생 스레드가 통째로 죽는다.**
            //   조각 상한(4,800B)이 1초치보다 한참 작아 지금은 절대 안 걸리지만,
            //   상한을 만지는 다음 사람이 이 줄에서 크래시를 만나지 않게 잘라 쓴다.
            int avail = data.remaining();
            int total = Math.min(avail, mScratch.length);
            if (total < avail) {
                // ⛔ **조용히 버리지 않는다.** 여기서 잘린다는 건 오디오가 사라진다는 뜻이고,
                //   그건 에러 없이 "소리가 이상하다"로만 나타나 원인을 못 찾는다.
                Log.w("BeaverTalkPCM", "⚠ 조각이 scratch 보다 크다 — " + (avail - total)
                    + "B 버림(조각상한=" + MAX_CHUNK_BYTES + "B scratch=" + mScratch.length
                    + "B). 상한을 scratch 안으로 낮춰라.");
            }
            data.get(mScratch, 0, total);
            while (total < mCoalesceTargetBytes && total + mMaxChunkBytes <= mScratch.length) {
                ByteBuffer more = mSamples.poll(); // 비블록: 지금 있는 것만
                if (more == null) break;
                int r = more.remaining();
                more.get(mScratch, total, r);
                total += r;
            }
            // [BeaverTalk barge-in] poll 이후 clear() 가 돌았나. 돌았으면 이 버퍼는
            // 취소된 턴의 잔여다 — 잔량 감산도 write 도 하지 않고 버린다.
            // ⚠ 감산까지 건너뛰어야 한다. clear() 가 mQueuedBytes 를 0 으로 놓은 뒤
            //   여기서 또 빼면 음수로 내려가 remainingInputFrames() 가 영구히 틀어진다.
            //
            // ⚠ 플래그를 **가드보다 먼저** 세운다. 순서가 뒤바뀌면 창이 열린다:
            //   가드를 통과한 스레드는 다시 검사받지 않으므로, 통과 직후 플래그를 세우기
            //   전에 clear() 가 끼어들면 clear 는 플래그를 false 로 읽고 hal_drained 로
            //   보고하는데, 스레드는 곧 write 로 가서 방금 비운 트랙에 취소된 오디오를
            //   밀어넣는다. 실제 무음은 보고값보다 늦은데 서버는 합격 판정에 그대로 쓴다.
            //
            //   먼저 세우면 Dekker 배치가 되어 그 창이 닫힌다. 양쪽이 각자 자기 것을 쓴 뒤
            //   상대 것을 읽으므로(둘 다 volatile/Atomic = 순차일관), **둘 다 상대의 예전
            //   값을 읽는 일은 불가능**하다:
            //     - clear 가 플래그를 false 로 읽었다 → 이 스레드는 아직 플래그를 안 썼다
            //       → 아래 gen 재검사에서 clear 의 증가를 **반드시** 본다 → write 없이 버림
            //     - 이 스레드가 옛 gen 을 읽어 통과했다 → clear 는 플래그를 true 로 읽는다
            //       → clear_returned 로 강등
            //   즉 "플래그 false" 와 "가드 통과"가 상호배타가 된다.
            //
            //   대가는 가드에 걸려 버려질 버퍼도 잠깐 true 로 보인다는 것뿐이다. 그건
            //   소리가 안 나는데 하한으로 강등되는 쪽이라 안전한 방향의 오차다.
            mAudioWritePending = true;
            if (genAtPoll != mClearGen.get()) {
                mAudioWritePending = false;
                Log.w("BeaverTalkPCM", "clear raced playback — 꺼내둔 " + total + "B 폐기");
                lastEnd = SystemClock.elapsedRealtime();
                continue;
            }

            long qLeft = mQueuedBytes.addAndGet(-total); // 꺼낸 만큼 잔량 감산 (O(1))
            // clear() 와의 경합으로 음수가 되면 0 으로 되돌린다(위 가드가 대부분 막지만,
            // 감산 직전에 clear 가 끼어드는 창이 남는다). 음수를 두면 잔량이 과소 보고돼
            // 마이크가 너무 일찍 열린다.
            if (qLeft < 0) mQueuedBytes.compareAndSet(qLeft, 0);
            // 큐에서는 뺐지만 아직 스피커로 가지 않았다 — write 가 끝날 때까지 여기서 센다.
            mPolledNotWrittenBytes.addAndGet(total);

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
            try {
                mAudioTrack.write(mScratchOut, 0, outLen, AudioTrack.WRITE_BLOCKING);
            } finally {
                mAudioWritePending = false;
            }
            // ⛔ 이 증가를 무방비로 두면 **마이크가 영영 안 열린다.**
            //   write() 는 WRITE_BLOCKING 이라 수십 ms 를 잡아먹는데, 그 안에 clear() 가
            //   돌면 이 데이터는 flush 로 사라지고 재생 헤드는 0 으로 리셋된다. 그런데
            //   여기서 그대로 더하면 written 만 outLen 만큼 남아
            //   inFlight = written − head 가 **영구히** 그만큼 부풀어 오른 채 고정된다.
            //   remainingInputFrames() 가 0 으로 안 내려가니 Dart 의 _audioDrained 가
            //   영원히 false 고, 마이크 재개방도 통화 종료 배수도 다시는 안 걸린다.
            //   (clear() 가 mWrittenOutFrames.set(0) 을 한 **뒤에** 이 줄이 실행되는 게
            //    핵심이다 — set(0) 은 이 경합을 막아주지 못한다.)
            //
            //   세대가 바뀌었으면 이 write 의 결과는 이미 flush 된 것이므로 안 센다.
            //   반대 방향의 오차(약간 과소 보고)는 마이크가 조금 일찍 열리는 정도라
            //   락업보다 훨씬 가볍다.
            if (genAtPoll == mClearGen.get()) {
                mWrittenOutFrames.addAndGet(outLen / (2 * mNumChannels));
                long pLeft = mPolledNotWrittenBytes.addAndGet(-total);
                if (pLeft < 0) mPolledNotWrittenBytes.compareAndSet(pLeft, 0);
            } else {
                // write() 가 도는 중에 clear() 가 들어왔다. 이게 gen 가드로 못 막는
                // 유일한 창이다 — write 는 WRITE_BLOCKING 이라 트랙 버퍼가 가득 차면
                // 자리가 날 때까지 기다리는데, 그 사이 clear 의 flush() 가 자리를 비워주면
                // **취소된 턴의 오디오가 그 빈 자리로 들어가 그대로 재생된다.**
                // "끊었는데 비버가 한 마디 더 하는" 증상이 여기서 되살아난다.
                //
                // 그래서 우리가 방금 넣은 것을 우리가 지운다. 폐기 실효지연이 이 write 의
                // 길이(코얼레싱 목표 ~300ms)가 아니라 **감지 + flush 한 번**으로 묶인다.
                flushTrackNow("clear raced write — 방금 쓴 " + outLen + "B 회수");
            }
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
            long remainingFrames = remainingInputFrames();
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
