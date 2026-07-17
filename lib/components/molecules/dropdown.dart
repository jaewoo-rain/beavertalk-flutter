import 'package:flutter/material.dart';

import '../../theme/app_color_tokens.dart';
import '../../theme/app_colors.dart';
import '../icons/app_icons.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// A single selectable entry inside a [Dropdown].
///
/// [label] is what the user sees; [value] is the opaque identity compared
/// against the [Dropdown.value] to decide selection. Values are compared with
/// `==`, so use types with sensible equality (primitives, enums, etc.).
@immutable
class DropdownItem<T> {
  /// Creates a dropdown option.
  const DropdownItem({required this.label, required this.value});

  /// Text rendered in the trigger (when selected) and in the option row.
  final String label;

  /// The identity carried back through [Dropdown.onChanged].
  final T value;
}

/// Available render sizes for [Dropdown] (the nominal trigger height in px).
///
/// Measured 1:1 from Figma `Dropdown` set `175:10075`. Each size pins the
/// trigger's vertical/horizontal padding, the left-icon and chevron box sizes,
/// the label typography, and the height of each option row in the expanded
/// panel.
enum DropdownSize {
  /// 56px tall. Trigger padding 16×20, 20px left icon, Body 2 (15px) bold label.
  /// Option rows are 52px and the panel uses radius 24 (lg).
  size56(
    padV: 16,
    padH: 20,
    leftIconSize: 20,
    gap: 6,
    rowHeight: 52,
    panelRadius: AppRadius.lg,
    isBody: true,
  ),

  /// 52px tall. Trigger padding 16×20, 20px left icon, Label 1 (14px) label.
  /// Option rows are 44px and the panel uses radius 24 (lg).
  size52(
    padV: 16,
    padH: 20,
    leftIconSize: 20,
    gap: 6,
    rowHeight: 44,
    panelRadius: AppRadius.lg,
    isBody: false,
  ),

  /// 48px tall. Trigger padding 14×20, 20px left icon, Label 1 (14px) label.
  /// Option rows are 44px and the panel uses radius 20.
  size48(
    padV: 14,
    padH: 20,
    leftIconSize: 20,
    gap: 6,
    rowHeight: 44,
    panelRadius: 20,
    isBody: false,
  ),

  /// 36px tall. Trigger padding 9×16, 16px left icon, Label 2 (13px) label.
  /// Option rows are 36px and the panel uses radius 16 (md).
  size36(
    padV: 9,
    padH: 16,
    leftIconSize: 16,
    gap: 4,
    rowHeight: 36,
    panelRadius: AppRadius.md,
    isBody: false,
  );

  const DropdownSize({
    required this.padV,
    required this.padH,
    required this.leftIconSize,
    required this.gap,
    required this.rowHeight,
    required this.panelRadius,
    required this.isBody,
  });

  /// Vertical content padding of the trigger (top == bottom).
  final double padV;

  /// Horizontal content padding of the trigger (left == right).
  final double padH;

  /// Left-icon box edge length in logical pixels.
  final double leftIconSize;

  /// Gap between the left icon and the label in logical pixels.
  final double gap;

  /// Height of one option row in the expanded panel, in logical pixels.
  final double rowHeight;

  /// Corner radius of the expanded option panel, in logical pixels.
  final double panelRadius;

  /// Whether the label uses Body 2 (15px) vs Label 1/2 (14/13px) typography.
  final bool isBody;

  /// The label [TextStyle] base for this size (weight applied by the caller).
  AppType get _typeBase => isBody
      ? AppType.body2
      : (this == DropdownSize.size36 ? AppType.label2 : AppType.label1);

  /// Typography used for option rows (Body 1 for 56, otherwise the label size).
  AppType get _rowTypeBase =>
      this == DropdownSize.size56 ? AppType.body1 : _typeBase;
}

