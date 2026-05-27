import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/buttons/app_primary_button.dart';
import '../../../../shared/widgets/state/status_view.dart';

class RecipeEmptyState extends StatelessWidget {
  const RecipeEmptyState({super.key, required this.onAddRecipe});

  final VoidCallback onAddRecipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xxl),
      child: StatusView(
        icon: Icons.restaurant_menu_rounded,
        title: 'No recipes saved yet',
        message: 'Start with the dishes your family makes most often.',
        primaryAction: AppPrimaryButton(
          label: 'Add Your First Recipe',
          onPressed: onAddRecipe,
        ),
      ),
    );
  }
}
