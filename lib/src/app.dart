import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/config/app_config.dart';
import 'core/di/app_dependencies.dart';
import 'core/di/app_dependencies_scope.dart';
import 'core/navigation/app_router.dart';
import 'core/navigation/route_names.dart';
import 'core/state/app_state.dart';
import 'core/state/app_state_scope.dart';
import 'core/theme/app_theme.dart';

class FamilyRecipeApp extends StatefulWidget {
  const FamilyRecipeApp({super.key, this.dependencies});

  final AppDependencies? dependencies;

  @override
  State<FamilyRecipeApp> createState() => _FamilyRecipeAppState();
}

class _FamilyRecipeAppState extends State<FamilyRecipeApp> {
  late final AppDependencies _dependencies;
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _dependencies =
        widget.dependencies ??
        AppDependencies.api(baseUrl: AppConfig.apiBaseUrl);
    _appState = AppState(
      authService: _dependencies.authService,
      recipeService: _dependencies.recipeService,
    );
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDependenciesScope(
      dependencies: _dependencies,
      child: AppStateScope(
        notifier: _appState,
        child: MaterialApp(
          builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Color(0xFFFFF9F6),
              systemNavigationBarIconBrightness: Brightness.dark,
              systemNavigationBarDividerColor: Color(0xFFFFF9F6),
              systemNavigationBarContrastEnforced: false,
            ),
            child: child ?? const SizedBox.shrink(),
          ),
          title: 'Family Recipe App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          initialRoute: RouteNames.splash,
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