/// A controlled dropdown / select, measured 1:1 from Figma
/// (`Dropdown` set `175:10075`, expanded variants `175:10373` / `175:10286`).
///
/// Tapping the trigger toggles an option panel rendered directly beneath it
/// (via an [OverlayPortal], so it floats above sibling content). The chevron
/// ([Icons.keyboard_arrow_down]) rotates 180° while expanded. Selecting a row
/// invokes [onChanged] with the row's value and closes the panel; tapping
/// outside also closes it.
///
/// The widget is **controlled**: the currently selected [value] is owned by the
/// caller and reflected in the trigger label. When [value] is null (or matches
/// no item) the [hintText] placeholder is shown in `textSecondary`.
///
/// Visual spec (measured), trigger shares `radius md` (16px) and a 1px stroke:
/// * default — fill `surface2`, border `surface2` (borderless look).
/// * focus / open — fill `surface2`, border `primary`.
/// * filled — fill `primary10`, border `primary` (a value is selected).
/// * disabled — fill `surface2`, border `borderSubtle`, label `textTertiary`.
///
/// Option rows (fill `surface2`): unselected label `textSecondary`, the
/// selected row's label renders white & bold, and the pointed/focused row gets
/// a `primary` border. Flutter has no hover state on touch, so hover is mapped
/// to the highlighted (pointed) row.
class Dropdown<T> extends StatefulWidget {
  /// Creates a controlled dropdown.
  const Dropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.hintText,
    this.leftIcon,
    this.size = DropdownSize.size56,
    this.enabled = true,
  });

  /// The selectable options, rendered in order in the expanded panel.
  final List<DropdownItem<T>> items;

  /// The currently selected value, or null when nothing is selected.
  final T? value;

  /// Called with the chosen value when the user picks a row.
  final ValueChanged<T>? onChanged;

  /// Placeholder shown in the trigger when no value is selected.
  final String? hintText;

  /// Optional leading icon in the trigger, sized to the variant's icon box.
  final Widget? leftIcon;

  /// The render size (padding / typography / row height). Defaults to 56px.
  final DropdownSize size;

  /// Whether the dropdown is interactive. When false it renders disabled.
  final bool enabled;

  @override
  State<Dropdown<T>> createState() => _DropdownState<T>();
}

class _DropdownState<T> extends State<Dropdown<T>> {
  final OverlayPortalController _portal = OverlayPortalController();
  final LayerLink _link = LayerLink();

  bool get _open => _portal.isShowing;

  DropdownItem<T>? get _selected {
    for (final item in widget.items) {
      if (item.value == widget.value) return item;
    }
    return null;
  }

  void _toggle() {
    if (!widget.enabled) return;
    setState(() => _portal.isShowing ? _portal.hide() : _portal.show());
  }

  void _close() {
    if (_portal.isShowing) setState(_portal.hide);
  }

