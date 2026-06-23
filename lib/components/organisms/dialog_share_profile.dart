import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../atoms/button.dart';
import '../atoms/dim.dart';
import '../atoms/progress_bar.dart';

/// One labelled progress stat in a [DialogShareProfile], rendered with the
/// reused [ProgressBar] atom.
class ProfileStat {
  /// Creates a profile stat.
  const ProfileStat({required this.label, required this.value});

  /// Stat name shown on the left of the [ProgressBar] header.
  final String label;

  /// Progress value `0–100` (clamped by [ProgressBar]).
  final double value;
}

/// DialogShareProfile — Figma `03_Organisms / Dialog-ShareProfile`
/// (`2235:4652`).
///
/// A centered share card measured 1:1 from Figma:
/// - Width `335`, padding `16` top / `12` horizontal / `24` bottom,
///   radius [AppRadius.xs] (8), fill [AppColors.surface2] (#252932).
/// - Outer column gap `24` between the content block and the share button.
/// - Content: centered column.
///   - [avatar] / [imageProvider] — `80×80` circle.
///   - [caption] in `AppType.body1.r` ([AppColors.textSecondary]).
///   - [title] in `AppType.title3.b` (white). Caption→title gap `8`.
///   - [stats] — a column of [ProgressBar]s, gap `16`.
/// - Share button — reused [Button] ([BtnType.secondaryFill], [BtnSize.s60]),
///   full width, invoking [onShare].
///
/// Provide the avatar either as an [imageProvider] (rendered into the circle) or
/// as a fully custom [avatar] widget; if both are null a neutral placeholder is
/// shown. This widget renders only the card — lay it over a [Dim] scrim to
/// present it (see [DialogShareProfileDemo] or use [showDialogShareProfile]).
///
/// ```dart
/// DialogShareProfile(
///   imageProvider: NetworkImage(url),
///   caption: 'Your Korean accent sounds',
///   title: 'American',
///   stats: const [
///     ProfileStat(label: 'American', value: 87),
///     ProfileStat(label: 'British', value: 42),
///   ],
///   onShare: () {},
/// )
/// ```
class DialogShareProfile extends StatelessWidget {
  /// Creates a DialogShareProfile card.
  const DialogShareProfile({
    super.key,
    this.imageProvider,
    this.avatar,
    required this.caption,
    required this.title,
    this.stats = const [],
    this.onShare,
    this.shareLabel = '공유하기',
  });

  /// Image used for the `80×80` avatar circle. Ignored when [avatar] is set.
  final ImageProvider? imageProvider;

  /// Fully custom avatar widget; takes precedence over [imageProvider].
  final Widget? avatar;

  /// Caption above the title — `AppType.body1.r`, [AppColors.textSecondary].
  final String caption;

  /// Title — `AppType.title3.b`, white.
  final String title;

  /// Progress stats, each a reused [ProgressBar]; laid out in a column (gap 16).
  final List<ProfileStat> stats;

  /// Share button tap callback.
  final VoidCallback? onShare;

  /// Share button label.
  final String shareLabel;

  /// Figma card width.
  static const double _width = 335;

  /// Avatar diameter, per Figma.
  static const double _avatarSize = 80;

  Widget _buildAvatar() {
    if (avatar != null) {
      return ClipOval(
        child: SizedBox(width: _avatarSize, height: _avatarSize, child: avatar),
      );
    }
    return Container(
      width: _avatarSize,
      height: _avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceElevated,
        image: imageProvider == null
            ? null
            : DecorationImage(image: imageProvider!, fit: BoxFit.cover),
      ),
      alignment: Alignment.center,
      child: imageProvider == null
          ? const Icon(Icons.person, color: AppColors.textTertiary, size: 40)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: BorderRadius.circular(AppRadius.xs),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: _width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Content block (gap 24 to the button).
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: _buildAvatar()),
                  const SizedBox(height: 16),
                  // Caption + title, centered (gap 8).
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        caption,
                        textAlign: TextAlign.center,
                        style: AppType.body1.r
                            .copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: AppType.title3.b.copyWith(color: AppColors.text),
                      ),
                    ],
                  ),
                  if (stats.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    // Stats column of reused ProgressBars (gap 16).
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < stats.length; i++) ...[
                          if (i > 0) const SizedBox(height: 16),
                          ProgressBar(
                            label: stats[i].label,
                            value: stats[i].value,
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 24),
              Button(
                type: BtnType.secondaryFill,
                size: BtnSize.s60,
                text: shareLabel,
                onPressed: onShare,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows a [DialogShareProfile] over a [Dim] scrim using Flutter's [showDialog].
Future<T?> showDialogShareProfile<T>(
  BuildContext context, {
  ImageProvider? imageProvider,
  Widget? avatar,
  required String caption,
  required String title,
  List<ProfileStat> stats = const [],
  VoidCallback? onShare,
  String shareLabel = '공유하기',
}) {
  return showDialog<T>(
    context: context,
    barrierColor: Colors.transparent, // Dim provides the scrim.
    builder: (context) => Stack(
      children: [
        Dim(onTap: () => Navigator.of(context).maybePop()),
        Center(
          child: DialogShareProfile(
            imageProvider: imageProvider,
            avatar: avatar,
            caption: caption,
            title: title,
            stats: stats,
            onShare: onShare,
            shareLabel: shareLabel,
          ),
        ),
      ],
    ),
  );
}

/// Gallery demo for [DialogShareProfile]: the card laid over a [Dim] scrim
/// inside a [Stack]. Registration into the gallery is handled separately.
class DialogShareProfileDemo extends StatelessWidget {
  /// Creates the demo.
  const DialogShareProfileDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bg,
      child: Stack(
        children: [
          const Dim(),
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: const Center(
                child: DialogShareProfile(
                  caption: 'Your Korean accent sounds',
                  title: 'American',
                  stats: [
                    ProfileStat(label: 'American', value: 87),
                    ProfileStat(label: 'British', value: 42),
                    ProfileStat(label: 'Australian', value: 23),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
