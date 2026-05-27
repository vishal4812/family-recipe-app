import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/media/app_image.dart';

class ImageUploadBox extends StatelessWidget {
  const ImageUploadBox({
    super.key,
    required this.onTap,
    this.imageUrl,
    this.imagePath,
    this.onRemove,
  });

  final VoidCallback onTap;
  final String? imageUrl;
  final String? imagePath;
  final VoidCallback? onRemove;

  bool get _hasImage =>
      (imageUrl ?? '').trim().isNotEmpty || (imagePath ?? '').trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.radius16,
        child: Container(
          height: AppDimensions.uploadBoxHeight,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadii.radius16,
            border: Border.all(color: AppColors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              if (_hasImage)
                _ImageUploadPreview(imageUrl: imageUrl, imagePath: imagePath)
              else
                _EmptyUploadState(onTap: onTap),
              if (_hasImage && onRemove != null)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Material(
                    color: AppColors.surface,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onRemove,
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.close_rounded, size: 18),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyUploadState extends StatelessWidget {
  const _EmptyUploadState({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.accentSoft,
                borderRadius: AppRadii.radius16,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.add_a_photo_outlined,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Add recipe photo',
              style: AppTypography.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Optional, but helpful',
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageUploadPreview extends StatelessWidget {
  const _ImageUploadPreview({this.imageUrl, this.imagePath});

  final String? imageUrl;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    if ((imageUrl ?? '').trim().isEmpty && (imagePath ?? '').trim().isEmpty) {
      return Container(
        color: AppColors.surfaceSoft,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.image_outlined,
              size: 36,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text('Photo selected', style: AppTypography.bodySmall),
          ],
        ),
      );
    }

    return AppImage(
      imageUrl: imageUrl,
      imagePath: imagePath,
      errorBuilder: (_) {
        return Container(
          color: AppColors.surfaceSoft,
          alignment: Alignment.center,
          child: const Icon(
            Icons.image_outlined,
            size: 36,
            color: AppColors.textSecondary,
          ),
        );
      },
    );
  }
}
