import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/chrome/home_indicator.dart';
import '../../components/chrome/status_bar.dart';
import '../../components/organisms/dialog_basic.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Live call — Figma `screen/call_main` (`2117:19932`, dialog `2117:19956`).
///
/// A dark full-screen call view: the [beaverImage] avatar, the
/// [mockPartnerName], a running call timer (`mm:ss`) ticking once per second,
/// and an end-call button.
///
/// Pressing end opens [showDialogBasic] (a [DialogBasic] over a [Dim] scrim)
/// titled "무료 통화가 끝나가요" offering "구독하기" → [Routes.payment] (top, primary)
/// or "통화 종료" → [Routes.callFinish] (bottom, secondary).
///
/// The per-second [Timer] is started in [initState] and cancelled in [dispose].
class CallScreen extends StatefulWidget {
  /// Creates the live call screen.
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  /// Ticking call timer; cancelled in [dispose].
  Timer? _timer;

  /// Elapsed call duration in whole seconds.
  int _elapsed = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _elapsed++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Formats [_elapsed] as `mm:ss`.
  String get _formatted {
    final m = (_elapsed ~/ 60).toString().padLeft(2, '0');
    final s = (_elapsed % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// Opens the "free call ending" dialog with subscribe / end actions.
  Future<void> _confirmEnd() async {
    await showDialogBasic<void>(
      context,
      title: '무료 통화가 끝나가요',
      description: '구독하면 비버와 더 오래 대화할 수 있어요.',
      variant: DialogBasicVariant.twoVertical,
      primary: DialogAction(
        label: '구독하기',
        onPressed: () {
          Navigator.of(context).pop(); // close dialog
          Navigator.pushNamed(context, Routes.payment);
        },
      ),
      secondary: DialogAction(
        label: '통화 종료',
        onPressed: () {
          Navigator.of(context).pop(); // close dialog
          Navigator.pushReplacementNamed(context, Routes.callFinish);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.bg,
      statusVariant: StatusBarVariant.whiteTransparent,
      homeVariant: HomeIndicatorVariant.whiteTransparent,
      body: Column(
        children: [
          // Avatar + name + timer, centered in the available space.
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface2,
                      image: DecorationImage(
                        image: beaverImage,
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary24,
                          blurRadius: 48,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    mockPartnerName,
                    style:
                        AppType.heading2.sb.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _formatted,
                    style: AppType.title3.m
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          // End-call button.
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SizedBox(
              width: double.infinity,
              child: Button(
                type: BtnType.primaryFill,
                size: BtnSize.s60,
                text: '통화 종료',
                leftIcon: const Icon(Icons.call_end),
                onPressed: _confirmEnd,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
