import 'package:flutter/foundation.dart';

@immutable
class AppUser {
  const AppUser({required this.name, required this.email});

  final String name;
  final String email;

  AppUser copyWith({String? name, String? email}) {
    return AppUser(name: name ?? this.name, email: email ?? this.email);
  }
}
