// Verifies Env.apiBaseUrl scheme-normalization and .env priority.

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/core/network/env.dart';

void main() {
  tearDown(() {
    // Reset dotenv between tests so one case doesn't leak into the next.
    dotenv.clean();
  });

  group('Env.apiBaseUrl with .env', () {
    test('adds http:// scheme to a bare host:port and appends /api/v1', () {
      dotenv.testLoad(fileInput: 'API_BASE_URL=175.123.55.182:8000');
      expect(Env.apiBaseUrl, 'http://175.123.55.182:8000/api/v1');
    });

    test('keeps an explicit https scheme', () {
      dotenv.testLoad(fileInput: 'API_BASE_URL=https://api.example.com');
      expect(Env.apiBaseUrl, 'https://api.example.com/api/v1');
    });

    test('trims a trailing slash before appending the prefix', () {
      dotenv.testLoad(fileInput: 'API_BASE_URL=http://localhost:8000/');
      expect(Env.apiBaseUrl, 'http://localhost:8000/api/v1');
    });

    test('blank .env value falls through to the platform fallback', () {
      dotenv.testLoad(fileInput: 'API_BASE_URL=');
      // No dart-define in tests → platform fallback (localhost on the VM).
      expect(Env.apiBaseUrl, 'http://localhost:8000/api/v1');
    });
  });

  group('Env.apiBaseUrl without API_BASE_URL', () {
    test('uses the platform fallback when .env has no API_BASE_URL', () {
      // 적재는 됐지만 키가 없는 상태를 직접 만든다. 예전엔 「미적재」를 기대했는데,
      // `dotenv.maybeGet` 은 load() 전이면 NotInitializedError 를 던진다(env.dart 주석 —
      // 위젯 시험의 네트워크 차단막이라 의도적으로 둔 동작). 그래서 이 시험은 같은 파일의
      // 앞 시험이 한 번 적재해 둔 순서에서만 통과했고, 분할이 바뀌어 혼자 돌면 실패했다
      // (D13 · 6분할 실측). 앞 시험에 기대지 않게 자기 상태를 스스로 만든다.
      //
      // ⚠ `dotenv.clean()` 은 「적재 안 됨」 으로 되돌리지 않는다(값만 비운다) — 예외는 그 시험
      //   격리(isolate)에서 **한 번도** 적재하지 않았을 때만 난다. 순서에 따라 결과가 갈린 이유가
      //   이것이고, 그래서 「미적재」 자체는 시험으로 고정할 수 없다.
      dotenv.testLoad(fileInput: 'OTHER_KEY=1');
      expect(Env.apiBaseUrl, 'http://localhost:8000/api/v1');
    });
  });
}
