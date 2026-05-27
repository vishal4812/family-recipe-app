import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/media/app_image.dart';

class RecipeHeroImage extends StatelessWidget {
  const RecipeHeroImage({super.key, this.imageUrl, this.imagePath});

  final String? imageUrl;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: AppDimensions.heroAspectRatio,
      child:
          (imageUrl ?? '').trim().isNotEmpty ||
              (imagePath ?? '').trim().isNotEmpty
          ? AppImage(
              imageUrl: imageUrl,
              imagePath: imagePath,
              errorBuilder: (_) => const _HeroFallback(),
            )
          : const _HeroFallback(),
    );
  }
}

class _HeroFallback extends StatelessWidget {
  const _HeroFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceSoft,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.image_outlined,
            size: AppDimensions.heroPlaceholderIconSize,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text('No photo yet', style: AppTypography.bodySmall),
        ],
      ),
    );
  }
}
