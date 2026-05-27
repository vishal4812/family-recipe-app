import '../../../profile/domain/models/app_user.dart';
import '../repositories/auth_repository.dart';

class AuthService {
  const AuthService(this._authRepository);

  final AuthRepository _authRepository;

  Future<AppUser?> restoreSession() {
    return _authRepository.restoreSession();
  }

  Future<AppUser> signIn({required String email, required String password}) {
    return _authRepository.signIn(email: email, password: password);
  }

  Future<AppUser> signUp({
    required String email,
    required String password,
    String? fullName,
  }) {
    return _authRepository.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );
  }

  Future<void> signOut() {
    return _authRepository.signOut();
  }
}
