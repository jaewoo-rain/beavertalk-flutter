import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/atoms/mic_analysis.dart';
import '../../components/atoms/mic_button.dart';
import '../../components/atoms/record_circle_button.dart';
import '../../components/atoms/scan_cursor.dart';
import '../../components/chrome/bottom_cta_bar.dart';
import '../../components/icons/app_icons.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/bookmark/presentation/providers/bookmark_toggle_controller.dart';
import '../../features/character/presentation/providers/character_providers.dart';
import '../../features/normalcall/presentation/avatar_view.dart'
    show
        avatarAssetDirFor,
        kEmotionAngry,
        kEmotionHappy,
        kEmotionNeutral,
        kIdleListen,
        kIdleThink,
        kIdleWait;
import '../../features/normalcall/presentation/sync_avatar.dart';
import '../../features/pronunciation/domain/phoneme_diagram.dart';
import '../../features/pronunciation/presentation/articulation_sheet.dart';
import '../../features/review/data/audio_player.dart';
import '../../features/review/data/audio_recorder.dart';
import '../../features/review/data/wav_writer.dart';
import '../../features/review/domain/entities/review_feedback.dart';
import '../../features/review/presentation/review_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'learning_args.dart';

/// The step a learning sentence is at. All three are **states of one screen**,
/// not separate routes — a recording flows to scoring to its result without a
/// page transition, so the sentence, header and progress never slide.
///
/// This replaces the old `learningIntro → learningNext` push: `learning_next`
/// was the same layout (GNB, progress, speaker/bookmark, centred sentence) with
/// only the bottom controls and the sentence's colouring changed, so pushing it
/// read as a page move. Now it is [LearningPhase.result] here.
enum LearningPhase {
  /// Mic idle/recording — tap to capture, tap to submit.
  recording,

  /// The take is uploaded and scored; `ScanCursor` sweeps and `MicAnalysis`
  /// spins in the mic's place.
  scoring,

  /// The scored attempt: the sentence tinted per character, Native/Me playback,
  /// and retry/next.
  result,

  /// Scoring failed (`proto/E_failed` `3627:9822`) — same layout as [scoring]
  /// but the mic anchor is a retry button and the caption states the failure.
  /// Tapping retry returns to [recording] for the same sentence.
  failed,
}

/// How long scoring may run before the caption softens to
/// `analyzingTakingLonger` (`screen/learning_analysis__지연5s` `3745:2`).
///
/// The frame is named 지연**5s**, but 5s is too long to sit on a caption that
/// claims progress — 2s is the product's call (2026-07-17).
///
/// The frame's `SkipButton` (`3745:28`, 「건너뛰기」) is **deliberately not built**:
/// `submitAudio` is a single POST with no cancel, so skipping would have to
/// either bin a score the server is already computing or land a result on a
/// screen the user has left. Dropped on a product decision — while scoring is one
/// blocking call, waiting is the only thing the screen can honestly offer.
const _kSlowScoring = Duration(seconds: 2);

/// Minimum time the scan stays up before advancing to the result, even when
/// scoring returns faster.
///
/// `submitAudio` is ~0.1s against a warm server but ~9s on a Cloud Run cold
/// start, so without a floor the scan animation (cursor sweep, spinner) would
/// flash for a single frame and snap to the result on a warm server. 1.5s ≈ one
/// cursor sweep, so the scan reads as a real step regardless of server latency.
/// The result transition waits on `max(scoring, this)`.
const _kMinScan = Duration(milliseconds: 1500);

/// 반응 영상을 「정답」으로 볼 최소 총점.
///
/// 화면이 글자를 칠할 때 이미 쓰는 밴드(85 상 · 70 중 — `_gradeColor`)의 **중간
/// 문턱을 그대로 빌린다**. 반응만 다른 자를 쓰면 문장은 초록인데 비버는 화내는,
/// 화면과 얼굴이 어긋나는 상태가 생긴다.
const int _kReactionPassScore = 70;

/// The whole learning flow for a sentence sequence — Figma `screen/learning_intro`
/// (`2117:20089`) through `learning_next` (`2117:20110`) — as **one screen**.
///
/// Holds the sequence ([LearningArgs.sentences]) and walks its own [_index]
/// through [LearningPhase.recording] → `scoring` → `result` per sentence, all by
/// `setState`. "다음" advances [_index] in place (no push); only the **last**
/// sentence's "다음" pushes the session's result screen ([LearningCallMainScreen]
/// or [LearningSentenceMainScreen], per [LearningArgs.origin]). "다시하기" returns
/// to `recording` for the same sentence. Closing pops to whatever launched the
/// flow.
///
/// Reads its [LearningArgs] from `ModalRoute.of(context)!.settings.arguments`.
class LearningIntroScreen extends ConsumerStatefulWidget {
  /// Creates the learning flow screen.
  const LearningIntroScreen({super.key});

