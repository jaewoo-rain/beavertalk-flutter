import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// The visual variant of a [Gnb] (Global Navigation Bar / top app bar).
///
/// Measured 1:1 from Figma `03_Organisms / GNB` (`162:46473`). Every variant is
/// a `375`-wide row/column with `14px 20px` padding (except [GnbType.sub], which
/// uses `12px 10px` per Figma).
enum GnbType {
  /// Back arrow (left) + centered title. A balancing transparent arrow sits on
  /// the right so the title stays optically centered. Background: surface.
  main,

  /// Back arrow (left) + progress bar (fill) + `current/total` label (right).
  /// Background: transparent — the page body shows through, so the bar reads
  /// seamlessly on any background (surface, surface2, …). Height fixed at `56`.
  ///
  /// Per Figma the progress fill is the mint [AppColors.primary] (#00FFB2) and
  /// the track is [AppColors.primary10] (the primary at ~10%).
  main2,

  /// A centered column: a status row (colored dot + caption), a title, and a
  /// caption line below (e.g. a call timer). Background: surface.
  sub,

  /// A transparent (mirror) back arrow on the left, a centered title, and a
  /// real close button on the right. Background: surfaceElevated.
  sub2,
}

/// Progress data for [GnbType.main2].
///
/// Provide either an explicit [value] in `0–1`, or [current]/[total] (the value
/// is then `current / total`). The `current/total` label is rendered from
/// [current] and [total] when both are non-null.
@immutable
class GnbProgress {
  /// Creates progress data. Supply [value] and/or [current]+[total].
  const GnbProgress({this.value, this.current, this.total})
      : assert(
          value != null || (current != null && total != null),
          'Provide value, or both current and total.',
        );

  /// Explicit fill fraction in `0–1`. Falls back to `current / total`.
  final double? value;

  /// Current step (1-based), shown in the `current/total` label.
  final int? current;

  /// Total number of steps, shown in the `current/total` label.
  final int? total;

  /// The resolved fill fraction, clamped to `0–1`.
  double get fraction {
    final raw = value ??
        ((total != null && total != 0) ? current! / total! : 0.0);
    return raw.clamp(0.0, 1.0).toDouble();
  }

  /// The `current/total` label, or `null` when either is missing.
  String? get label =>
      (current != null && total != null) ? '$current/$total' : null;
}

/// GNB — BeaverTalk top navigation bar. Figma `03_Organisms / GNB` (`162:46473`).
///
/// One widget, four [GnbType] variants. Build with the named constructors for
/// clarity, or pass [type] directly.
///
/// Props (per spec): [type], [title], [onBack], [onClose], [progress]
/// (value/current/total), [status], [caption], [trailing].
///
/// ```dart
/// Gnb.main(title: 'Settings', onBack: () => Navigator.pop(context));
/// Gnb.main2(progress: const GnbProgress(current: 1, total: 10), onBack: ...);
/// Gnb.sub(status: 'Connected', title: 'Annoying Beaver', caption: '00:00:01');
/// Gnb.sub2(title: 'Profile', onBack: ..., onClose: ...);
/// ```
class Gnb extends StatelessWidget {
  /// Creates a GNB with an explicit [type]. Prefer the named constructors.
  const Gnb({
    super.key,
    required this.type,
    this.title,
    this.onBack,
    this.onClose,
    this.progress,
    this.status,
    this.statusColor = AppColors.primary,
    this.caption,
    this.trailing,
  });

  /// [GnbType.main]: back arrow + centered [title].
  const Gnb.main({
    Key? key,
    String? title,
    VoidCallback? onBack,
    Widget? trailing,
  }) : this(
          key: key,
          type: GnbType.main,
          title: title,
          onBack: onBack,
          trailing: trailing,
        );

  /// [GnbType.main2]: back arrow + [progress] bar + `current/total`.
  const Gnb.main2({
    Key? key,
    required GnbProgress progress,
    VoidCallback? onBack,
    VoidCallback? onClose,
    Widget? trailing,
  }) : this(
          key: key,
          type: GnbType.main2,
          progress: progress,
          onBack: onBack,
          onClose: onClose,
          trailing: trailing,
        );

  /// [GnbType.sub]: centered status dot + [status], [title], [caption] column.
  const Gnb.sub({
    Key? key,
    required String title,
    String? status,
    Color statusColor = AppColors.primary,
    String? caption,
  }) : this(
          key: key,
          type: GnbType.sub,
          title: title,
          status: status,
          statusColor: statusColor,
          caption: caption,
        );

