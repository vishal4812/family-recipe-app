import '../../../profile/domain/models/app_user.dart';

class AppUserDto {
  const AppUserDto({required this.name, required this.email, this.id});

  final String name;
  final String email;
  final String? id;

  factory AppUserDto.fromJson(Map<String, dynamic> json) {
    final rawName = (json['name'] as String?)?.trim() ?? '';
    return AppUserDto(
      id: json['id'] as String?,
      name: rawName.isEmpty ? 'Family Cook' : rawName,
      email: (json['email'] as String?) ?? '',
    );
  }

  factory AppUserDto.fromDomain(AppUser user) {
    return AppUserDto(name: user.name, email: user.email);
  }

  AppUser toDomain() {
    return AppUser(name: name, email: email);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'name': name, 'email': email};
  }
}
