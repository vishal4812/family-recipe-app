import 'package:flutter/material.dart';

import '../../../../core/network/error_message_resolver.dart';
import '../../../../core/state/app_state_scope.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../features/recipes/domain/models/recipe.dart';
import '../../../../features/recipes/domain/models/recipe_draft.dart';
import '../../../../shared/widgets/buttons/app_primary_button.dart';
import '../../../../shared/widgets/layout/sticky_action_bar.dart';
import '../../../../shared/widgets/sheets/confirm_action_sheet.dart';
import '../../domain/value_objects/recipe_image_selection.dart';
import '../widgets/recipe_error_state.dart';
import '../widgets/recipe_form_fields.dart';
import '../widgets/recipe_photo_picker_sheet.dart';

class EditRecipeScreen extends StatefulWidget {
  const EditRecipeScreen({super.key, required this.recipeId});

  final String? recipeId;

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _prepController = TextEditingController();
  final TextEditingController _cookController = TextEditingController();
  final TextEditingController _servingsController = TextEditingController();

  bool _isSaving = false;
  bool _isDeleting = false;
  bool _isDirty = false;
  RecipeImageSelection? _selectedImage;
  String? _loadedRecipeId;

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

  void _populate(Recipe recipe) {
    if (_loadedRecipeId == recipe.id) {
      return;
    }

    _loadedRecipeId = recipe.id;
    _titleController.text = recipe.title;
    _descriptionController.text = recipe.description;
    _ingredientsController.text = recipe.ingredients.join('\n');
    _instructionsController.text = recipe.instructions.join('\n');
    _prepController.text = recipe.prepTimeMinutes?.toString() ?? '';
    _cookController.text = recipe.cookTimeMinutes?.toString() ?? '';
    _servingsController.text = recipe.servings?.toString() ?? '';
    _selectedImage = RecipeImageSelection(
      imageUrl: recipe.imageUrl,
      imagePath: recipe.imagePath,
    );
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
    if (_isSaving || _isDeleting) {
      return;
    }

    final selectedImage = await RecipePhotoPickerSheet.show(context);
    if (!mounted || selectedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = selectedImage;
      _isDirty = true;
    });
  }

  Future<void> _saveRecipe(Recipe existingRecipe) async {
    if (_isSaving || _isDeleting) {
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

      await appState.updateRecipe(recipeId: existingRecipe.id, draft: draft);

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
              fallbackMessage: 'We could not update this recipe.',
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

  void _deleteRecipe(Recipe recipe) {
    if (_isSaving || _isDeleting) {
      return;
    }

    final appState = AppStateScope.read(context);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    ConfirmActionSheet.show(
      context,
      title: 'Delete "${recipe.title}"?',
      message: 'This action can\'t be undone.',
      onConfirm: () async {
        if (_isDeleting) {
          return;
        }
        if (mounted) {
          setState(() => _isDeleting = true);
        }
        try {
          await appState.deleteRecipe(recipe.id);
          navigator.pop();
          messenger.showSnackBar(
            const SnackBar(content: Text('Recipe deleted')),
          );
        } catch (error) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                resolveErrorMessage(
                  error,
                  fallbackMessage: 'We could not delete this recipe.',
                ),
              ),
            ),
          );
        } finally {
          if (mounted) {
            setState(() => _isDeleting = false);
          }
        }
      },
    );
  }

  Future<bool> _handleBack() async {
    if (!_isDirty) {
      return true;
    }
    final shouldLeave =
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Discard changes?'),
              content: const Text('You have unsaved edits on this recipe.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Keep editing'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(foregroundColor: AppColors.error),
                  child: const Text('Discard'),
                ),
              ],
            );
          },
        ) ??
        false;
    return shouldLeave;
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.watch(context);
    final recipe = appState.recipeById(widget.recipeId);

    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Recipe')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RecipeErrorState(
              onRetry: () => Navigator.of(context).pop(),
              onGoBack: () => Navigator.of(context).pop(),
              title: 'Recipe not found',
              message:
                  'This recipe may have been deleted or is no longer available.',
            ),
          ),
        ),
      );
    }

    _populate(recipe);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }
        final shouldLeave = await _handleBack();
        if (shouldLeave && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Recipe')),
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
                        onChanged: () {
                          if (!_isDirty) {
                            setState(() => _isDirty = true);
                          }
                        },
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
                            if (_isSaving || _isDeleting) {
                              return;
                            }
                            setState(() {
                              _selectedImage = null;
                              _isDirty = true;
                            });
                          },
                          deleteActionLabel: 'Delete Recipe',
                          onDeleteTap: () => _deleteRecipe(recipe),
                        ),
                      ),
                    ),
                  ),
                  StickyActionBar(
                    child: AppPrimaryButton(
                      label: _isDeleting ? 'Deleting...' : 'Save Changes',
                      isLoading: _isSaving,
                      onPressed: _isDeleting ? null : () => _saveRecipe(recipe),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
