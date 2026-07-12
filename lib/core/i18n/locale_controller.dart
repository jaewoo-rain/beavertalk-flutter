import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App UI locale, driven by the user's selected native language.
///
/// The picker (onboarding / mypage) calls [LocaleController.setLanguage] with a
/// BCP 47 code (`mockLanguages` id, e.g. `ja`, `ko-KR`, `es`). We persist it and
/// expose it as [Locale] to `MaterialApp.locale`. gen-l10n then renders the
/// matching `app_<code>.arb`; any locale without an ARB (or an ARB missing a
/// key) falls back to the English template automatically, so selecting an
/// untranslated language is safe — the UI just stays English.
class LocaleController extends Notifier<Locale> {
  static const _prefKey = 'ui_locale';

  /// True once the user has explicitly picked a language this session, so a
  /// late-resolving [_hydrate] can't overwrite a fresh selection with the stale
  /// persisted value.
  bool _userSet = false;

  @override
  Locale build() {
    // Default to English immediately; hydrate the persisted choice async.
    unawaited(_hydrate());
    return const Locale('en');
  }

  Future<void> _hydrate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_prefKey);
      // If the user picked a language while this async read was in flight, don't
      // clobber their choice.
      if (_userSet) return;
      if (code != null && code.isNotEmpty) state = localeFromCode(code);
    } catch (_) {
      // Prefs unavailable → keep the default; not fatal.
    }
  }

  /// Switches the UI to [bcp47] (a `mockLanguages` id) and persists it.
  Future<void> setLanguage(String bcp47) async {
    _userSet = true;
    final next = localeFromCode(bcp47);
    if (next == state) return;
    state = next;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, bcp47);
    } catch (_) {}
  }

  /// Parses a BCP 47 id into a [Locale]: `ko-KR` → `Locale('ko','KR')`,
  /// `ja` → `Locale('ja')`. Only language + region are used.
  static Locale localeFromCode(String bcp47) {
    final parts = bcp47.split(RegExp('[-_]'));
    if (parts.length >= 2 && parts[1].isNotEmpty) {
      return Locale(parts[0], parts[1]);
    }
    return Locale(parts[0]);
  }
}

/// The active UI [Locale]. Bind to `MaterialApp.locale`.
final localeControllerProvider =
    NotifierProvider<LocaleController, Locale>(LocaleController.new);
