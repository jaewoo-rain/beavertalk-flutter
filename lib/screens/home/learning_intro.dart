import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/mic_button.dart';
import '../../components/organisms/gnb.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'learning_args.dart';

/// Learning step 1 — Figma `screen/learning_intro` (`2117:20089`).
///
/// Shows the current sentence (KO in Heading 2, EN in Body 1 secondary) over a
/// [AppColors.surface2] page, with a speaker/bookmark utility row up top and a
/// large mic button pinned low. The mic is a two-state recorder:
/// - **idle** ([_MicState.idle]) — green ring + filled mic; tap to start.
/// - **recording** ([_MicState.recording]) — solid green disc + a stop square;
///   tap to finish, which pushes [Routes.learningNext] (forwarding the same
///   [LearningArgs]).
///
/// Reads its [LearningArgs] from `ModalRoute.of(context)!.settings.arguments`.
class LearningIntroScreen extends StatefulWidget {
  /// Creates the learning intro screen.
  const LearningIntroScreen({super.key});

  @override
  State<LearningIntroScreen> createState() => _LearningIntroScreenState();
}

/// Recording state of the mic button.
enum _MicState {
  /// Waiting to record — tap to begin.
  idle,

  /// Recording — tap to stop and advance.
  recording,
}

class _LearningIntroScreenState extends State<LearningIntroScreen> {
  _MicState _mic = _MicState.idle;

  Future<void> _onMicTap(LearningArgs args) async {
    if (_mic == _MicState.idle) {
      setState(() => _mic = _MicState.recording);
      return;
    }
    // Recording → stop → advance to the comparison screen. When we return here
    // (e.g. "다시하기" pops back), reset to idle so the user re-records.
    await Navigator.pushNamed(context, Routes.learningNext, arguments: args);
    if (mounted) setState(() => _mic = _MicState.idle);
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as LearningArgs;
    final sentence = args.current;

    return AppScaffold(
      background: AppColors.surface2,
      body: Column(
        children: [
          Gnb.main2(
            progress: GnbProgress(current: args.step, total: args.total),
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: Stack(
              children: [
                // Speaker / bookmark utility row.
                const Positioned(
                  top: 16,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.volume_up_outlined,
                          size: 32, color: AppColors.text),
                      Icon(Icons.bookmark_border,
                          size: 32, color: AppColors.text),
                    ],
                  ),
                ),
                // Centered sentence (KO + EN).
                Align(
                  alignment: const Alignment(0, -0.15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          sentence.korean,
                          textAlign: TextAlign.center,
                          style: AppType.heading2.sb
                              .copyWith(color: AppColors.text),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          sentence.native,
                          textAlign: TextAlign.center,
                          style: AppType.body1.sb
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
                // Mic button.
                Align(
                  alignment: const Alignment(0, 0.7),
                  child: MicButton(
                    recording: _mic == _MicState.recording,
                    onTap: () => _onMicTap(args),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
