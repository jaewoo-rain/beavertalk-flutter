// Verifies multi-select reasons in the signup draft.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/auth/presentation/providers/signup_draft_provider.dart';

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  SignupDraftNotifier notifier() =>
      container.read(signupDraftProvider.notifier);
  SignupDraft draft() => container.read(signupDraftProvider);

  group('toggleReason (multi-select)', () {
    test('reasons is null when nothing is selected', () {
      expect(draft().reasons, isNull);
    });

    test('toggling adds, toggling again removes', () {
      notifier().toggleReason('travel');
      expect(draft().selectedReasonIds, {'travel'});

      notifier().toggleReason('travel');
      expect(draft().selectedReasonIds, isEmpty);
      expect(draft().reasons, isNull);
    });

    test('multiple reasons accumulate into the body list', () {
      notifier()
        ..toggleReason('travel')
        ..toggleReason('career')
        ..toggleReason('exam');

      final reasons = draft().reasons;
      expect(reasons, isNotNull);
      expect(reasons!.toSet(), {'travel', 'career', 'exam'});
    });

    test('language and name are preserved across reason toggles', () {
      notifier()
        ..setLanguage('en')
        ..setName('Jae')
        ..toggleReason('travel');

      expect(draft().language, 'en');
      expect(draft().name, 'Jae');
      expect(draft().reasons, ['travel']);
    });
  });
}
