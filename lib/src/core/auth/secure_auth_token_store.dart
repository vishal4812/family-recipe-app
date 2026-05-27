import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_token_store.dart';

class SecureAuthTokenStore implements AuthTokenStore {
  SecureAuthTokenStore({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const String _tokenKey = 'family_recipe_app.jwt';

  final FlutterSecureStorage _secureStorage;
  String? _cachedToken;
  bool _didLoad = false;

  @override
  Future<void> clearToken() async {
    _cachedToken = null;
    _didLoad = true;
    await _secureStorage.delete(key: _tokenKey);
  }

  @override
  Future<String?> readToken() async {
    if (_didLoad) {
      return _cachedToken;
    }

    _cachedToken = await _secureStorage.read(key: _tokenKey);
    _didLoad = true;
    return _cachedToken;
  }

  @override
  Future<void> writeToken(String token) async {
    _cachedToken = token;
    _didLoad = true;
    await _secureStorage.write(key: _tokenKey, value: token);
  }
}
