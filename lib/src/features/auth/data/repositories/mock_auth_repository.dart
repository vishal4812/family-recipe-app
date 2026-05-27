import '../../../profile/domain/models/app_user.dart';
import '../dtos/app_user_dto.dart';
import '../../domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  MockAuthRepository({
    this.responseDelay = const Duration(milliseconds: 450),
    AppUser? initialSignedInUser,
  }) : _signedInUser = initialSignedInUser == null
           ? null
           : AppUserDto.fromDomain(initialSignedInUser);

  final Duration responseDelay;
  AppUserDto? _signedInUser;

  @override
  Future<AppUser?> restoreSession() async {
    await Future<void>.delayed(responseDelay);
    return _signedInUser?.toDomain();
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(responseDelay);
    _signedInUser = AppUserDto(
      name: _signedInUser?.name ?? 'Priya Sharma',
      email: email.trim(),
    );
    return _signedInUser!.toDomain();
  }

  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    await Future<void>.delayed(responseDelay);
    _signedInUser = AppUserDto(
      name: (fullName ?? '').trim().isEmpty ? 'Family Cook' : fullName!.trim(),
      email: email.trim(),
    );
    return _signedInUser!.toDomain();
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(responseDelay);
    _signedInUser = null;
  }
}
