import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The language the user is currently **learning** — sent to the call socket as
/// `target_language` in the `{type:"start"}` message.
///
/// Stored as the server's `target_language` **code** (ISO 639-1: `ko`/`ja`/…),
/// which is NOT always the same as a `mockLanguages` id (Korean is `ko-KR`
/// there but `ko` on the server). The mypage picker sets it; the normalcall
/// controller reads it at call start. Persisted via SharedPreferences (same
/// pattern as [LocaleController]) so the choice survives restarts.
class LearningLanguageController extends Notifier<String> {
  static const _prefKey = 'learning_language';

  /// Default learning target. The app originally teaches Korean; the dogfooding
  /// build lets the user switch to Japanese (등 시드된 언어) via the picker.
  static const defaultCode = 'ko';

  /// True once the user picked this session, so a late [_hydrate] can't clobber
  /// a fresh choice with the stale persisted value.
  bool _userSet = false;

  @override
  String build() {
    unawaited(_hydrate());
    return defaultCode;
  }

  Future<void> _hydrate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_prefKey);
      if (_userSet) return;
      if (code != null && code.isNotEmpty) state = code;
    } catch (_) {
      // Prefs unavailable → keep the default; not fatal.
    }
  }

  /// Switches the learning target to [code] (server target_language) and persists it.
  Future<void> setLanguage(String code) async {
    _userSet = true;
    if (code == state) return;
    state = code;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, code);
    } catch (_) {}
  }
}

/// The active learning-language code (server `target_language`). Read at call
/// start; watched by the mypage row.
final learningLanguageProvider =
    NotifierProvider<LearningLanguageController, String>(
        LearningLanguageController.new);
