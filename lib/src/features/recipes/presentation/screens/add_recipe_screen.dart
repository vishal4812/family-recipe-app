import 'package:flutter/material.dart';

import '../../../../core/network/error_message_resolver.dart';
import '../../../../core/state/app_state_scope.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../features/recipes/domain/models/recipe_draft.dart';
import '../../../../shared/widgets/buttons/app_primary_button.dart';
import '../../../../shared/widgets/layout/sticky_action_bar.dart';
import '../../domain/value_objects/recipe_image_selection.dart';
import '../widgets/recipe_form_fields.dart';
import '../widgets/recipe_photo_picker_sheet.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _prepController = TextEditingController();
  final TextEditingController _cookController = TextEditingController();
  final TextEditingController _servingsController = TextEditingController();

  bool _isSaving = false;
  RecipeImageSelection? _selectedImage;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    _prepController.dispose();
    _cookController.dispose();
    _servingsController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return 'Please enter a recipe title';
    }
    return null;
  }

  String? _validateIngredients(String? value) {
    if (_splitLines(value).isEmpty) {
      return 'Please add at least one ingredient';
    }
    return null;
  }

  String? _validateInstructions(String? value) {
    if (_splitLines(value).isEmpty) {
      return 'Please add at least one instruction step';
    }
    return null;
  }

  List<String> _splitLines(String? input) {
    return (input ?? '')
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  int? _parseInt(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return int.tryParse(trimmed);
  }

  Future<void> _selectImage() async {
    if (_isSaving) {
      return;
    }

    final selectedImage = await RecipePhotoPickerSheet.show(context);
    if (!mounted || selectedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = selectedImage;
    });
  }

  Future<void> _saveRecipe() async {
    if (_isSaving) {
      return;
    }

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final appState = AppStateScope.read(context);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _isSaving = true);

    try {
      final draft = RecipeDraft(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        ingredients: _splitLines(_ingredientsController.text),
        instructions: _splitLines(_instructionsController.text),
        image: _selectedImage,
        prepTimeMinutes: _parseInt(_prepController.text),
        cookTimeMinutes: _parseInt(_cookController.text),
        servings: _parseInt(_servingsController.text),
      );
      await appState.createRecipe(draft);

      if (!mounted) {
        return;
      }

      navigator.pop(true);
    } catch (error) {
      if (!mounted) {
        return;
      }
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            resolveErrorMessage(
              error,
              fallbackMessage: 'We could not save this recipe.',
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Recipe')),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.maxContentWidth,
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Form(
                      key: _formKey,
                      child: RecipeFormFields(
                        titleController: _titleController,
                        descriptionController: _descriptionController,
                        ingredientsController: _ingredientsController,
                        instructionsController: _instructionsController,
                        prepController: _prepController,
                        cookController: _cookController,
                        servingsController: _servingsController,
                        titleValidator: _validateTitle,
                        ingredientsValidator: _validateIngredients,
                        instructionsValidator: _validateInstructions,
                        image: _selectedImage,
                        onSelectImage: _selectImage,
                        onRemoveImage: () {
                          setState(() => _selectedImage = null);
                        },
                      ),
                    ),
                  ),
                ),
                StickyActionBar(
                  child: AppPrimaryButton(
                    label: 'Save Recipe',
                    isLoading: _isSaving,
                    onPressed: _saveRecipe,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
