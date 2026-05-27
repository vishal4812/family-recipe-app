import 'package:flutter/material.dart';

import '../../../core/di/app_dependencies_scope.dart';
import '../../../core/navigation/route_names.dart';
import '../../../core/state/app_state_scope.dart';
import 'screens/splash_auth_check_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _scheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_scheduled) {
      return;
    }
    _scheduled = true;
    final appState = AppStateScope.read(context);
    final splashDelay = AppDependenciesScope.read(context).splashDelay;

    Future<void>(() async {
      await Future.wait<void>(<Future<void>>[
        Future<void>.delayed(splashDelay),
        appState.waitUntilReady(),
      ]);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacementNamed(
        appState.isAuthenticated ? RouteNames.home : RouteNames.auth,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashAuthCheckScreen();
  }
}
