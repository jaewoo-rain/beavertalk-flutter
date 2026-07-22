import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../icons/app_icons.dart';

/// Which side of the conversation a [ChatBubble] belongs to.
///
/// Figma component set `176:21728` (ChatBubble), states `ai` / `user`.
enum ChatSender {
  /// The assistant ("Beaver"). Bubble is left-aligned with a squared
  /// `topLeft` corner and may show an action toolbar + translation line.
  ai,

  /// The human user. Bubble is right-aligned with a squared `topRight`
  /// corner; typically a single white line of Korean text.
  user,
}

/// ChatBubble — an asymmetric speech bubble for the conversation view.
///
/// Figma component set `176:21728` (ChatBubble).
///
/// Measured from Figma:
/// - Bubble fill `Background/Elevated/Alternative` (`#1F222A`), padding `18`,
///   `maxWidth` 295, column gap `8`.
/// - Asymmetric radius (16 elsewhere): `ai` squares `topLeft`
///   (`0,16,16,16`), `user` squares `topRight` (`16,0,16,16`).
/// - Primary text: Korean copy in white [AppType.body1] (`MO/Body 1`).
/// - [translation] (e.g. English): `Label/Normal`, same size.
/// - Divider before the toolbar: 1px `Line/Alternative`
///   (`Line/Normal/Alternative`).
/// - Optional [actions] toolbar (row, gap 8) — speaker / translate /
///   bookmark / flag in Figma; provide any widgets (e.g. [TranslateToggle]).
///
/// Presentation-only: pass [text], optional [translation], and optional
/// [actions]. Alignment within a parent is the caller's responsibility, but
/// the bubble already aligns itself via [Align].
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.sender,
    required this.text,
    this.translation,
    this.actions,
  });

  /// Whether this bubble is from the [ChatSender.ai] or [ChatSender.user].
  final ChatSender sender;

  /// Primary message text (Korean copy in the design), rendered white.
  final String text;

  /// Optional secondary/translation line, rendered in
  /// `Label/Normal`. When `null` the line is omitted.
  final String? translation;

  /// Optional action toolbar widgets (speaker / translate / bookmark /
  /// flag). When `null` or empty, no divider or toolbar is shown.
  final List<Widget>? actions;

  static const double _maxWidth = 295;
  static const double _padding = 18;

  BorderRadius get _radius {
    const Radius r = Radius.circular(AppRadius.md); // 16
    const Radius z = Radius.zero;
    return switch (sender) {
      ChatSender.ai => const BorderRadius.only(
          topLeft: z,
          topRight: r,
          bottomLeft: r,
          bottomRight: r,
        ),
      ChatSender.user => const BorderRadius.only(
          topLeft: r,
          topRight: z,
          bottomLeft: r,
          bottomRight: r,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> toolbar = actions ?? const <Widget>[];
    final bool hasToolbar = toolbar.isNotEmpty;

    final bubble = Container(
      constraints: const BoxConstraints(maxWidth: _maxWidth),
      padding: const EdgeInsets.all(_padding),
      decoration: BoxDecoration(
        color: context.c.backgroundElevatedAlternative,
        borderRadius: _radius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: AppType.body1.r),
          if (translation != null) ...[
            const SizedBox(height: 4),
            Text(
              translation!,
              style: AppType.body1.r.copyWith(color: context.c.labelNormal),
            ),
          ],
          if (hasToolbar) ...[
            const SizedBox(height: 8),
            Divider(
              height: 1,
              thickness: 1,
              color: context.c.lineAlternative,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < toolbar.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  toolbar[i],
                ],
              ],
            ),
          ],
        ],
      ),
    );

    return Align(
      alignment: sender == ChatSender.ai
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: bubble,
    );
  }
}

/// Gallery demo exposing both [ChatBubble] variants.
class ChatBubbleDemo extends StatelessWidget {
  const ChatBubbleDemo({super.key});

  @override
  Widget build(BuildContext context) {
    Widget toolIcon(AppIconBuilder icon, {bool active = false}) => icon(
          size: 24,
          color: active ? context.c.primaryNormal : context.c.labelNormal,
        );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const ChatBubble(
            sender: ChatSender.user,
            text: '오늘 진짜 추워. 강아지랑 같이 얼음 됐어.',
          ),
          const SizedBox(height: 12),
          ChatBubble(
            sender: ChatSender.ai,
            text: '오, 정말 괜찮아!',
            translation: 'Oh, no worries at all!',
            actions: [
              toolIcon(AppIcons.volume),
              toolIcon(AppIcons.translate, active: true),
              toolIcon(AppIcons.bookmarkLine),
              toolIcon(AppIcons.flag),
            ],
          ),
          const SizedBox(height: 12),
          const ChatBubble(
            sender: ChatSender.ai,
            text: '오, 정말 괜찮아!',
            translation: 'Oh, no worries at all!',
          ),
        ],
      ),
    );
  }
}
