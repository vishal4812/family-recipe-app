import 'package:flutter/material.dart';

import '../../../../core/di/app_dependencies_scope.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/value_objects/recipe_image_selection.dart';
import '../../data/mock_recipe_seed.dart';

class RecipePhotoPickerSheet extends StatefulWidget {
  const RecipePhotoPickerSheet({super.key});

  static Future<RecipeImageSelection?> show(BuildContext context) {
    return showModalBottomSheet<RecipeImageSelection>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => const RecipePhotoPickerSheet(),
    );
  }

  @override
  State<RecipePhotoPickerSheet> createState() => _RecipePhotoPickerSheetState();
}

class _RecipePhotoPickerSheetState extends State<RecipePhotoPickerSheet> {
  bool _isPickingDeviceImage = false;

  Future<void> _pickFromDevice() async {
    final pickerService = AppDependenciesScope.read(
      context,
    ).recipeImagePickerService;

    setState(() => _isPickingDeviceImage = true);
    try {
      final imagePath = await pickerService.pickFromGallery();
      if (!mounted || imagePath == null || imagePath.trim().isEmpty) {
        return;
      }
      Navigator.of(context).pop(RecipeImageSelection.local(imagePath));
    } finally {
      if (mounted) {
        setState(() => _isPickingDeviceImage = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dependencies = AppDependenciesScope.read(context);
    final showSampleOptions = dependencies.showSamplePhotoOptions;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Choose a recipe photo', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            showSampleOptions
                ? 'Pick from your device or use a sample image while the backend is not connected.'
                : 'Pick a photo from your device to attach it to this recipe.',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          Material(
            color: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.radius16,
              side: const BorderSide(color: AppColors.border),
            ),
            child: InkWell(
              borderRadius: AppRadii.radius16,
              onTap: _isPickingDeviceImage ? null : _pickFromDevice,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.accentSoft,
                        borderRadius: AppRadii.radius12,
                      ),
                      alignment: Alignment.center,
                      child: _isPickingDeviceImage
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(
                              Icons.photo_library_outlined,
                              color: AppColors.primaryDark,
                            ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Choose from device',
                        style: AppTypography.bodyLarge,
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                ),
              ),
            ),
          ),
          if (showSampleOptions) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            ...List<Widget>.generate(
              MockRecipeSeed.mockUploadImageOptions.length,
              (int index) {
                final imageUrl = MockRecipeSeed.mockUploadImageOptions[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom:
                        index ==
                            MockRecipeSeed.mockUploadImageOptions.length - 1
                        ? 0
                        : AppSpacing.sm,
                  ),
                  child: Material(
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.radius16,
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: InkWell(
                      borderRadius: AppRadii.radius16,
                      onTap: () => Navigator.of(
                        context,
                      ).pop(RecipeImageSelection.remote(imageUrl)),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: AppRadii.radius12,
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: AppColors.surfaceSoft,
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.image_outlined),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                'Sample photo ${index + 1}',
                                style: AppTypography.bodyLarge,
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
