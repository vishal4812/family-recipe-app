import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/media/app_image.dart';
import 'metadata_chip.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.imageUrl,
    this.imagePath,
    this.prepMinutes,
    this.cookMinutes,
    this.servings,
  });

  final String title;
  final String? subtitle;
  final String? imageUrl;
  final String? imagePath;
  final int? prepMinutes;
  final int? cookMinutes;
  final int? servings;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.radius16,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppDimensions.recipeCardMinHeight,
          ),
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadii.radius16,
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.low,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _RecipeImageThumbnail(imageUrl: imageUrl, imagePath: imagePath),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: AppTypography.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if ((subtitle ?? '').trim().isNotEmpty) ...<Widget>[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle!,
                        style: AppTypography.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: <Widget>[
                        if (prepMinutes != null)
                          MetadataChip(
                            icon: Icons.schedule_rounded,
                            label: '${prepMinutes!} min prep',
                          ),
                        if (cookMinutes != null)
                          MetadataChip(
                            icon: Icons.schedule_rounded,
                            label: '${cookMinutes!} min cook',
                          ),
                        if (servings != null)
                          MetadataChip(
                            icon: Icons.people_alt_outlined,
                            label: 'Serves $servings',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecipeImageThumbnail extends StatelessWidget {
  const _RecipeImageThumbnail({this.imageUrl, this.imagePath});

  final String? imageUrl;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final hasImage =
        (imageUrl ?? '').trim().isNotEmpty ||
        (imagePath ?? '').trim().isNotEmpty;

    final child = hasImage
        ? AppImage(
            imageUrl: imageUrl,
            imagePath: imagePath,
            errorBuilder: (_) => const _RecipeImageFallback(),
          )
        : const _RecipeImageFallback();

    return ClipRRect(
      borderRadius: AppRadii.radius12,
      child: SizedBox(
        width: AppDimensions.recipeCardImageSize,
        height: AppDimensions.recipeCardImageSize,
        child: child,
      ),
    );
  }
}

class _RecipeImageFallback extends StatelessWidget {
  const _RecipeImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceSoft,
      child: const Icon(Icons.image_outlined, color: AppColors.textSecondary),
    );
  }
}
