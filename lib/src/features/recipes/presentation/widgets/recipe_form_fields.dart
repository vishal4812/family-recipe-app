import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/value_objects/recipe_image_selection.dart';
import '../../../../shared/widgets/buttons/app_text_button.dart';
import '../../../../shared/widgets/inputs/app_multiline_field.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';
import 'image_upload_box.dart';

class RecipeFormFields extends StatelessWidget {
  const RecipeFormFields({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.ingredientsController,
    required this.instructionsController,
    required this.prepController,
    required this.cookController,
    required this.servingsController,
    required this.titleValidator,
    required this.ingredientsValidator,
    required this.instructionsValidator,
    required this.onSelectImage,
    this.image,
    this.onRemoveImage,
    this.deleteActionLabel,
    this.onDeleteTap,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController ingredientsController;
  final TextEditingController instructionsController;
  final TextEditingController prepController;
  final TextEditingController cookController;
  final TextEditingController servingsController;
  final String? Function(String?) titleValidator;
  final String? Function(String?) ingredientsValidator;
  final String? Function(String?) instructionsValidator;
  final VoidCallback onSelectImage;
  final RecipeImageSelection? image;
  final VoidCallback? onRemoveImage;
  final String? deleteActionLabel;
  final VoidCallback? onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ImageUploadBox(
          imageUrl: image?.imageUrl,
          imagePath: image?.imagePath,
          onTap: onSelectImage,
          onRemove: onRemoveImage,
        ),
        const SizedBox(height: AppSpacing.xl),
        AppTextField(
          label: 'Recipe title',
          hintText: 'Eg. Aloo Paratha',
          controller: titleController,
          textInputAction: TextInputAction.next,
          validator: titleValidator,
        ),
        const SizedBox(height: AppSpacing.md),
        AppMultilineField(
          label: 'Description',
          hintText: 'Optional family note or short description',
          controller: descriptionController,
          minLines: 3,
          maxLines: 4,
        ),
        const SizedBox(height: AppSpacing.xl),
        AppMultilineField(
          label: 'Ingredients',
          hintText: 'Add one ingredient per line',
          helperText: 'Add one ingredient per line',
          controller: ingredientsController,
          validator: ingredientsValidator,
        ),
        const SizedBox(height: AppSpacing.xl),
        AppMultilineField(
          label: 'Instructions',
          hintText: 'Write one step per line',
          helperText: 'Write one step per line',
          controller: instructionsController,
          validator: instructionsValidator,
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: <Widget>[
            Expanded(
              child: AppTextField(
                label: 'Prep time',
                hintText: '20',
                controller: prepController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppTextField(
                label: 'Cook time',
                hintText: '15',
                controller: cookController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Servings',
          hintText: '4',
          controller: servingsController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
        ),
        if (deleteActionLabel != null && onDeleteTap != null) ...<Widget>[
          const SizedBox(height: AppSpacing.xl),
          AppTextButton(
            label: deleteActionLabel!,
            foregroundColor: Colors.red,
            onPressed: onDeleteTap,
          ),
        ],
      ],
    );
  }
}
