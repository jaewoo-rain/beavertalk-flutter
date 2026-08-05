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

  group('Env.apiBaseUrl without .env', () {
    test('uses the platform fallback when dotenv is unloaded', () {
      // tearDown reset dotenv; maybeGet must be safe and return null.
      expect(Env.apiBaseUrl, 'http://localhost:8000/api/v1');
    });
  });
}
