import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../di/providers.dart';
import 'locale_controller.dart';

/// 서버 한국어 오류 문구 → 회원 언어(2026-10-16 PM-DEC-673·674 보완).
///
/// 서버(앱 서버 45 · b2b 18)는 `detail.message`·WS `error.message` 를 한국어 한 벌로 보낸다. 응답 형식을
/// 바꾸면 옛 앱이 깨질 수 있어, 서버가 사전(`GET /i18n/server-messages?locale=`)을 내주고 앱이 바꿔 보인다.
///  · 정확 일치 → 번역. `{0}`·`{1}` 자리표시 틀은 원문 전체가 틀과 맞을 때만 바꾸고 자리값은 그대로 옮긴다.
///  · 맞지 않거나 사전을 못 받았으면 **원문 그대로**(지금과 같음). 받기 실패는 앱 시작·오류 표시를 막지 않는다.
class ServerMessages {
  ServerMessages._();

  static String? _locale;
  static Map<String, String> _exact = const {};
  static List<_Template> _templates = const [];

  /// 지금 사전의 언어(없으면 null). 시험·로그용.
  static String? get locale => _locale;

  /// [message] 의 회원 언어 표시값. 사전에 없으면 [message] 그대로.
  static String localize(String message) {
    if (_exact.isEmpty && _templates.isEmpty) return message;
    final key = message.trim();
    final hit = _exact[key];
    if (hit != null) return hit;
    for (final t in _templates) {
      final out = t.apply(key);
      if (out != null) return out;
    }
    return message;
  }

  /// `GET /i18n/server-messages` 응답 본문을 사전으로 올린다. ko·모르는 언어는 번역 = 원문이라 비운다.
  @visibleForTesting
  static void applyBundle(Map<String, dynamic> body) {
    final exact = <String, String>{};
    final templates = <_Template>[];
    final messages = body['messages'];
    if (messages is List) {
      for (final m in messages) {
        if (m is! Map) continue;
        final ko = m['ko'], text = m['text'];
        if (ko is! String || text is! String || ko.isEmpty || text.isEmpty || ko == text) continue;
        if (_Template.hasSlots(ko)) {
          final t = _Template.tryParse(ko, text);
          if (t != null) templates.add(t);
        } else {
          exact[ko.trim()] = text;
        }
      }
    }
    _locale = body['locale'] is String ? body['locale'] as String : null;
    _exact = exact;
    _templates = templates;
  }

  /// 사전을 비운다(언어 ko · 시험).
  @visibleForTesting
  static void clear() {
    _locale = null;
    _exact = const {};
    _templates = const [];
  }

  /// [languageCode] 사전을 받아 올린다. 실패하면 이전 사전을 버리고 원문 표시로 둔다(다른 언어가 섞이지 않게).
  static Future<void> load(Dio dio, String languageCode) async {
    if (languageCode == 'ko') {
      clear();
      return;
    }
    if (_locale == languageCode) return;
    try {
      final res = await dio.get<Map<String, dynamic>>(
        '/i18n/server-messages',
        queryParameters: {'locale': languageCode},
      );
      final body = res.data;
      if (body == null) throw StateError('빈 응답');
      applyBundle(body);
      debugPrint('[server-messages] $languageCode 사전 ${_exact.length + _templates.length}문구');
    } catch (e) {
      clear();
      debugPrint('[server-messages] $languageCode 사전 받기 실패 — 서버 원문 표시: $e');
    }
  }
}

/// 앱 언어가 정해지거나 바뀔 때 사전을 받는다. 루트 위젯이 watch 한다(값 없음 · 결과를 기다리지 않음).
final serverMessagesSyncProvider = Provider<void>((ref) {
  final code = ref.watch(localeControllerProvider).languageCode;
  final Dio dio;
  try {
    dio = ref.read(dioProvider);
  } catch (e) {
    // 설정(.env) 없이 뜬 화면(시험·미리보기) — 사전 없이 원문 표시. 앱 시작을 막지 않는다.
    debugPrint('[server-messages] 클라이언트 없음 — 건너뜀: $e');
    return;
  }
  unawaited(ServerMessages.load(dio, code));
});

/// `{0}` 자리표시가 든 원문 틀 하나.
class _Template {
  _Template(this._pattern, this._text, this._order);

  final RegExp _pattern;
  final String _text;

  /// 정규식 n번째 묶음이 원문의 몇 번 자리표시인가(`{1}` 이 먼저 나올 수도 있다).
  final List<int> _order;

  static final _slot = RegExp(r'\{(\d+)\}');

  static bool hasSlots(String s) => _slot.hasMatch(s);

  static _Template? tryParse(String ko, String text) {
    final buf = StringBuffer('^');
    var last = 0;
    final order = <int>[];
    for (final m in _slot.allMatches(ko)) {
      buf.write(RegExp.escape(ko.substring(last, m.start)));
      buf.write('(.+?)');
      order.add(int.parse(m.group(1)!));
      last = m.end;
    }
    buf.write(RegExp.escape(ko.substring(last)));
    buf.write(r'$');
    // 번역문에 원문에 없는 자리표시가 있으면 쓰지 않는다(값을 못 채운다).
    final need = _slot.allMatches(text).map((m) => int.parse(m.group(1)!)).toSet();
    if (!need.every(order.contains)) return null;
    return _Template(RegExp(buf.toString(), dotAll: true), text, order);
  }

  String? apply(String message) {
    final m = _pattern.firstMatch(message);
    if (m == null) return null;
    final values = <int, String>{
      for (var i = 0; i < _order.length; i++) _order[i]: m.group(i + 1)!,
    };
    return _text.replaceAllMapped(_slot, (s) => values[int.parse(s.group(1)!)] ?? s.group(0)!);
  }
}