  @override
  ConsumerState<LearningIntroScreen> createState() =>
      _LearningIntroScreenState();
}

class _LearningIntroScreenState extends ConsumerState<LearningIntroScreen> {
  final ReviewAudioRecorder _recorder = ReviewAudioRecorder();
  final ReviewAudioPlayer _player = ReviewAudioPlayer();

  LearningPhase _phase = LearningPhase.recording;

  /// Position in [LearningArgs.sentences]. Seeded from `args.index` once, then
  /// advanced by "다음". Kept in state (not read from args each build) so the
  /// sequence progresses within this one screen instead of across pushes.
  int _index = 0;
  bool _initialized = false;

  bool _recording = false;

  /// Scoring has passed [_kSlowScoring] and the caption has softened.
  bool _scoringSlow = false;
  Timer? _slowTimer;

  /// The scored attempt for the current sentence, shown in [LearningPhase.result].
  ReviewFeedback? _feedback;

  /// The user's just-recorded WAV, for "Me" playback in the result.
  Uint8List? _recordedWav;

  /// Failure caption shown in [LearningPhase.failed]. Network vs other is split
  /// so a scoring failure doesn't borrow "연결이 끊겼어요".
  String? _failMessage;

  /// Cached standard-pronunciation URL for the current sentence (fetched once;
  /// cleared when the sentence changes). The server TTS is idempotent.
  String? _ttsUrl;
  bool _loadingTts = false;

  final Set<int> _bookmarkInFlight = <int>{};

  // ── 반응 영상 ─────────────────────────────────────────────────────────────
  //
  // 통화 화면과 **같은 클립·같은 위젯**([SyncAvatar])을 쓴다. 이 화면에서는 비버가
  // 말하지 않으므로 입은 움직이지 않고, 국면([LearningPhase])이 클립을 고른다.

  /// 음성 엔벨로프. 이 화면엔 비버 목소리가 없으므로 **항상 0** 이다.
  final ValueNotifier<double> _avatarLevel = ValueNotifier<double>(0);

  /// 발화 플래그. 평소 false 이고 **감정 클립을 내보내는 동안만** true 다 —
  /// [SyncAvatar] 는 `_talking` 인 동안에만 `emo_*` 를 얹기 때문이다.
  final ValueNotifier<bool> _avatarSpeaking = ValueNotifier<bool>(false);

  /// 반응 감정 — 채점 직후 한 번 happy/angry 로 올렸다가 클립이 끝나면 내린다.
  final ValueNotifier<int> _avatarEmotion = ValueNotifier<int>(kEmotionNeutral);

