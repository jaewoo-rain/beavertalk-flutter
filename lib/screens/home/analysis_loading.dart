import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/chrome/home_indicator.dart';
import '../../components/chrome/status_bar.dart';
import '../../core/error/app_exception.dart';
import '../../features/normalcall/domain/entities/call_result.dart';
import '../../features/normalcall/presentation/normalcall_providers.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Analysis loading — bridges 통화 종료 → 통화 분석.
///
/// Receives the int `callId` as route arguments, then polls
/// `repository.getStatus(callId)` every [_pollInterval] until the analysis is
/// `done` (→ fetch the result and replace with [Routes.analysis]) or `failed`
/// (→ inline error + retry/home). Polling is capped at [_timeout]; a timeout
/// shows the same retry UI. The poll timer is cancelled on dispose and every
/// async step guards against an unmounted widget.
class AnalysisLoadingScreen extends ConsumerStatefulWidget {
  /// Creates the analysis-loading screen.
  const AnalysisLoadingScreen({super.key});

  @override
  ConsumerState<AnalysisLoadingScreen> createState() =>
      _AnalysisLoadingScreenState();
}

/// What the loading screen is currently showing.
enum _LoadingPhase { polling, error }

class _AnalysisLoadingScreenState extends ConsumerState<AnalysisLoadingScreen> {
  /// How often to poll the status endpoint.
  static const Duration _pollInterval = Duration(milliseconds: 1500);

  /// Give up after this long and show the retry UI.
  static const Duration _timeout = Duration(seconds: 60);

  int? _callId;
  _LoadingPhase _phase = _LoadingPhase.polling;
  String _errorMsg = '';

  Timer? _pollTimer;
  DateTime? _deadline;

  /// Prevents overlapping polls and double navigation.
  bool _busy = false;
  bool _navigated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_callId != null) return; // capture once
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int) {
      _callId = args;
      _start();
    } else {
      // Shouldn't happen (call_finish always passes an int), but fail safe.
      _phase = _LoadingPhase.error;
      _errorMsg = '통화 정보를 찾을 수 없어요.';
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  /// (Re)starts the polling cycle from a fresh deadline.
  void _start() {
    _pollTimer?.cancel();
    _deadline = DateTime.now().add(_timeout);
    setState(() {
      _phase = _LoadingPhase.polling;
      _errorMsg = '';
    });
    // Poll immediately, then on an interval.
    _poll();
    _pollTimer = Timer.periodic(_pollInterval, (_) => _poll());
  }

  Future<void> _poll() async {
    if (_busy || _navigated || !mounted) return;
    final callId = _callId;
    if (callId == null) return;

    // Timeout check.
    if (_deadline != null && DateTime.now().isAfter(_deadline!)) {
      _fail('분석이 예상보다 오래 걸리고 있어요. 잠시 후 다시 시도해주세요.');
      return;
    }

    _busy = true;
    try {
      final status =
          await ref.read(normalcallRepositoryProvider).getStatus(callId);
      if (!mounted || _navigated) return;
      switch (status) {
        case CallAnalysisStatus.done:
          await _fetchResultAndGo(callId);
        case CallAnalysisStatus.failed:
          _fail('대화 분석에 실패했어요. 다시 시도해주세요.');
        case CallAnalysisStatus.ongoing:
        case CallAnalysisStatus.analyzing:
        case CallAnalysisStatus.unknown:
          // Keep polling.
          break;
      }
    } on AppException catch (e) {
      // Transient network errors: keep polling until the timeout, but if we're
      // already past the deadline, surface the message.
      if (_deadline != null && DateTime.now().isAfter(_deadline!)) {
        _fail(e.message);
      }
    } finally {
      _busy = false;
    }
  }

  /// Fetches the full result and replaces this screen with the analysis screen.
  Future<void> _fetchResultAndGo(int callId) async {
    try {
      final result =
          await ref.read(normalcallRepositoryProvider).getResult(callId);
      if (!mounted || _navigated) return;
      _navigated = true;
      _pollTimer?.cancel();
      Navigator.pushReplacementNamed(
        context,
        Routes.analysis,
        arguments: result,
      );
    } on AppException catch (e) {
      _fail(e.message);
    }
  }

  /// Stops polling and shows the retry UI with [message].
  void _fail(String message) {
    _pollTimer?.cancel();
    if (!mounted) return;
    setState(() {
      _phase = _LoadingPhase.error;
      _errorMsg = message;
    });
  }

  void _goHome() =>
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (r) => false);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.bg,
      statusVariant: StatusBarVariant.whiteTransparent,
      homeVariant: HomeIndicatorVariant.whiteTransparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _phase == _LoadingPhase.polling ? _polling() : _error(),
      ),
    );
  }

  Widget _polling() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface2,
              image: DecorationImage(image: beaverImage, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            '대화를 분석하고 있어요…',
            style: AppType.heading2.sb.copyWith(color: AppColors.text),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            '잠시만 기다려주세요',
            style: AppType.body1.r.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 28),
          // Indeterminate loading bar.
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const SizedBox(
              width: 220,
              height: 6,
              child: LinearProgressIndicator(
                backgroundColor: AppColors.surface2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _error() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            size: 56,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 20),
          Text(
            '분석을 불러오지 못했어요',
            style: AppType.heading2.sb.copyWith(color: AppColors.text),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            _errorMsg,
            style: AppType.body1.r.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          Button(
            type: BtnType.primaryFill,
            size: BtnSize.s60,
            text: '다시 시도',
            onPressed: _callId == null ? _goHome : _start,
          ),
          const SizedBox(height: 12),
          Button(
            type: BtnType.secondaryFill,
            size: BtnSize.s60,
            text: '홈으로',
            onPressed: _goHome,
          ),
        ],
      ),
    );
  }
}
