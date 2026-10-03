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
    this.collection,
  });

  final String title;
  final String? subtitle;
  final String? imageUrl;
  final String? imagePath;
  final int? prepMinutes;
  final int? cookMinutes;
  final int? servings;
  final String? collection;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.radius20,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppDimensions.recipeCardMinHeight,
          ),
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadii.radius20,
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
                    if ((collection ?? '').trim().isNotEmpty) ...<Widget>[
                      _CollectionLabel(label: collection!.trim()),
                      const SizedBox(height: AppSpacing.xs),
                    ],
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
                        if (prepMinutes != null || cookMinutes != null)
                          MetadataChip(
                            icon: Icons.schedule_rounded,
                            label:
                                '${(prepMinutes ?? 0) + (cookMinutes ?? 0)} min',
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
      borderRadius: AppRadii.radius16,
      child: SizedBox(
        width: AppDimensions.recipeCardImageSize + 8,
        height: AppDimensions.recipeCardImageSize + 8,
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
      child: const Icon(Icons.menu_book_outlined, color: AppColors.primaryDark),
    );
  }
}

class _CollectionLabel extends StatelessWidget {
  const _CollectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cookbookSage,
        borderRadius: AppRadii.radius28,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.bookmark_added_outlined,
            size: 14,
            color: AppColors.cookbookSageDark,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption.copyWith(
                color: AppColors.cookbookSageDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
