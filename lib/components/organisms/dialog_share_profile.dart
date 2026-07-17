import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_colors.dart';
import '../icons/app_icons.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../atoms/dim.dart';
import '../atoms/progress_bar.dart';

/// One labelled progress stat in a [DialogShareProfile], rendered with the
/// reused [ProgressBar] atom.
class ProfileStat {
  /// Creates a profile stat.
  const ProfileStat({
    required this.label,
    required this.value,
    this.active = true,
  });

  /// Stat name shown on the left of the [ProgressBar] header.
  final String label;

  /// Progress value `0–100` (clamped by [ProgressBar]).
  final double value;

  /// Whether this bar is the highlighted (primary/green) accent. The top accent
  /// is active; the rest render muted (grey) per Figma `2235:4652`.
  final bool active;
}

/// DialogShareProfile — Figma `03_Organisms / Dialog-ShareProfile`
/// (`2235:4652`).
///
/// A centered share card measured 1:1 from Figma: avatar, `caption` + `title`,
/// and a column of accent [ProgressBar]s, with a share affordance below.
///
/// ## Sharing an image (not text)
/// The web app shares this result as a **PNG** of the card (see
/// `guess-my-accent/share/ShareCard.tsx` + `useShareImage.ts` — capture the 9:16
/// card DOM at scale 3). This dialog does the Flutter equivalent: the card
/// (avatar + accent + bars + branding, everything except the Share button) sits
/// in a [RepaintBoundary]; tapping Share rasterizes it via
/// [RenderRepaintBoundary.toImage] and shares the file through `share_plus`,
/// with [shareText] as the accompanying caption. If capture fails it degrades to
/// sharing [shareText] alone, so Share never silently no-ops.
///
/// Provide the avatar either as an [imageProvider] or a fully custom [avatar];
/// if both are null a neutral placeholder is shown. Render the card over a [Dim]
/// scrim (see [showDialogShareProfile] / [DialogShareProfileDemo]).
class DialogShareProfile extends StatefulWidget {
  /// Creates a DialogShareProfile card.
  const DialogShareProfile({
    super.key,
    this.imageProvider,
    this.avatar,
    required this.caption,
    required this.title,
    this.stats = const [],
    this.shareText,
    this.onShared,
    this.shareLabel,
  });

  /// Image used for the `80×80` avatar circle. Ignored when [avatar] is set.
  final ImageProvider? imageProvider;

  /// Fully custom avatar widget; takes precedence over [imageProvider].
  final Widget? avatar;

  /// Caption above the title — `AppType.body1.r`, `Label/Normal`.
  final String caption;

  /// Title — `AppType.title3.b`, white.
  final String title;

  /// Progress stats, each a reused [ProgressBar]; laid out in a column (gap 16).
  final List<ProfileStat> stats;

  /// Text shared alongside the card image (invite/caption). When capture fails
  /// this is shared on its own.
  final String? shareText;

  /// Called after the share sheet has been dispatched (e.g. to close the
  /// dialog). Not awaited.
  final VoidCallback? onShared;

  /// Share button label. Defaults to the localized `share` string when
  /// omitted.
  final String? shareLabel;

  @override
  State<DialogShareProfile> createState() => _DialogShareProfileState();
}

class _DialogShareProfileState extends State<DialogShareProfile> {
  /// Wraps the shareable card (everything but the Share button) so it can be
  /// rasterized to a PNG on share.
  final GlobalKey _cardKey = GlobalKey();

  bool _sharing = false;

  /// Figma card width.
  static const double _width = 335;

  /// Avatar diameter, per Figma.
  static const double _avatarSize = 80;

