import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/state/skeleton_block.dart';

class SkeletonRecipeCard extends StatelessWidget {
  const SkeletonRecipeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.recipeCardMinHeight,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(borderRadius: AppRadii.radius16),
      child: Row(
        children: <Widget>[
          const SkeletonBlock(
            width: AppDimensions.recipeCardImageSize,
            height: AppDimensions.recipeCardImageSize,
            borderRadius: AppRadii.radius12,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                SkeletonBlock(height: 18, width: 160),
                SizedBox(height: AppSpacing.xs),
                SkeletonBlock(height: 16, width: 180),
                SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: <Widget>[
                    SkeletonBlock(
                      height: 32,
                      width: 88,
                      borderRadius: AppRadii.radius28,
                    ),
                    SkeletonBlock(
                      height: 32,
                      width: 88,
                      borderRadius: AppRadii.radius28,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
