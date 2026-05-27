import 'package:flutter/material.dart';

import '../../features/auth/presentation/auth_gate.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/profile/presentation/screens/profile_placeholder_screen.dart';
import '../../features/recipes/presentation/screens/add_recipe_screen.dart';
import '../../features/recipes/presentation/screens/edit_recipe_screen.dart';
import '../../features/recipes/presentation/screens/home_recipe_list_screen.dart';
import '../../features/recipes/presentation/screens/recipe_detail_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return _buildRoute(
          settings: settings,
          builder: (_) => const AuthGate(),
        );
      case RouteNames.auth:
        return _buildRoute(
          settings: settings,
          builder: (_) => const AuthScreen(),
        );
      case RouteNames.home:
        return _buildRoute(
          settings: settings,
          builder: (_) => const HomeRecipeListScreen(),
        );
      case RouteNames.addRecipe:
        return _buildRoute(
          settings: settings,
          builder: (_) => const AddRecipeScreen(),
        );
      case RouteNames.recipeDetail:
        final recipeId = settings.arguments as String?;
        return _buildRoute(
          settings: settings,
          builder: (_) => RecipeDetailScreen(recipeId: recipeId),
        );
      case RouteNames.editRecipe:
        final recipeId = settings.arguments as String?;
        return _buildRoute(
          settings: settings,
          builder: (_) => EditRecipeScreen(recipeId: recipeId),
        );
      case RouteNames.profile:
        return _buildRoute(
          settings: settings,
          builder: (_) => const ProfilePlaceholderScreen(),
        );
      default:
        return _buildRoute(
          settings: settings,
          builder: (_) => const _UnknownRouteScreen(),
        );
    }
  }

  static MaterialPageRoute<dynamic> _buildRoute({
    required RouteSettings settings,
    required WidgetBuilder builder,
  }) {
    return MaterialPageRoute<dynamic>(settings: settings, builder: builder);
  }
}

class _UnknownRouteScreen extends StatelessWidget {
  const _UnknownRouteScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            'This screen is not available.',
            style: AppTypography.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