  /// [GnbType.sub2]: mirrored back arrow + centered [title] + close button.
  const Gnb.sub2({
    Key? key,
    String? title,
    VoidCallback? onBack,
    VoidCallback? onClose,
  }) : this(
          key: key,
          type: GnbType.sub2,
          title: title,
          onBack: onBack,
          onClose: onClose,
        );

  /// Which variant to render.
  final GnbType type;

  /// Centered title text ([GnbType.main]/[GnbType.sub]/[GnbType.sub2]).
  final String? title;

  /// Tapped when the back arrow is pressed.
  final VoidCallback? onBack;

  /// Tapped when the close button is pressed ([GnbType.sub2]).
  final VoidCallback? onClose;

  /// Progress data for [GnbType.main2].
  final GnbProgress? progress;

  /// Status caption above the title in [GnbType.sub] (e.g. `Connected`).
  final String? status;

  /// Color of the status dot in [GnbType.sub].
  final Color statusColor;

  /// Caption below the title in [GnbType.sub] (e.g. a `00:00:01` timer).
  final String? caption;

  /// Optional widget pinned to the trailing edge ([GnbType.main]/[main2]).
  /// When omitted, a balancing transparent spacer keeps the title centered.
  final Widget? trailing;

  /// Horizontal padding for row variants (Figma `20`).
  static const double _hPad = 20;

  /// Vertical padding for row variants (Figma `14`).
  static const double _vPad = 14;

  /// Tap-target size for the back/close icons.
  static const double _iconBox = 28;

  Color get _background {
    switch (type) {
      case GnbType.main:
      case GnbType.sub:
        return AppColors.surface;
      case GnbType.main2:
        return Colors.transparent;
      case GnbType.sub2:
        return AppColors.surfaceElevated;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget content;
    switch (type) {
      case GnbType.main:
        content = _buildMain();
      case GnbType.main2:
        content = _buildMain2();
      case GnbType.sub:
        content = _buildSub();
      case GnbType.sub2:
        content = _buildSub2();
    }

    final padding = type == GnbType.sub
        ? const EdgeInsets.symmetric(horizontal: 10, vertical: 12)
        : const EdgeInsets.symmetric(horizontal: _hPad, vertical: _vPad);

    return Semantics(
      container: true,
      header: true,
      child: Material(
        color: _background,
        child: SafeArea(
          bottom: false,
          child: Padding(padding: padding, child: content),
        ),
      ),
    );
  }

  // ── main: back + centered title ────────────────────────────────
  Widget _buildMain() {
    return Row(
      children: [
        _BackButton(onTap: onBack),
        Expanded(child: _CenteredTitle(title)),
        // Trailing slot, or a transparent balancing spacer to keep the title
        // optically centered (matches Figma's opacity-0 mirror arrow).
        trailing ?? const SizedBox(width: _iconBox, height: _iconBox),
      ],
    );
  }

  // ── main-2: back + progress + current/total ────────────────────
  Widget _buildMain2() {
    final p = progress ?? const GnbProgress(value: 0);
    final label = p.label;
    return SizedBox(
      height: 56 - (_vPad * 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Figma learning flow uses a close (X) on the left; other main2
          // screens use a back arrow. (from feat/seoyeon)
          if (onClose != null)
            _CloseButton(onTap: onClose)
          else
            _BackButton(onTap: onBack),
          const SizedBox(width: 8),
          Expanded(child: _GnbProgressTrack(fraction: p.fraction)),
          const SizedBox(width: 8),
          if (trailing != null)
            trailing!
          else if (label != null)
            Flexible(
              child: Semantics(
                label: 'Step $label',
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.body1.sb.copyWith(color: AppColors.text),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── sub: status dot + title + caption (centered column) ─────────
  Widget _buildSub() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (status != null) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  status!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.label1.r
                      .copyWith(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        Text(
          title ?? '',
          textAlign: TextAlign.center,
          style: AppType.body1.sb.copyWith(color: AppColors.text),
        ),
        if (caption != null) ...[
          const SizedBox(height: 4),
          Text(
            caption!,
            textAlign: TextAlign.center,
            style: AppType.label1.r.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ],
    );
  }

  // ── sub-2: mirror back + centered title + close ────────────────
  Widget _buildSub2() {
    return Row(
      children: [
        // Transparent mirror arrow on the left (Figma opacity 0) — present for
        // symmetry so the title is centered against the close button.
        const Opacity(
          opacity: 0,
          child: ExcludeSemantics(
            child: SizedBox(
              width: _iconBox,
              height: _iconBox,
              child: CustomPaint(painter: _ArrowLeftPainter()),
            ),
          ),
        ),
        Expanded(child: _CenteredTitle(title)),
        _CloseButton(onTap: onClose),
      ],
    );
  }
}

/// Centered, single-line title used by several GNB variants.
class _CenteredTitle extends StatelessWidget {
  const _CenteredTitle(this.title);

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? '',
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppType.body1.sb.copyWith(color: AppColors.text),
    );
  }
}

/// Back-arrow icon button (28×28 tap target), Figma `arrow-left` (`162:4156`).
class _BackButton extends StatelessWidget {
  const _BackButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: AppLocalizations.of(context).back,
      child: InkResponse(
        onTap: onTap,
        radius: 24,
        child: const SizedBox(
          width: Gnb._iconBox,
          height: Gnb._iconBox,
          child: CustomPaint(painter: _ArrowLeftPainter()),
        ),
      ),
    );
  }
}

/// Close icon button (28×28 tap target), Figma `close` (`162:4163`).
class _CloseButton extends StatelessWidget {
  const _CloseButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Close',
      child: InkResponse(
        onTap: onTap,
        radius: 24,
        child: const SizedBox(
          width: Gnb._iconBox,
          height: Gnb._iconBox,
          child: CustomPaint(painter: _ClosePainter()),
        ),
      ),
    );
  }
}

