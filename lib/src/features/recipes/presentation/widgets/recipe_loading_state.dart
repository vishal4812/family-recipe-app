import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/state/skeleton_block.dart';
import 'skeleton_recipe_card.dart';

class RecipeLoadingState extends StatelessWidget {
  const RecipeLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 88),
      children: const <Widget>[
        SkeletonBlock(height: 18, width: 140),
        SizedBox(height: AppSpacing.xs),
        SkeletonBlock(height: 28, width: 180),
        SizedBox(height: AppSpacing.xs),
        SkeletonBlock(height: 20, width: 220),
        SizedBox(height: AppSpacing.md),
        SkeletonBlock(height: 52),
        SizedBox(height: AppSpacing.lg),
        SkeletonRecipeCard(),
        SizedBox(height: AppSpacing.sm),
        SkeletonRecipeCard(),
        SizedBox(height: AppSpacing.sm),
        SkeletonRecipeCard(),
        SizedBox(height: AppSpacing.sm),
        SkeletonRecipeCard(),
      ],
    );
  }
}