  Widget _buildAvatar() {
    if (widget.avatar != null) {
      return ClipOval(
        child: SizedBox(
          width: _avatarSize,
          height: _avatarSize,
          child: widget.avatar,
        ),
      );
    }
    return Container(
      width: _avatarSize,
      height: _avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.c.backgroundElevatedAlternative,
        image: widget.imageProvider == null
            ? null
            : DecorationImage(image: widget.imageProvider!, fit: BoxFit.cover),
      ),
      alignment: Alignment.center,
      child: widget.imageProvider == null
          ? AppIcons.profile(color: context.c.labelDisabled, size: 40)
          : null,
    );
  }

  /// Rasterizes the card and shares it as a PNG (+ [DialogShareProfile.shareText]).
  /// Degrades to text-only on any failure; never throws.
  Future<void> _shareCardImage() async {
    if (_sharing) return;
    setState(() => _sharing = true);
    final text = widget.shareText;
    try {
      final boundary =
          _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      final image = boundary == null ? null : await boundary.toImage(pixelRatio: 3);
      final bytes = image == null
          ? null
          : await image.toByteData(format: ui.ImageByteFormat.png);
      image?.dispose();
      if (bytes != null) {
        final dir = await getTemporaryDirectory();
        final file = File(
          '${dir.path}/beavertalk_accent_'
          '${DateTime.now().millisecondsSinceEpoch}.png',
        );
        await file.writeAsBytes(bytes.buffer.asUint8List());
        await SharePlus.instance.share(
          ShareParams(text: text, files: <XFile>[XFile(file.path)]),
        );
      } else if (text != null) {
        // Capture unavailable → share the caption alone rather than nothing.
        await SharePlus.instance.share(ShareParams(text: text));
      }
    } catch (e) {
      debugPrint('share card failed → text fallback: $e');
      if (text != null) {
        try {
          await SharePlus.instance.share(ShareParams(text: text));
        } catch (_) {}
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
      widget.onShared?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolvedShareLabel =
        widget.shareLabel ?? AppLocalizations.of(context).share;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Captured region: the card itself (with its own background + branding),
        // excluding the Share button below.
        RepaintBoundary(
          key: _cardKey,
          child: Material(
            color: context.c.backgroundNormalAlternative,
            borderRadius: BorderRadius.circular(AppRadius.xs),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              width: _width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(child: _buildAvatar()),
                    const SizedBox(height: 16),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.caption,
                          textAlign: TextAlign.center,
                          style: AppType.body1.r
                              .copyWith(color: context.c.labelNormal),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style:
                              AppType.title3.b.copyWith(color: context.c.labelStrong),
                        ),
                      ],
                    ),
                    if (widget.stats.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var i = 0; i < widget.stats.length; i++) ...[
                            if (i > 0) const SizedBox(height: 16),
                            ProgressBar(
                              label: widget.stats[i].label,
                              value: widget.stats[i].value,
                              active: widget.stats[i].active,
                            ),
                          ],
                        ],
                      ),
                    ],
                    // Branding footer (matches the web ShareCard) so the shared
                    // image is self-identifying.
                    const SizedBox(height: 24),
                    Text(
                      'BeaverTalk',
                      textAlign: TextAlign.center,
                      style: AppType.body1.b.copyWith(color: context.c.primaryNormal),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'www.beavertalk.im',
                      textAlign: TextAlign.center,
                      style: AppType.label2.r
                          .copyWith(color: context.c.labelDisabled),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Share button — kept below the captured card so it isn't in the image.
        SizedBox(
          width: _width,
          child: Material(
            color: context.c.backgroundElevatedNormal,
            borderRadius: BorderRadius.circular(AppRadius.md),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: _sharing ? null : _shareCardImage,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                child: _sharing
                    ? Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: context.c.labelStrong,
                          ),
                        ),
                      )
                    : Text(
                        resolvedShareLabel,
                        textAlign: TextAlign.center,
                        style: AppType.body1.sb.copyWith(color: context.c.labelStrong),
                      ),
              ),
            ),
          ),
        ),
      ],
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
  String? shareText,
  VoidCallback? onShared,
  String? shareLabel,
}) {
  return showDialog<T>(
    context: context,
    barrierColor: Colors.transparent, // Dim provides the scrim.
    builder: (context) => Stack(
      children: [
        Dim(onTap: () => Navigator.of(context).maybePop()),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: DialogShareProfile(
              imageProvider: imageProvider,
              avatar: avatar,
              caption: caption,
              title: title,
              stats: stats,
              shareText: shareText,
              onShared: onShared,
              shareLabel: shareLabel,
            ),
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
      color: context.c.backgroundNormalDeep,
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
