import 'auth_token_store.dart';

class MemoryAuthTokenStore implements AuthTokenStore {
  MemoryAuthTokenStore({String? initialToken}) : _token = initialToken;

  String? _token;

  @override
  Future<void> clearToken() async {
    _token = null;
  }

  @override
  Future<String?> readToken() async => _token;

  @override
  Future<void> writeToken(String token) async {
    _token = token;
  }
}
