import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Cross-screen onboarding draft: the language, name, and learning reasons
/// collected during the onboarding flow. Read by `submitOnboarding()`.
class SignupDraft {
  const SignupDraft({
    this.language,
    this.name,
    this.selectedReasonIds = const {},
  });

  /// Native language code from onboarding (e.g. `en`), or null.
  final String? language;

  /// Nickname entered during onboarding, or null.
  final String? name;

  /// Selected learning reason ids (e.g. `{travel, career}`). Multi-select.
  final Set<String> selectedReasonIds;

  /// Reasons list for the onboarding body, or null when none are selected.
  List<String>? get reasons =>
      selectedReasonIds.isEmpty ? null : selectedReasonIds.toList();

  SignupDraft copyWith({
    String? language,
    String? name,
    Set<String>? selectedReasonIds,
  }) {
    return SignupDraft(
      language: language ?? this.language,
      name: name ?? this.name,
      selectedReasonIds: selectedReasonIds ?? this.selectedReasonIds,
    );
  }
}

/// Holds the [SignupDraft] across the onboarding flow.
final signupDraftProvider =
    NotifierProvider<SignupDraftNotifier, SignupDraft>(SignupDraftNotifier.new);

class SignupDraftNotifier extends Notifier<SignupDraft> {
  @override
  SignupDraft build() => const SignupDraft();

  /// Stores the native language picked during onboarding.
  void setLanguage(String language) =>
      state = state.copyWith(language: language);

  /// Stores the nickname entered during onboarding.
  void setName(String name) => state = state.copyWith(name: name);

  /// Toggles a learning reason: removes it when present, adds it otherwise.
  void toggleReason(String reasonId) {
    final next = {...state.selectedReasonIds};
    if (!next.remove(reasonId)) next.add(reasonId);
    state = state.copyWith(selectedReasonIds: next);
  }
}
