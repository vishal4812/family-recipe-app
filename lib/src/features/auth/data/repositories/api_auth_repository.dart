import '../../../../core/auth/auth_token_store.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../../profile/domain/models/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../dtos/app_user_dto.dart';

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository({
    required ApiClient apiClient,
    required AuthTokenStore authTokenStore,
  }) : _apiClient = apiClient,
       _authTokenStore = authTokenStore;

  final ApiClient _apiClient;
  final AuthTokenStore _authTokenStore;

  @override
  Future<AppUser?> restoreSession() async {
    final token = await _authTokenStore.readToken();
    if ((token ?? '').trim().isEmpty) {
      return null;
    }

    try {
      final response = await _apiClient.get('/users/me');
      if (response is! Map<String, dynamic>) {
        return null;
      }
      return AppUserDto.fromJson(response).toDomain();
    } on ApiException catch (error) {
      if (error.statusCode == 401) {
        await _authTokenStore.clearToken();
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/auth/login',
      body: <String, dynamic>{'email': email, 'password': password},
    );
    if (response is! Map<String, dynamic>) {
      throw Exception('Login failed.');
    }

    final accessToken = (response['accessToken'] as String?)?.trim() ?? '';
    final user = response['user'];
    if (accessToken.isEmpty || user is! Map<String, dynamic>) {
      throw Exception('Login failed.');
    }

    await _authTokenStore.writeToken(accessToken);
    return AppUserDto.fromJson(user).toDomain();
  }

  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final response = await _apiClient.post(
      '/auth/signup',
      body: <String, dynamic>{
        'email': email,
        'password': password,
        'fullName': fullName,
      },
    );
    if (response is! Map<String, dynamic>) {
      throw Exception('Sign up failed.');
    }

    final accessToken = (response['accessToken'] as String?)?.trim() ?? '';
    final user = response['user'];
    if (accessToken.isEmpty || user is! Map<String, dynamic>) {
      throw Exception('Sign up failed.');
    }

    await _authTokenStore.writeToken(accessToken);
    return AppUserDto.fromJson(user).toDomain();
  }

  @override
  Future<void> signOut() async {
    await _authTokenStore.clearToken();
  }
}