  void _select(DropdownItem<T> item) {
    widget.onChanged?.call(item.value);
    _close();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _portal,
        overlayChildBuilder: _buildOverlay,
        child: _buildTrigger(),
      ),
    );
  }

  // ── Trigger ──────────────────────────────────────────────────────────────

  Widget _buildTrigger() {
    final DropdownSize spec = widget.size;
    final bool filled = _selected != null;

    final Color fill;
    final Color border;
    if (!widget.enabled) {
      fill = context.c.backgroundNormalAlternative;
      border = context.c.lineAlternative;
    } else if (_open) {
      // focus / expanded
      fill = context.c.backgroundNormalAlternative;
      border = context.c.primaryNormal;
    } else if (filled) {
      fill = context.c.primaryNormal10;
      border = context.c.primaryNormal;
    } else {
      // default — borderless look
      fill = context.c.backgroundNormalAlternative;
      border = context.c.backgroundNormalAlternative;
    }

    final Color labelColor = !widget.enabled
        ? context.c.labelDisabled
        : (filled ? context.c.labelStrong : context.c.labelNormal);
    final TextStyle labelStyle =
        (filled ? spec._typeBase.sb : spec._typeBase.r)
            .copyWith(color: labelColor);

    final Color iconColor =
        widget.enabled ? context.c.labelNormal : context.c.labelDisabled;

    Widget? leadingIcon;
    if (widget.leftIcon != null) {
      leadingIcon = Padding(
        padding: EdgeInsetsDirectional.only(end: spec.gap),
        child: IconTheme.merge(
          data: IconThemeData(size: spec.leftIconSize, color: iconColor),
          child: SizedBox(
            width: spec.leftIconSize,
            height: spec.leftIconSize,
            child: Center(child: widget.leftIcon),
          ),
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding:
            EdgeInsets.symmetric(horizontal: spec.padH, vertical: spec.padV),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: border, width: 1),
        ),
        child: Row(
          children: [
            ?leadingIcon,
            Expanded(
              child: Text(
                _selected?.label ?? widget.hintText ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: labelStyle,
              ),
            ),
            const SizedBox(width: 12),
            AnimatedRotation(
              turns: _open ? 0.5 : 0,
              duration: const Duration(milliseconds: 160),
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Expanded option panel ──────────────────────────────────────────────────

  Widget _buildOverlay(BuildContext overlayContext) {
    final DropdownSize spec = widget.size;
    // Size/position taken from the trigger (this State's element), not the
    // overlay context which lives in the Overlay subtree.
    final RenderBox box = context.findRenderObject() as RenderBox;
    final double width = box.size.width;

    return Stack(
      children: [
        // Tap-catcher to dismiss when tapping outside the panel.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _close,
          ),
        ),
        CompositedTransformFollower(
          link: _link,
          showWhenUnlinked: false,
          // 8px gap below the trigger (Figma expanded gap).
          offset: Offset(0, box.size.height + 8),
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: width,
              child: Material(
                type: MaterialType.transparency,
                child: _OptionPanel<T>(
                  spec: spec,
                  items: widget.items,
                  selected: widget.value,
                  onSelect: _select,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionPanel<T> extends StatefulWidget {
  const _OptionPanel({
    required this.spec,
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  final DropdownSize spec;
  final List<DropdownItem<T>> items;
  final T? selected;
  final ValueChanged<DropdownItem<T>> onSelect;

  @override
  State<_OptionPanel<T>> createState() => _OptionPanelState<T>();
}

class _OptionPanelState<T> extends State<_OptionPanel<T>> {
  int _pointed = -1;

  @override
  Widget build(BuildContext context) {
    final DropdownSize spec = widget.spec;
    final BorderRadius radius = BorderRadius.circular(spec.panelRadius);

    final List<Widget> rows = [];
    for (int i = 0; i < widget.items.length; i++) {
      final DropdownItem<T> item = widget.items[i];
      final bool isSelected = item.value == widget.selected;
      final bool isPointed = i == _pointed;

      final Color labelColor =
          isSelected ? context.c.labelStrong : context.c.labelNormal;
      final TextStyle style = (isSelected
              ? spec._rowTypeBase.sb
              : spec._rowTypeBase.r)
          .copyWith(color: labelColor);

      rows.add(
        MouseRegion(
          onEnter: (_) => setState(() => _pointed = i),
          onExit: (_) => setState(() => _pointed = -1),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => widget.onSelect(item),
            child: Container(
              height: spec.rowHeight,
              alignment: AlignmentDirectional.centerStart,
              padding: EdgeInsets.symmetric(horizontal: spec.padH),
              decoration: BoxDecoration(
                color: context.c.backgroundNormalAlternative,
                border: Border.all(
                  color: isPointed ? context.c.primaryNormal : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: style,
              ),
            ),
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.c.backgroundNormalAlternative,
        borderRadius: radius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000), // 0px 4px 20px rgba(0,0,0,0.06)
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Column(mainAxisSize: MainAxisSize.min, children: rows),
      ),
    );
  }
}

/// Gallery demo exposing every [Dropdown] size plus a live expand interaction.
class DropdownDemo extends StatefulWidget {
  /// Creates the dropdown gallery demo.
  const DropdownDemo({super.key});

  @override
  State<DropdownDemo> createState() => _DropdownDemoState();
}

class _DropdownDemoState extends State<DropdownDemo> {
  static const List<DropdownItem<String>> _items = [
    DropdownItem(label: '기본 목록 상태', value: 'a'),
    DropdownItem(label: '마우스 오버 상태', value: 'b'),
    DropdownItem(label: '이미 선택되어 있는 상태', value: 'c'),
    DropdownItem(label: '상품 옵션명', value: 'd'),
  ];

  final Map<String, String?> _values = {};

  @override
  Widget build(BuildContext context) {
    Widget section(String title, List<Widget> children) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    AppType.label2.m.copyWith(color: context.c.labelNormal)),
            const SizedBox(height: 12),
            ...children.expand((w) => [w, const SizedBox(height: 12)]),
            const SizedBox(height: 12),
          ],
        );

    Widget sizeBlock(String label, DropdownSize size) => section(label, [
          // Empty (placeholder) + interactive expand.
          Dropdown<String>(
            size: size,
            items: _items,
            value: _values[label],
            hintText: '클릭 했을 경우',
            leftIcon: AppIcons.calendar(color: context.c.labelNormal),
            onChanged: (v) => setState(() => _values[label] = v),
          ),
          // Pre-filled (no icon).
          Dropdown<String>(
            size: size,
            items: _items,
            value: 'c',
            hintText: '선택하세요',
            onChanged: (_) {},
          ),
          // Disabled.
          Dropdown<String>(
            size: size,
            items: _items,
            value: 'd',
            enabled: false,
            leftIcon: AppIcons.calendar(color: context.c.labelNormal),
            onChanged: (_) {},
          ),
        ]);

    return ColoredBox(
      color: context.c.backgroundNormalDeep,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizeBlock('size 56', DropdownSize.size56),
            sizeBlock('size 52', DropdownSize.size52),
            sizeBlock('size 48', DropdownSize.size48),
            sizeBlock('size 36', DropdownSize.size36),
          ],
        ),
      ),
    );
  }
}
