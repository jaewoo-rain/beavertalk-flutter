import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef TestServerOption = ({String name, String url});

/// 시험 빌드 전용 서버 선택(PM-DEC-875).
///
/// `.env` 에 `TEST_SERVERS=이름|URL;이름|URL` 이 있을 때만 켜진다 — 운영 빌드 `.env` 에는
/// 이 키가 없어 [options] 가 비고, 앱은 지금과 똑같이 뜬다.
/// 고른 URL 은 `API_BASE_URL` 자리에 덮어쓴다. dio·WS 주소가 만들어지기 전(앱 시작)에만 고르므로
/// 서버를 바꾸려면 앱을 껐다 켠다.
abstract final class TestServer {
  static const _prefKey = 'test_server_name';

  /// 고른 서버 이름. 시험 빌드가 아니면 null — 통화 화면 표시도 이걸로 가린다.
  static String? name;

  static List<TestServerOption> options() {
    if (!dotenv.isInitialized) return const [];
    final raw = dotenv.maybeGet('TEST_SERVERS')?.trim() ?? '';
    if (raw.isEmpty) return const [];
    return [
      for (final part in raw.split(';'))
        if (part.contains('|'))
          (
            name: part.substring(0, part.indexOf('|')).trim(),
            url: part.substring(part.indexOf('|') + 1).trim(),
          ),
    ];
  }

  /// 선택 화면을 띄우고 고를 때까지 기다린다. 고른 값을 `API_BASE_URL` 에 덮는다.
  static Future<void> pick(List<TestServerOption> servers) async {
    final prefs = await SharedPreferences.getInstance();
    final chosen = Completer<TestServerOption>();
    runApp(_PickerApp(
      servers: servers,
      last: prefs.getString(_prefKey),
      onPick: (s) {
        if (!chosen.isCompleted) chosen.complete(s);
      },
    ));
    final s = await chosen.future;
    await prefs.setString(_prefKey, s.name);
    dotenv.env['API_BASE_URL'] = s.url;
    name = s.name;
  }
}

class _PickerApp extends StatelessWidget {
  const _PickerApp({required this.servers, required this.last, required this.onPick});

  final List<TestServerOption> servers;
  final String? last;
  final void Function(TestServerOption) onPick;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('시험 서버 선택', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                const Text('바꾸려면 앱을 완전히 껐다 다시 켠다.', style: TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 24),
                for (final s in servers) ...[
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      backgroundColor: s.name == last ? null : Colors.blueGrey,
                    ),
                    onPressed: () => onPick(s),
                    child: Text(s.name == last ? '${s.name}  (지난번)' : s.name, style: const TextStyle(fontSize: 17)),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