  /// 대기 클립 종류 — 대기 / 듣는 중 / 생각 중. [_syncAvatarIdle] 이 국면에서 민다.
  final ValueNotifier<int> _avatarIdleKind = ValueNotifier<int>(kIdleWait);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! LearningArgs) return;
    if (_initialized) return;
    _initialized = true;
    _index = args.index;
    _seedBookmarkFor(args.sentences[_index]);
  }

  /// Reconcile the shared bookmark store to this sentence's server flag (add
  /// when saved, clear when not) so a stale `true` can't stick across sentences.
  void _seedBookmarkFor(MockSentence s) => setBookmark(s.id, s.bookmarked);

  @override
  void dispose() {
    _slowTimer?.cancel();
    _recorder.dispose();
    _player.dispose();
    _avatarLevel.dispose();
    _avatarSpeaking.dispose();
    _avatarEmotion.dispose();
    _avatarIdleKind.dispose();
    super.dispose();
  }

  // ── 반응 영상 ─────────────────────────────────────────────────────────────

  /// 화면 국면을 **대기 클립**으로 옮긴다.
  ///
  /// 마이크가 열려 있으면 「듣는 얼굴」(`idle_listen`)이다 — 사용자가 말하는 동안
  /// 비버가 가만히 있으면 「내 말을 듣고 있나」로 읽힌다. 채점 중에는 `idle_think`.
  /// 자산이 없는 캐릭터는 [SyncAvatar] 가 조용히 `idle` 로 폴백한다.
  void _syncAvatarIdle() {
    switch (_phase) {
      case LearningPhase.recording:
        _avatarIdleKind.value = _recording ? kIdleListen : kIdleWait;
      case LearningPhase.scoring:
        _avatarIdleKind.value = kIdleThink;
      case LearningPhase.result:
      case LearningPhase.failed:
        _avatarIdleKind.value = kIdleWait;
    }
  }

  /// 채점 결과를 반응 영상 **한 번**으로 옮긴다 — 통과면 happy, 아니면 angry.
  ///
  /// 「오답」의 자는 총점만이 아니다. 총점이 문턱을 넘어도 **하** 등급 글자가 있으면
  /// 화면은 그 글자를 빨갛게 칠하는데([_gradeColor]), 그때 비버가 웃으면 문장과
  /// 얼굴이 서로 다른 말을 한다. 그래서 둘 중 하나라도 걸리면 angry 로 간다.
  void _reactToFeedback(ReviewFeedback feedback) {
    final hasLow =
        feedback.charScores.any((c) => c.grade == CharGrade.low);
    final passed = !hasLow &&
        feedback.evaluation.totalScore >= _kReactionPassScore;
    _avatarEmotion.value = passed ? kEmotionHappy : kEmotionAngry;
    // 감정 클립은 `_talking` 인 동안에만 보인다 — [_onAvatarDiag] 가 되돌린다.
    _avatarSpeaking.value = true;
  }

  /// [SyncAvatar] 가 흘리는 이벤트 중 **감정 클립이 끝났다**만 받는다.
  ///
  /// ⛔ 발화 플래그를 켠 채로 두면 감정 클립이 끝난 자리에 그 밑의 `talk.mp4`
  ///    — 소리 없이 입만 움직이는 얼굴 — 이 드러난다. 반응은 한 번이고, 끝나면
  ///    대기로 돌아가야 한다.
  void _onAvatarDiag(String event, [Map<String, Object?>? fields]) {
    if (event != 'vid_emo_end' || !mounted) return;
    _avatarSpeaking.value = false;
    _avatarEmotion.value = kEmotionNeutral;
  }

  // ── 단어 칩 · 발음 교정 시트 ──────────────────────────────────────────────

  /// 채점된 글자를 **어절로 묶어** 칩 한 줄로 만든다.
  ///
  /// 칩은 **주의·오답 어절만** 만든다. 정답 어절까지 칩으로 내면 긴 문장에서 줄이
  /// 터진다 — 코퍼스 최장 문장은 어절이 15개다. 정답 여부는 문장 자체의 글자 색이
  /// 이미 말하므로 칩이 또 말할 필요가 없다.
  ///
  /// `charScores` 는 공백을 뺀 글자열과 1:1 이라고 보고 순서대로 소비한다.
  List<Widget> _wordChips(BuildContext context, String korean) {
    final scores = _feedback?.charScores ?? const <CharScore>[];
    if (scores.isEmpty) return const [];
    var cursor = 0;
    final chips = <Widget>[];
    for (final word in korean.split(RegExp(r'\s+'))) {
      if (word.isEmpty) continue;
      final taken = <CharScore>[];
      for (var i = 0; i < word.characters.length; i++) {
        if (cursor >= scores.length) break;
        taken.add(scores[cursor++]);
      }
      if (taken.isEmpty) continue;
      // 어절의 판정은 **가장 나쁜 글자**를 따른다. 평균을 내면 한 글자만 망가진
      // 어절이 정답으로 접혀 교정 진입점이 사라진다.
      taken.sort((x, y) => x.score.compareTo(y.score));
      final worst = taken.first;
      if (worst.grade == CharGrade.high) continue;
      final diagram = diagramForSyllable(worst.char);
      chips.add(_wordChip(context, word, worst, diagram));
    }
    return chips;
  }

  Widget _wordChip(
    BuildContext context,
    String word,
    CharScore worst,
    PhonemeDiagram? diagram,
  ) {
    final c = context.c;
    final low = worst.grade == CharGrade.low;
    final dot = low ? c.statusNegative : c.statusCautionary;
    return GestureDetector(
      onTap: diagram == null
          ? null
          : () => _openArticulation(word, diagram),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s12,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: low ? c.statusNegative6 : c.backgroundSurfaceAlternative,
          border: Border.all(
            color: low ? c.statusNegative : c.lineNeutral,
            width: low ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.s8),
            Text(
              word,
              style: AppType.label2.b.copyWith(color: c.labelNormal),
            ),
          ],
        ),
      ),
    );
  }

  /// 칩을 누르면 발음 교정 시트가 열린다.
  ///
  /// 지금은 **목표 도해 한 컷**만 간다. 「무엇으로 잘못 냈는지」는 음소 인식이
  /// 붙어야 알 수 있고, 그때 [ArticulationSheetData.current] 가 채워지면 시트가
  /// 스스로 두 컷으로 바뀐다 — 화면 쪽은 안 고쳐도 된다.
  void _openArticulation(String word, PhonemeDiagram target) {
    showArticulationSheet(
      context,
      data: ArticulationSheetData(word: word, target: target),
      onPlayNative: () {
        Navigator.of(context).pop();
        final args = ModalRoute.of(context)?.settings.arguments;
        if (args is LearningArgs) _playStandard(args.sentences[_index]);
      },
    );
  }

  /// 반응 영상 밴드 — Figma `VideoBand`(375 폭 · 16:9 풀블리드, 아이콘줄 아래).
  ///
  /// 캐릭터에 클립이 없으면([avatarAssetDirFor] 가 null) **밴드째 접는다**. 정적
  /// 이미지를 끼워 넣으면 16:9 자리만 차지하고 아무 상태도 말하지 않는다.
  Widget _reactionBand() {
    final dir = avatarAssetDirFor(
      null,
      ref.watch(selectedCharacterProvider)?.name,
    );
    if (dir == null) return const SizedBox.shrink();
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRect(
        child: SyncAvatar(
          assetDir: dir,
          level: _avatarLevel,
          speaking: _avatarSpeaking,
          emotion: _avatarEmotion,
          idleKind: _avatarIdleKind,
          onDiag: _onAvatarDiag,
        ),
      ),
    );
  }

  // ── Bookmark ──────────────────────────────────────────────────────────────

  /// Toggles the current sentence's bookmark: flips the shared in-memory store
  /// first for instant, cross-screen UI (mirrors the analysis screen), then
  /// persists via [bookmarkToggleControllerProvider]. Reverts on failure. A
  /// second tap while one is pending is ignored so opposite PATCHes can't
  /// resolve out of order.
  Future<void> _toggleBookmark(int sentenceId) async {
    if (_bookmarkInFlight.contains(sentenceId)) return;
    _bookmarkInFlight.add(sentenceId);
    final l10n = AppLocalizations.of(context);
    final willSave = !bookmarkedSentenceIds.value.contains(sentenceId);
    toggleBookmark(sentenceId);
    try {
      await ref
          .read(bookmarkToggleControllerProvider.notifier)
          .toggleBookmark(sentenceId, willSave);
    } catch (e) {
      toggleBookmark(sentenceId); // revert on failure
      _snack(e is AppException ? e.message : l10n.saveSentenceFailed);
    } finally {
      _bookmarkInFlight.remove(sentenceId);
    }
  }

  // ── Audio ─────────────────────────────────────────────────────────────────

  /// Plays the current sentence's standard (native) pronunciation via the
  /// server's on-demand TTS (`POST /sentences/{id}/tts`), cached after the first
  /// fetch. Used by both the top speaker and the result's "Native" button.
  Future<void> _playStandard(MockSentence sentence) async {
    // Never play the standard audio while scoring or recording — it would bleed
    // into the take and skew the score.
    if (_phase == LearningPhase.scoring || _loadingTts || _recording) return;
    final l10n = AppLocalizations.of(context);
    var url = _ttsUrl ?? sentence.voiceUrl;
    if (url == null || !url.startsWith('http')) {
      setState(() => _loadingTts = true);
      try {
        url = await ref.read(reviewRepositoryProvider).sentenceTtsUrl(sentence.id);
        _ttsUrl = url;
      } on AppException catch (e) {
        _snack(e.message);
        return;
      } catch (_) {
        _snack(l10n.standardAudioPlayError);
        return;
      } finally {
        if (mounted) setState(() => _loadingTts = false);
      }
    }
    if (url == null || !url.startsWith('http')) {
      _snack(l10n.standardAudioNotReady);
      return;
    }
    try {
      await _player.playUrl(url);
    } catch (_) {
      _snack(l10n.standardAudioPlayError);
    }
  }

  /// Plays the user's own recorded take (result's "Me" button).
  Future<void> _playMe() async {
    final l10n = AppLocalizations.of(context);
    final wav = _recordedWav;
    if (wav == null || wav.isEmpty) {
      _snack(l10n.noRecordingToPlay);
      return;
    }
    try {
      await _player.playBytes(wav);
    } catch (_) {
      _snack(l10n.myRecordingPlayError);
    }
  }

  // ── Phase transitions ───────────────────────────────────────────────────────

  Future<void> _onMicTap(LearningArgs args) async {
    if (_phase != LearningPhase.recording) return;
    if (!_recording) {
      await _startRecording();
    } else {
      await _stopAndScore(args);
    }
  }

  Future<void> _startRecording() async {
    final l10n = AppLocalizations.of(context);
    try {
      await _recorder.start();
      if (!mounted) return;
      setState(() => _recording = true);
      _syncAvatarIdle();
    } on StateError catch (e) {
      _snack(e.message);
    } catch (_) {
      _snack(l10n.recordStartFailed);
    }
  }

  Future<void> _stopAndScore(LearningArgs args) async {
    final l10n = AppLocalizations.of(context);
    final sentence = args.sentences[_index];
    setState(() {
      _recording = false;
      _phase = LearningPhase.scoring;
      _scoringSlow = false;
    });
    _syncAvatarIdle();
    _slowTimer?.cancel();
    _slowTimer = Timer(_kSlowScoring, () {
      if (mounted) setState(() => _scoringSlow = true);
    });

    try {
      final pcm = await _recorder.stop();
      // Guard an empty/too-short recording (< ~0.3s of PCM16 @16k).
      if (pcm.lengthInBytes < 16000 * 2 * 0.3) {
        _snack(l10n.recordTooShort);
        _backToRecording();
        return;
      }

      final wav = pcm16ToWav(pcm);
      // Start scoring and the minimum-scan floor together: total = max(scoring,
      // _kMinScan). A warm-server response still shows the scan for _kMinScan.
      // 복습(callReview)=공식점수 반영, 하나씩 연습(sentence)=미반영(데이터·채점은 저장).
      final scoring = ref.read(reviewRepositoryProvider).submitAudio(
            sentence.id,
            wav,
            applyScore: args.origin == LearningOrigin.callReview,
          );
      await Future<void>.delayed(_kMinScan);
      final feedback = await scoring;

      // Feed the running average for the analysis gauge.
      ref.read(reviewScoresProvider.notifier).record(feedback);

      if (!mounted) return;
      _slowTimer?.cancel();
      setState(() {
        _phase = LearningPhase.result;
        _feedback = feedback;
        _recordedWav = wav;
        _scoringSlow = false;
      });
      _syncAvatarIdle();
      _reactToFeedback(feedback);
    } on NetworkFailure {
      // `proto/E_failed`'s caption is "연결이 끊겼어요", true only when the request
      // never reached the server — `dio_error_mapper` already classifies exactly
      // that (connectionError + timeouts) as [NetworkFailure]. A *scoring*
      // failure below must not borrow that wording.
      _toFailed(l10n.scanConnectionLost);
    } on AppException catch (e) {
      _toFailed(e.message);
    } catch (_) {
      _toFailed(l10n.gradingFailed);
    }
  }

  /// Scoring failed → the E_failed state (a retry button + [message] caption).
  void _toFailed(String message) {
    _slowTimer?.cancel();
    if (!mounted) return;
    setState(() {
      _phase = LearningPhase.failed;
      _failMessage = message;
      _scoringSlow = false;
    });
    _syncAvatarIdle();
  }

  /// Return to the recording state on an aborted score (e.g. too-short take),
  /// keeping the sentence. A snackbar already told the user why.
  void _backToRecording() {
    _slowTimer?.cancel();
    if (!mounted) return;
    setState(() {
      _phase = LearningPhase.recording;
      _scoringSlow = false;
    });
    _syncAvatarIdle();
  }

  /// "다시하기" (result) / retry (E_failed) — re-record the same sentence.
  void _retry() {
    setState(() {
      _phase = LearningPhase.recording;
      _feedback = null;
      _recordedWav = null;
      _failMessage = null;
      _recording = false;
    });
    _syncAvatarIdle();
  }

  /// "다음" — advance to the next sentence in place, or push the session's
  /// result screen after the last one.
  void _next(LearningArgs args) {
    if (_index >= args.sentences.length - 1) {
      Navigator.pushNamed(
        context,
        args.origin == LearningOrigin.callReview
            ? Routes.learningCallMain
            : Routes.learningSentenceMain,
        arguments: LearningArgs(
          sentences: args.sentences,
          index: _index,
          feedback: _feedback,
          recordedWav: _recordedWav,
          origin: args.origin,
          callId: args.callId,
        ),
      );
      return;
    }
    setState(() {
      _index++;
      _phase = LearningPhase.recording;
      _feedback = null;
      _recordedWav = null;
      _recording = false;
      _ttsUrl = null; // per-sentence TTS
    });
    _syncAvatarIdle();
    _seedBookmarkFor(args.sentences[_index]);
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Character colour by grade, falling back to score thresholds when unknown.
  static Color _gradeColor(BuildContext context, CharScore cs) {
    switch (cs.grade) {
      case CharGrade.high:
        return context.c.statusPositive;
      case CharGrade.medium:
        return context.c.statusCautionary;
      case CharGrade.low:
        return context.c.accentForegroundRed;
      case CharGrade.unknown:
        if (cs.score >= 85) return context.c.statusPositive;
        if (cs.score >= 70) return context.c.statusCautionary;
        return context.c.accentForegroundRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Mobile always arrives via in-app `pushNamed(arguments:)`; guard the cast so
    // a web refresh / deep link (args == null) degrades to an empty screen.
    final rawArgs = ModalRoute.of(context)?.settings.arguments;
    if (rawArgs is! LearningArgs) {
      return const Scaffold(body: SizedBox.shrink());
    }
    final args = rawArgs;
    final sentence = args.sentences[_index];
    final scoring = _phase == LearningPhase.scoring;
    final isResult = _phase == LearningPhase.result;

    return AppScaffold(
      background: context.c.backgroundNormalAlternative,
      body: Column(
        children: [
          Gnb.main2(
            progress: GnbProgress(current: _index + 1, total: args.sentences.length),
            onClose: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.s16),
                // Speaker / bookmark utility row — shared by every phase.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Semantics(
                        button: true,
                        label: l10n.listenStandard,
                        child: GestureDetector(
                          onTap: () => _playStandard(sentence),
                          behavior: HitTestBehavior.opaque,
                          child: AppIcons.volume(
                              size: 32, color: context.c.labelStrong),
                        ),
                      ),
                      ValueListenableBuilder<Set<int>>(
                        valueListenable: bookmarkedSentenceIds,
                        builder: (context, ids, _) {
                          final saved = ids.contains(sentence.id);
                          return Semantics(
                            button: true,
                            label:
                                saved ? l10n.unsaveSentence : l10n.saveSentence,
                            child: GestureDetector(
                              onTap: () => _toggleBookmark(sentence.id),
                              behavior: HitTestBehavior.opaque,
                              child: saved
                                  ? AppIcons.bookmarkFill(
                                      size: 32, color: context.c.labelStrong)
                                  : AppIcons.bookmarkLine(
                                      size: 32, color: context.c.labelStrong),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s8),
                // 반응 영상 — Figma `VideoBand`. 아이콘줄 바로 아래, 문장 위.
                _reactionBand(),
                // Sentence — shared position across phases. Its colouring
                // cross-fades between plain (recording/scoring) and per-character
                // tinted (result), so nothing slides; while scoring, ScanCursor
                // sweeps over it.
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s20),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: isResult
                                    ? _ScoredSentence(
                                        key: const ValueKey('scored'),
                                        charScores:
                                            _feedback?.charScores ?? const [],
                                        fallbackText: sentence.korean,
                                      )
                                    : Text(
                                        sentence.korean,
                                        key: const ValueKey('plain'),
                                        textAlign: TextAlign.center,
                                        style: AppType.heading2.sb.copyWith(
                                            color: context.c.labelStrong),
                                      ),
                              ),
                              const SizedBox(height: AppSpacing.s8),
                              Text(
                                _feedback?.native ?? sentence.native,
                                textAlign: TextAlign.center,
                                style: AppType.body1.sb
                                    .copyWith(color: context.c.labelNormal),
                              ),
                            ],
                          ),
                          if (scoring)
                            const IgnorePointer(child: ScanCursor(height: 84)),
                        ],
                      ),
                    ),
                  ),
                ),
                // Bottom — the only part that changes shape per phase, cross-faded.
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _bottom(context, l10n, args, sentence),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// The caption between the sentence and the mic anchor — shared by scoring
  /// (`AnalyzingCaption` 3627:9708) and failed (E_failed 3627:9847).
  Widget _caption(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppType.label1.m.copyWith(color: context.c.labelNormal),
        ),
      );

  Widget _bottom(BuildContext context, AppLocalizations l10n, LearningArgs args,
      MockSentence sentence) {
    switch (_phase) {
      case LearningPhase.recording:
        return BottomCtaBar(
          key: const ValueKey('recording'),
          child: Center(
            child: StreamBuilder<double>(
              stream: _recorder.amplitude,
              builder: (context, snap) => MicButton(
                recording: _recording,
                level: _recording ? snap.data : null,
                onTap: () => _onMicTap(args),
              ),
            ),
          ),
        );
      case LearningPhase.scoring:
        return Column(
          key: const ValueKey('scoring'),
          mainAxisSize: MainAxisSize.min,
          children: [
            // `AnalyzingCaption` (`3627:9708`) — between the sentence and the
            // mic anchor.
            _caption(
                context,
                _scoringSlow
                    ? l10n.analyzingTakingLonger
                    : l10n.analyzingByWord),
            const SizedBox(height: AppSpacing.s16),
            const BottomCtaBar(child: Center(child: MicAnalysis())),
          ],
        );
      case LearningPhase.failed:
        // `proto/E_failed` (`3627:9822`) — same as scoring but the mic anchor is
        // a retry button and the caption states the failure.
        return Column(
          key: const ValueKey('failed'),
          mainAxisSize: MainAxisSize.min,
          children: [
            _caption(context, _failMessage ?? l10n.gradingFailed),
            const SizedBox(height: AppSpacing.s16),
            BottomCtaBar(
              child: Center(
                child: RecordCircleButton(
                  icon: AppIcons.redo,
                  semanticLabel: l10n.retry,
                  onTap: _retry,
                ),
              ),
            ),
          ],
        );
      case LearningPhase.result:
        final chips = _wordChips(context, sentence.korean);
        return Column(
          key: const ValueKey('result'),
          mainAxisSize: MainAxisSize.min,
          children: [
            if (chips.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: AppSpacing.s8,
                  runSpacing: AppSpacing.s8,
                  children: chips,
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
              child: Row(
                children: [
                  Expanded(
                    child: Button(
                      type: BtnType.secondaryWhite,
                      size: BtnSize.s44,
                      text: l10n.nativeLabel,
                      leftIcon: AppIcons.volume(
                          size: 20, color: context.c.labelStrong),
                      onPressed: () => _playStandard(sentence),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Button(
                      type: BtnType.secondaryWhite,
                      size: BtnSize.s44,
                      text: l10n.meLabel,
                      leftIcon: AppIcons.volume(
                          size: 20, color: context.c.labelStrong),
                      onPressed: _playMe,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36), // Native/Me → controls (Figma 36; no token)
            BottomCtaBar(
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 56),
                    const SizedBox(width: AppSpacing.s24),
                    RecordCircleButton(
                      icon: AppIcons.redo,
                      semanticLabel: l10n.retry,
                      onTap: _retry,
                    ),
                    const SizedBox(width: AppSpacing.s24),
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: IconButton(
                        onPressed: () => _next(args),
                        icon: AppIcons.arrowForward(
                            size: 32, color: context.c.primaryHeavy),
                        iconSize: 32,
                        color: context.c.primaryHeavy,
                        tooltip: l10n.next,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
    }
  }
}

/// Renders the sentence character-by-character, each tinted by its grade. Falls
/// back to a plain (un-tinted) sentence when no char scores exist.
class _ScoredSentence extends StatelessWidget {
  const _ScoredSentence({
    super.key,
    required this.charScores,
    required this.fallbackText,
  });

  final List<CharScore> charScores;
  final String fallbackText;

  @override
  Widget build(BuildContext context) {
    final base = AppType.heading2.sb;
    if (charScores.isEmpty) {
      return Text(
        fallbackText,
        textAlign: TextAlign.center,
        style: base.copyWith(color: context.c.labelStrong),
      );
    }
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          for (final cs in charScores)
            TextSpan(
              text: cs.char,
              style: base.copyWith(
                color: _LearningIntroScreenState._gradeColor(context, cs),
              ),
            ),
        ],
      ),
    );
  }
}
