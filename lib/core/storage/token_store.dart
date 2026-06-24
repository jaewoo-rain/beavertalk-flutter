import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the JWT access token in platform-secure storage
/// (Keychain on iOS, EncryptedSharedPreferences on Android).
class TokenStore {
  TokenStore([FlutterSecureStorage? storage])
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  final FlutterSecureStorage _storage;

  static const _key = 'bt_access_token';

  /// Saves the access token.
  Future<void> save(String token) =>
      _storage.write(key: _key, value: token);

  /// Reads the stored token, or `null` if none.
  Future<String?> read() => _storage.read(key: _key);

  /// Removes the stored token (logout / session expiry).
  Future<void> clear() => _storage.delete(key: _key);
}