/// Slim progress track for [GnbType.main2].
///
/// Per Figma (measured): track height `4`, radius `8`; fill is the mint
/// [AppColors.primary]; track background is [AppColors.primary10].
class _GnbProgressTrack extends StatelessWidget {
  const _GnbProgressTrack({required this.fraction});

  final double fraction;

  @override
  Widget build(BuildContext context) {
    final value = fraction.clamp(0.0, 1.0).toDouble();
    return Semantics(
      value: '${(value * 100).round()}%',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xs),
        child: SizedBox(
          height: 4,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  const Positioned.fill(
                    child: ColoredBox(color: AppColors.primary10),
                  ),
                  Container(
                    width: constraints.maxWidth * value,
                    height: 4,
                    color: AppColors.primary,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Paints the Figma `arrow-left` glyph (`162:4156`) scaled into its 28×28 box.
class _ArrowLeftPainter extends CustomPainter {
  const _ArrowLeftPainter();

  // Path data taken verbatim from the Figma SVG export (28×28 viewBox).
  static const String _d =
      'M9.67557 14.8249C9.45685 14.6061 9.33398 14.3094 9.33398 14.0001C9.33398 '
      '13.6907 9.45685 13.394 9.67557 13.1752L16.2754 6.57541C16.383 6.46398 '
      '16.5118 6.3751 16.6541 6.31396C16.7964 6.25281 16.9495 6.22063 17.1044 '
      '6.21928C17.2593 6.21794 17.413 6.24746 17.5563 6.30612C17.6997 6.36478 '
      '17.83 6.45141 17.9395 6.56095C18.0491 6.67049 18.1357 6.80075 18.1944 '
      '6.94413C18.253 7.08751 18.2825 7.24113 18.2812 7.39604C18.2798 7.55095 '
      '18.2477 7.70404 18.1865 7.84638C18.1254 7.98872 18.0365 8.11745 17.9251 '
      '8.22507L12.1501 14.0001L17.9251 19.7751C18.1376 19.9951 18.2552 20.2898 '
      '18.2525 20.5957C18.2499 20.9016 18.1272 21.1942 17.9109 21.4105C17.6945 '
      '21.6268 17.4019 21.7495 17.096 21.7522C16.7901 21.7549 16.4954 21.6373 '
      '16.2754 21.4247L9.67557 14.8249Z';

  @override
  void paint(Canvas canvas, Size size) {
    final path = parseSvgPath(_d);
    final scale = size.width / 28.0;
    canvas.save();
    canvas.scale(scale);
    canvas.drawPath(path, Paint()..color = AppColors.text);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ArrowLeftPainter oldDelegate) => false;
}

/// Paints the Figma `close` glyph (`162:4163`) scaled into its 28×28 box.
class _ClosePainter extends CustomPainter {
  const _ClosePainter();

  static const String _d =
      'M8.28301 21.3499C7.83197 21.801 7.10071 21.801 6.64967 21.3499C6.19864 '
      '20.8989 6.19864 20.1676 6.64967 19.7166L12.3663 13.9999L6.64967 '
      '8.28325C6.19864 7.83222 6.19864 7.10095 6.64967 6.64992C7.10071 6.19889 '
      '7.83198 6.19889 8.28301 6.64992L13.9997 12.3666L19.7163 6.64992C20.1674 '
      '6.19889 20.8986 6.19889 21.3497 6.64992C21.8007 7.10095 21.8007 7.83222 '
      '21.3497 8.28325L15.633 13.9999L21.3497 19.7166C21.8007 20.1676 21.8007 '
      '20.8989 21.3497 21.3499C20.8986 21.801 20.1674 21.801 19.7163 '
      '21.3499L13.9997 15.6333L8.28301 21.3499Z';

  @override
  void paint(Canvas canvas, Size size) {
    final path = parseSvgPath(_d);
    final scale = size.width / 28.0;
    canvas.save();
    canvas.scale(scale);
    canvas.drawPath(path, Paint()..color = AppColors.text);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ClosePainter oldDelegate) => false;
}

// ── Minimal SVG path parser ─────────────────────────────────────
//
// Handles the absolute M/L/C/Z commands present in the exported GNB icon paths.
// (The Figma exports use only these.) Kept local so the widget needs no extra
// dependency; tokens are split on whitespace and commas.

/// Parses a (subset of) SVG path [d] string into a [Path].
///
/// Supports absolute commands `M`, `L`, `C`, and `Z` — sufficient for the
/// exported GNB icon glyphs. Coordinates are in the 28×28 Figma viewBox space.
Path parseSvgPath(String d) {
  final path = Path();
  final tokens = _tokenize(d);
  var i = 0;
  double cx = 0;
  double cy = 0;

  double next() => tokens[i++].value!;

  while (i < tokens.length) {
    final cmd = tokens[i++].cmd!;
    switch (cmd) {
      case 'M':
        cx = next();
        cy = next();
        path.moveTo(cx, cy);
      case 'L':
        cx = next();
        cy = next();
        path.lineTo(cx, cy);
      case 'C':
        final x1 = next();
        final y1 = next();
        final x2 = next();
        final y2 = next();
        cx = next();
        cy = next();
        path.cubicTo(x1, y1, x2, y2, cx, cy);
      case 'Z':
        path.close();
    }
  }
  return path;
}

class _Token {
  const _Token.cmd(this.cmd) : value = null;
  const _Token.num(this.value) : cmd = null;
  final String? cmd;
  final double? value;
}

List<_Token> _tokenize(String d) {
  final tokens = <_Token>[];
  final buf = StringBuffer();

  void flush() {
    if (buf.isNotEmpty) {
      tokens.add(_Token.num(double.parse(buf.toString())));
      buf.clear();
    }
  }

  for (var k = 0; k < d.length; k++) {
    final ch = d[k];
    if (ch == 'M' || ch == 'L' || ch == 'C' || ch == 'Z') {
      flush();
      tokens.add(_Token.cmd(ch));
    } else if (ch == ' ' || ch == ',' || ch == '\n' || ch == '\t') {
      flush();
    } else if (ch == '-' && buf.isNotEmpty) {
      // A '-' starts a new number (no separator before negatives in exports).
      flush();
      buf.write(ch);
    } else {
      buf.write(ch);
    }
  }
  flush();
  return tokens;
}

/// Gallery demo: every [GnbType] variant and a few states.
class GnbDemo extends StatelessWidget {
  /// Creates the demo.
  const GnbDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bg,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _label('main'),
            Gnb.main(title: 'Page name', onBack: () {}),
            _label('main-2 (1/10)'),
            Gnb.main2(
              progress: const GnbProgress(current: 1, total: 10),
              onBack: () {},
            ),
            _label('main-2 (7/10)'),
            Gnb.main2(
              progress: const GnbProgress(current: 7, total: 10),
              onBack: () {},
            ),
            _label('sub'),
            const Gnb.sub(
              status: 'Connected',
              title: 'Annoying Beaver',
              caption: '00:00:01',
            ),
            _label('sub-2'),
            Gnb.sub2(title: 'Page name', onBack: () {}, onClose: () {}),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: AppType.caption1.m.copyWith(color: AppColors.textSecondary),
          ),
        ),
      );
}
