import 'package:beavertalk/components/atoms/badge.dart';
import 'package:beavertalk/components/molecules/banner.dart' as bt;
import 'package:beavertalk/components/molecules/benefit_row.dart';
import 'package:beavertalk/components/molecules/bullet_row.dart';
import 'package:beavertalk/components/molecules/plan_row.dart';
import 'package:beavertalk/components/organisms/bottom_sheet.dart'
    show SheetAction;
import 'package:beavertalk/components/organisms/bottom_sheet_content.dart';
import 'package:beavertalk/theme/app_color_tokens.dart';
import 'package:flutter/material.dart' hide Badge, Banner, BottomSheet;
import 'package:flutter_test/flutter_test.dart';

/// P1 — the six subscription components, every variant (work order §4-2).
///
/// Mounted on a bare [MaterialApp], so `context.c` resolves to the Dark token
/// set (the documented fallback) and colour assertions below are against
/// [AppColorTokens.dark].
void main() {
  const c = AppColorTokens.dark;

  Widget host(Widget child) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(width: 375, child: child),
          ),
        ),
      );

  /// The fill colour of the first [Container] descendant carrying a
  /// [BoxDecoration] with a non-null color.
  Color? faceOf(WidgetTester tester, Finder root) {
    for (final w in tester.widgetList(find.descendant(
      of: root,
      matching: find.byType(Container),
      matchRoot: true,
    ))) {
      final d = (w as Container).decoration;
      if (d is BoxDecoration && d.color != null) return d.color;
    }
    return null;
  }

  group('Badge — six tones (4204:551)', () {
    const cases = {
      BadgeTone.neutral: (null, null),
      BadgeTone.brand: (null, null),
      BadgeTone.gold: (null, null),
      BadgeTone.goldSubtle: (null, null),
      BadgeTone.positive: (null, null),
      BadgeTone.negative: (null, null),
    };

    testWidgets('every tone renders its face/label pair', (tester) async {
      final expected = {
        BadgeTone.neutral: (c.backgroundElevatedNormal, c.labelNormal),
        BadgeTone.brand: (c.primaryNormal14, c.primaryNormal),
        BadgeTone.gold: (c.statusCautionary, c.staticBlack),
        BadgeTone.goldSubtle:
            (c.statusCautionarySurface, c.accentForegroundOrange),
        BadgeTone.positive: (c.statusPositive4, c.accentForegroundGreen),
        BadgeTone.negative: (c.statusNegative6, c.accentForegroundRed),
      };
      for (final tone in cases.keys) {
        await tester.pumpWidget(host(Badge(tone: tone, label: 'Trial')));
        final (bg, fg) = expected[tone]!;
        expect(faceOf(tester, find.byType(Badge)), bg, reason: '$tone face');
        final text = tester.widget<Text>(find.text('Trial'));
        expect(text.style?.color, fg, reason: '$tone label');
        // Noto Sans KR Bold maps to Pretendard SemiBold (work order §1-1).
        expect(text.style?.fontWeight, FontWeight.w600, reason: '$tone weight');
      }
    });

    testWidgets('positive label is the foreground green, not Status/Positive',
        (tester) async {
      // Same value in Dark; the token identity is what §1-2 protects — in
      // Light Status/Positive fails 1.82:1 as text.
      await tester.pumpWidget(
          host(const Badge(tone: BadgeTone.positive, label: 'Done')));
      final text = tester.widget<Text>(find.text('Done'));
      expect(text.style?.color, c.accentForegroundGreen);
    });
  });

  group('BulletRow — three dot tones (4204:577)', () {
    testWidgets('dot colour follows the tone', (tester) async {
      final expected = {
        BulletTone.free: c.labelNeutral,
        BulletTone.pro: c.primaryNormal,
        BulletTone.max: c.statusCautionary,
      };
      for (final tone in BulletTone.values) {
        await tester.pumpWidget(host(BulletRow(tone: tone, label: 'line')));
        final dot = tester
            .widgetList<Container>(find.byType(Container))
            .map((w) => w.decoration)
            .whereType<BoxDecoration>()
            .firstWhere((d) => d.shape == BoxShape.circle);
        expect(dot.color, expected[tone], reason: '$tone dot');
      }
    });
  });

  group('BenefitRow — two tiers (4204:563)', () {
    testWidgets('renders label and a check per tier', (tester) async {
      for (final tier in BenefitTier.values) {
        await tester.pumpWidget(
            host(BenefitRow(tier: tier, label: 'Unlimited calls')));
        expect(find.text('Unlimited calls'), findsOneWidget);
      }
    });
  });

  group('PlanRow — tier × state (4206:588)', () {
    testWidgets('selected pro wears the mint face and border', (tester) async {
      await tester.pumpWidget(host(const PlanRow(
        tier: PlanRowTier.pro,
        selected: true,
        title: 'Monthly',
        price: r'$15.99 per month',
      )));
      final box = tester
          .widgetList<Container>(find.byType(Container))
          .map((w) => w.decoration)
          .whereType<BoxDecoration>()
          .firstWhere((d) => d.border != null);
      expect(box.color, c.primaryNormal10);
      expect((box.border as Border).top.color, c.primaryNormal);
      expect((box.border as Border).top.width, 1.5);
    });

    testWidgets('selected max wears gold', (tester) async {
      await tester.pumpWidget(host(const PlanRow(
        tier: PlanRowTier.max,
        selected: true,
        title: 'Yearly',
        price: r'$188.99 per year',
      )));
      final box = tester
          .widgetList<Container>(find.byType(Container))
          .map((w) => w.decoration)
          .whereType<BoxDecoration>()
          .firstWhere((d) => d.border != null);
      expect(box.color, c.statusCautionarySurface);
      expect((box.border as Border).top.color, c.statusCautionary);
    });

    testWidgets('unselected rows are flat with a ring radio', (tester) async {
      for (final tier in PlanRowTier.values) {
        await tester.pumpWidget(host(PlanRow(
          tier: tier,
          selected: false,
          title: 'Monthly',
          price: r'$15.99 per month',
        )));
        expect(faceOf(tester, find.byType(PlanRow)),
            c.backgroundSurfaceAlternative,
            reason: '$tier unselected face');
        final ring = tester
            .widgetList<Container>(find.byType(Container))
            .map((w) => w.decoration)
            .whereType<BoxDecoration>()
            .firstWhere((d) => d.shape == BoxShape.circle);
        expect((ring.border as Border).top.color, c.lineNormal,
            reason: '$tier ring');
      }
    });

    testWidgets('the struck anchor price keeps body colour (§6-4)',
        (tester) async {
      await tester.pumpWidget(host(const PlanRow(
        tier: PlanRowTier.pro,
        selected: true,
        title: 'Yearly',
        price: r'$117.99 · $9.83 per month',
        priceOriginal: r'$191.88',
      )));
      final rich = tester.widget<Text>(find.byWidgetPredicate(
          (w) => w is Text && w.textSpan != null));
      final spans = (rich.textSpan! as TextSpan).children!;
      final anchor = spans.first as TextSpan;
      expect(anchor.style?.decoration, TextDecoration.lineThrough);
      expect(anchor.style?.color, c.labelNormal,
          reason: 'strikethrough segment stays body-coloured');
    });

    testWidgets('tap reports selection, nothing more', (tester) async {
      var taps = 0;
      await tester.pumpWidget(host(PlanRow(
        tier: PlanRowTier.pro,
        selected: false,
        title: 'Monthly',
        price: r'$15.99 per month',
        onTap: () => taps++,
      )));
      await tester.tap(find.byType(PlanRow));
      expect(taps, 1);
    });
  });

  group('Banner — four tones (4206:622)', () {
    testWidgets('face, border and foreground follow the tone', (tester) async {
      final expected = {
        bt.BannerTone.gold: (
          c.statusCautionarySurface,
          c.statusCautionary,
          c.accentForegroundOrange
        ),
        bt.BannerTone.danger:
            (c.statusNegative6, c.statusNegative, c.accentForegroundRed),
        bt.BannerTone.brand:
            (c.primaryNormal10, c.primaryNormal, c.primaryNormal),
        bt.BannerTone.neutral:
            (c.backgroundSurfaceAlternative, c.lineNormal, c.labelNormal),
      };
      for (final tone in bt.BannerTone.values) {
        await tester.pumpWidget(host(bt.Banner(
          tone: tone,
          title: 'Banner title',
          sub: 'Supporting line',
        )));
        final (face, border, fg) = expected[tone]!;
        final box = tester
            .widgetList<Container>(find.byType(Container))
            .map((w) => w.decoration)
            .whereType<BoxDecoration>()
            .firstWhere((d) => d.border != null);
        expect(box.color, face, reason: '$tone face');
        expect((box.border as Border).top.color, border, reason: '$tone edge');
        final sub = tester.widget<Text>(find.text('Supporting line'));
        expect(sub.style?.color, fg, reason: '$tone sub');
      }
    });

    testWidgets('the non-interactive banner hides its chevron (§8-1)',
        (tester) async {
      await tester.pumpWidget(host(const bt.Banner(
        tone: bt.BannerTone.gold,
        title: "That was today's call",
        sub: 'Free gives you one call a day',
        showChevron: false,
      )));
      // The chevron is the only SvgPicture the banner ever mounts.
      expect(find.byWidgetPredicate((w) => w.runtimeType.toString() == 'SvgPicture'),
          findsNothing);
      expect(find.byType(GestureDetector), findsNothing);
    });

    testWidgets('an interactive banner taps through', (tester) async {
      var taps = 0;
      await tester.pumpWidget(host(bt.Banner(
        tone: bt.BannerTone.brand,
        title: 'Go beyond the daily limit',
        sub: 'Pro removes the cap',
        onTap: () => taps++,
      )));
      await tester.tap(find.byType(bt.Banner));
      expect(taps, 1);
    });
  });

  group('BottomSheetContent — five types (4399:2039)', () {
    Widget sheet({
      SheetContentType type = SheetContentType.none,
      SheetMarkTone? mark,
      String? benefitLabel,
      String? caption,
      SheetAction? secondary,
    }) =>
        host(SingleChildScrollView(
          child: BottomSheetContent(
            type: type,
            title: 'Title',
            body: 'Body',
            mark: mark,
            rows: const [
              SheetRowData(label: 'Pronunciation', value: '96', highlighted: true),
              SheetRowData(label: 'Fluency', value: '91'),
              SheetRowData(label: 'Rhythm', value: '91'),
            ],
            preview: const SheetPreviewData(
              avatar: ColoredBox(color: Color(0xFF444444)),
              name: 'Baba',
              topic: 'You were talking about weekend plans',
              usage: '4:58 of 5:00 used',
            ),
            streakDays: const [
              SheetStreakDay(label: 'Mon'),
              SheetStreakDay(label: 'Tue'),
              SheetStreakDay(label: 'Wed', done: false),
            ],
            streakNote: "You're using it every day. The cap isn't.",
            videoPrice: r'$23.99 per month',
            videoPriceOriginal: r'$29.99',
            benefitLabel: benefitLabel,
            caption: caption,
            primaryAction: SheetAction(label: 'Go unlimited', onPressed: () {}),
            secondaryAction: secondary,
          ),
        ));

    testWidgets('every type renders its header and primary CTA',
        (tester) async {
      for (final type in SheetContentType.values) {
        await tester.pumpWidget(sheet(type: type));
        expect(find.text('Title'), findsOneWidget, reason: '$type title');
        expect(find.text('Go unlimited'), findsOneWidget, reason: '$type CTA');
      }
    });

    testWidgets('rows card: values render, last row has no divider',
        (tester) async {
      await tester.pumpWidget(sheet(type: SheetContentType.rows));
      expect(find.text('Pronunciation'), findsOneWidget);
      expect(find.text('96'), findsOneWidget);
      // Highlighted value is mint.
      expect(tester.widget<Text>(find.text('96')).style?.color,
          c.primaryNormal);
      // '91' appears on two rows; either one carries the quiet colour.
      expect(tester.widget<Text>(find.text('91').first).style?.color,
          c.labelNormal);
      // 3 rows → exactly 2 bottom borders.
      final divided = tester
          .widgetList<Container>(find.byType(Container))
          .map((w) => w.decoration)
          .whereType<BoxDecoration>()
          .where((d) => d.border is Border && (d.border as Border).bottom.width == 0.5);
      expect(divided.length, 2, reason: 'last row draws no divider (§5-6)');
    });

    testWidgets('preview and streak cards carry their payloads',
        (tester) async {
      await tester.pumpWidget(sheet(type: SheetContentType.preview));
      expect(find.text('Baba'), findsOneWidget);
      expect(find.text('4:58 of 5:00 used'), findsOneWidget);

      await tester.pumpWidget(sheet(type: SheetContentType.streak));
      expect(find.text('Mon'), findsOneWidget);
      expect(find.text("You're using it every day. The cap isn't."),
          findsOneWidget);
    });

    testWidgets('video price keeps the struck anchor in body colour',
        (tester) async {
      await tester.pumpWidget(sheet(type: SheetContentType.video));
      final rich = tester.widget<Text>(
          find.byWidgetPredicate((w) => w is Text && w.textSpan != null));
      final anchor = ((rich.textSpan! as TextSpan).children!.first) as TextSpan;
      expect(anchor.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('mark, benefit and caption toggle independently',
        (tester) async {
      await tester.pumpWidget(sheet(
        mark: SheetMarkTone.success,
        benefitLabel: 'Unlimited calls with Pro · 15 minutes each',
        caption: r'$15.99 per month · cancel anytime',
      ));
      expect(find.byType(BenefitRow), findsOneWidget);
      expect(find.text(r'$15.99 per month · cancel anytime'), findsOneWidget);

      await tester.pumpWidget(sheet());
      expect(find.byType(BenefitRow), findsNothing);
      expect(find.text(r'$15.99 per month · cancel anytime'), findsNothing);
    });

    testWidgets('secondary CTA renders below the primary when present',
        (tester) async {
      await tester.pumpWidget(
          sheet(secondary: SheetAction(label: 'Not now', onPressed: () {})));
      final primary = tester.getTopLeft(find.text('Go unlimited'));
      final secondary = tester.getTopLeft(find.text('Not now'));
      expect(secondary.dy, greaterThan(primary.dy),
          reason: 'primary on top — the reverse of the legacy BottomSheet');
    });
  });
}
