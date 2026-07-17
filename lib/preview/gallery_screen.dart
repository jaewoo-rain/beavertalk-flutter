import 'package:flutter/material.dart';
import '../theme/app_color_tokens.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'gallery_entry.dart';
import 'gallery_registry.dart';

const _groupOrder = ['chrome', 'atoms', 'molecules', 'organisms'];

/// Component gallery — a sidebar of every registered component; tap to preview.
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  int _selected = 0;

  List<GalleryEntry> get _sorted {
    final list = [...galleryEntries];
    list.sort((a, b) {
      final g = _groupOrder.indexOf(a.group) - _groupOrder.indexOf(b.group);
      return g != 0 ? g : a.title.compareTo(b.title);
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final entries = _sorted;
    return Scaffold(
      backgroundColor: context.c.backgroundNormalDeep,
      body: SafeArea(
        child: entries.isEmpty
            ? Center(
                child: Text('등록된 컴포넌트가 없습니다.',
                    style: AppType.label1.r.copyWith(color: context.c.labelNormal)),
              )
            : Row(
                children: [
                  SizedBox(
                    width: 220,
                    child: _Sidebar(
                      entries: entries,
                      selected: _selected,
                      onSelect: (i) => setState(() => _selected = i),
                    ),
                  ),
                  VerticalDivider(width: 1, color: context.c.lineNeutral),
                  Expanded(
                    child: Container(
                      color: context.c.backgroundNormalDeep,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entries[_selected].title, style: AppType.title3.sb),
                            if (entries[_selected].node != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text('Figma ${entries[_selected].node}',
                                    style: AppType.caption1.r
                                        .copyWith(color: context.c.labelNormal)),
                              ),
                            const SizedBox(height: 24),
                            Builder(builder: entries[_selected].builder),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.entries, required this.selected, required this.onSelect});
  final List<GalleryEntry> entries;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: entries.length,
      itemBuilder: (context, i) {
        final e = entries[i];
        final isFirstOfGroup = i == 0 || entries[i - 1].group != e.group;
        final active = i == selected;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isFirstOfGroup)
              Padding(
                padding: EdgeInsets.only(top: i == 0 ? 0 : 16, bottom: 8, left: 8),
                child: Text(e.group.toUpperCase(),
                    style: AppType.caption1.m.copyWith(color: context.c.labelNormal)),
              ),
            Material(
              color: active ? context.c.backgroundNormalAlternative : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => onSelect(i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Text(e.title,
                      style: AppType.label1.r.copyWith(
                          color: active ? context.c.labelStrong : context.c.labelNormal)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}