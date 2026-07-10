import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../icons/app_icons.dart';
import 'record_circle_button.dart';

/// MicButton — the 96px two-state recorder mic button.
///
/// Figma component `Property 1=mic_on` (`37:41776`), extracted from
/// `screen/learning_intro` (`2117:20089`).
///
/// - **idle** ([recording] = `false`) — a green-700 ring (transparent inside)
///   with a green-700 [Icons.mic] glyph; tap to start.
/// - **recording** ([recording] = `true`) — a solid green-700 disc with a pale
///   green-50 inner disc and a green-700 rounded stop square; tap to finish.
class MicButton extends StatelessWidget {
  /// Creates a mic button.
  const MicButton({
    super.key,
    required this.recording,
    required this.onTap,
    this.level,
  });

  /// Whether the button is in the recording (stop) state.
  final bool recording;

  /// Tap handler — starts recording when idle, stops when recording.
  final VoidCallback onTap;

  /// Optional live input level (normalized 0..1) driving a subtle reactive
  /// pulse while recording. `null` (default) keeps the button fully static, so
  /// existing call sites are unaffected. When supplied, an expanding halo ring
  /// and a gentle scale track the level; the two-state visuals are unchanged.
  final double? level;

  static const double _size = 96;

  /// Reserved padding around the button so the reactive halo has room to grow
  /// without shifting layout (max ring overshoot = [_maxHalo]).
  static const double _maxHalo = 20;

  @override
  Widget build(BuildContext context) {
    final core = _buildCore();

    final lvl = level;
    // No level provided (or idle) → render the plain two-state button.
    if (lvl == null || !recording) return core;

    final clamped = lvl.clamp(0.0, 1.0);
    return SizedBox(
      width: _size + _maxHalo * 2,
      height: _size + _maxHalo * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Expanding halo ring — grows and fades in with the input level.
          AnimatedContainer(
            duration: const Duration(milliseconds: 90),
            curve: Curves.easeOut,
            width: _size + _maxHalo * clamped,
            height: _size + _maxHalo * clamped,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.green700.withValues(alpha: 0.14 * clamped),
            ),
          ),
          // Gentle scale of the button face itself (max +5%).
          AnimatedScale(
            duration: const Duration(milliseconds: 90),
            curve: Curves.easeOut,
            scale: 1 + 0.05 * clamped,
            child: core,
          ),
        ],
      ),
    );
  }

  /// The two-state button face (idle mic circle / recording stop face).
  Widget _buildCore() {
    // Idle reuses the shared white-circle record control (mic glyph).
    if (!recording) {
      return RecordCircleButton(
        icon: AppIcons.mic,
        onTap: onTap,
        semanticLabel: 'Start recording',
        size: _size,
      );
    }
    return Semantics(
      button: true,
      label: 'Stop recording',
      child: GestureDetector(
        onTap: onTap,
        child: const SizedBox(
            width: _size, height: _size, child: _RecordingFace()),
      ),
    );
  }
}

/// Recording face: solid green-700 disc, pale green-50 inner disc, stop square.
class _RecordingFace extends StatelessWidget {
  const _RecordingFace();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.green700,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 72,
        height: 72,
        decoration: const BoxDecoration(
          color: AppColors.green50,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: AppColors.green700,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

/// Gallery demo exposing both [MicButton] states (tap to toggle).
class MicButtonDemo extends StatefulWidget {
  const MicButtonDemo({super.key});

  @override
  State<MicButtonDemo> createState() => _MicButtonDemoState();
}

class _MicButtonDemoState extends State<MicButtonDemo> {
  bool _recording = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MicButton(
            recording: _recording,
            onTap: () => setState(() => _recording = !_recording),
          ),
          const SizedBox(width: 24),
          const MicButton(recording: false, onTap: _noop),
          const SizedBox(width: 24),
          const MicButton(recording: true, onTap: _noop),
        ],
      ),
    );
  }

  static void _noop() {}
}
