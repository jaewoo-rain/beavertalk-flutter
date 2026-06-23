import 'package:flutter/widgets.dart';

/// One entry in the component gallery. Each component contributes a demo that
/// shows its variants/states. Registered in `gallery_registry.dart`.
class GalleryEntry {
  const GalleryEntry({
    required this.group, // 'chrome' | 'atoms' | 'molecules' | 'organisms'
    required this.title,
    required this.builder,
    this.node, // Figma node id, for traceability
  });

  final String group;
  final String title;
  final String? node;
  final WidgetBuilder builder;
}