import 'package:flutter/material.dart';

import '../../../../core/navigation/route_names.dart';
import '../../../../core/network/error_message_resolver.dart';
import '../../../../core/state/app_state.dart';
import '../../../../core/state/app_state_scope.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/app_icon_button.dart';
import '../../../../shared/widgets/layout/section_header.dart';
import '../../../../shared/widgets/sheets/confirm_action_sheet.dart';
import '../../../../shared/widgets/state/skeleton_block.dart';
import '../widgets/ingredients_card.dart';
import '../widgets/instruction_step_list.dart';
import '../widgets/metadata_chip.dart';
import '../widgets/recipe_error_state.dart';
import '../widgets/recipe_hero_image.dart';
import '../widgets/skeleton_chip_row.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});

  final String? recipeId;

  Future<void> _openEdit(BuildContext context) async {
    await Navigator.of(
      context,
    ).pushNamed(RouteNames.editRecipe, arguments: recipeId);
  }

  void _confirmDelete(BuildContext context) {
    final appState = AppStateScope.read(context);
    final recipe = appState.recipeById(recipeId);
    if (recipe == null) {
      return;
    }
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    ConfirmActionSheet.show(
      context,
      title: 'Delete "${recipe.title}"?',
      message: 'This action can\'t be undone.',
      onConfirm: () async {
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
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.watch(context);

    if (appState.recipeLoadStatus == RecipeLoadStatus.loading) {
      return const _RecipeDetailLoadingScreen();
    }

    if (appState.recipeLoadStatus == RecipeLoadStatus.error) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: RecipeErrorState(
              onRetry: appState.retryRecipeLoad,
              onGoBack: () => Navigator.of(context).maybePop(),
              message:
                  'We couldn\'t load this recipe right now. Please try again.',
            ),
          ),
        ),
      );
    }

    final recipe = appState.recipeById(recipeId);
    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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

    return Scaffold(
      appBar: AppBar(
        title: const SizedBox.shrink(),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AppIconButton(
              icon: Icons.edit_rounded,
              onPressed: () => _openEdit(context),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              if (value == 'delete') {
                _confirmDelete(context);
              }
            },
            itemBuilder: (_) => const <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete recipe'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.maxContentWidth,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RecipeHeroImage(
                    imageUrl: recipe.imageUrl,
                    imagePath: recipe.imagePath,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(recipe.title, style: AppTypography.titleLarge),
                        if (recipe.description.trim().isNotEmpty) ...<Widget>[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            recipe.description,
                            style: AppTypography.bodySmall,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          spacing: AppSpacing.xs,
                          runSpacing: AppSpacing.xs,
                          children: <Widget>[
                            if (recipe.prepTimeMinutes != null)
                              MetadataChip(
                                icon: Icons.schedule_rounded,
                                label: '${recipe.prepTimeMinutes} min prep',
                              ),
                            if (recipe.cookTimeMinutes != null)
                              MetadataChip(
                                icon: Icons.schedule_rounded,
                                label: '${recipe.cookTimeMinutes} min cook',
                              ),
                            if (recipe.servings != null)
                              MetadataChip(
                                icon: Icons.people_alt_outlined,
                                label: 'Serves ${recipe.servings}',
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        const SectionHeader(title: 'Ingredients'),
                        const SizedBox(height: AppSpacing.sm),
                        IngredientsCard(items: recipe.ingredients),
                        const SizedBox(height: AppSpacing.xl),
                        const SectionHeader(title: 'Instructions'),
                        const SizedBox(height: AppSpacing.sm),
                        InstructionStepList(steps: recipe.instructions),
                      ],
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

class _RecipeDetailLoadingScreen extends StatelessWidget {
  const _RecipeDetailLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            AspectRatio(
              aspectRatio: AppDimensions.heroAspectRatio,
              child: SkeletonBlock(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SkeletonBlock(height: 28, width: 220),
                  SizedBox(height: AppSpacing.xs),
                  SkeletonBlock(height: 18, width: 280),
                  SizedBox(height: AppSpacing.md),
                  SkeletonChipRow(),
                  SizedBox(height: AppSpacing.xl),
                  SkeletonBlock(height: 24, width: 120),
                  SizedBox(height: AppSpacing.sm),
                  SkeletonBlock(height: 140),
                  SizedBox(height: AppSpacing.xl),
                  SkeletonBlock(height: 24, width: 120),
                  SizedBox(height: AppSpacing.sm),
                  SkeletonBlock(height: 180),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
