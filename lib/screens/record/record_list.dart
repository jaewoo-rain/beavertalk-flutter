import 'package:flutter/material.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/molecules/card_box.dart';
import '../../components/molecules/segmented_tabs.dart';
import '../../components/organisms/gnb.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// A mock conversation record.
class _Record {
  const _Record(this.title, this.subtitle, this.date, this.duration);
  final String title;
  final String subtitle;
  final String date;
  final String duration;
}

const _records = <_Record>[
  _Record('Judi', '강아지 산책과 음악 취향', '2026.01.01.', '10분 38초'),
  _Record('Judi', '주말 영화 추천', '2025.12.30.', '8분 21초'),
  _Record('Annoying Beaver', '오늘 날씨 이야기', '2025.12.28.', '12분 04초'),
];

/// Conversation records — Figma `screen/record_list` (`2117:20307`).
///
/// Layout (top → bottom): a back-only GNB, a [SegmentedTabs] row (기록 / 보관)
/// where 보관 jumps to [Routes.recordsArchive], a "통화 기록" section label, then
/// a list of past calls as [CardBox]es; tapping one opens its analysis.
class RecordListScreen extends StatelessWidget {
  /// Creates the record list screen.
  const RecordListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(title: '', onBack: () => Navigator.pop(context)),
          // 기록 / 보관 tabs (기록 active).
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            child: SegmentedTabs(
              labels: const ['기록', '보관'],
              activeIndex: 0,
              onChanged: (i) {
                if (i == 1) {
                  Navigator.pushReplacementNamed(
                      context, Routes.recordsArchive);
                }
              },
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              children: [
                Text('통화 기록',
                    style: AppType.body1.sb
                        .copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                for (var i = 0; i < _records.length; i++) ...[
                  if (i > 0) const SizedBox(height: 12),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => Navigator.pushNamed(context, Routes.analysis),
                    child: CardBox(
                      type: CardBoxType.record,
                      avatar: CircleAvatar(
                        backgroundImage: _records[i].title == 'Judi'
                            ? judiImage
                            : beaverImage,
                      ),
                      title: _records[i].title,
                      subtitle: _records[i].subtitle,
                      meta: [_records[i].date, _records[i].duration],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
