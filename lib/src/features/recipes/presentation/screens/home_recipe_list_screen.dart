import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/navigation/route_names.dart';
import '../../../../core/state/app_state.dart';
import '../../../../core/state/app_state_scope.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/buttons/app_icon_button.dart';
import '../../../../shared/widgets/buttons/app_primary_button.dart';
import '../../../../shared/widgets/buttons/app_text_button.dart';
import '../../../../shared/widgets/inputs/recipe_search_field.dart';
import '../../../../shared/widgets/state/status_view.dart';
import '../widgets/add_recipe_fab.dart';
import '../widgets/home_header_block.dart';
import '../widgets/recipe_card.dart';
import '../widgets/recipe_empty_state.dart';
import '../widgets/recipe_error_state.dart';
import '../widgets/recipe_loading_state.dart';

class HomeRecipeListScreen extends StatefulWidget {
  const HomeRecipeListScreen({super.key});

  @override
  State<HomeRecipeListScreen> createState() => _HomeRecipeListScreenState();
}

class _HomeRecipeListScreenState extends State<HomeRecipeListScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  String? _selectedCollection;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  String get _query => _searchController.text.trim().toLowerCase();

  String _countLabel(int count, String singular, String plural) {
    return '$count ${count == 1 ? singular : plural}';
  }

  Future<void> _openAddRecipe() async {
    final result = await Navigator.of(context).pushNamed(RouteNames.addRecipe);
    if (!mounted || result != true) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Recipe saved')));
  }

  Future<void> _openProfile() async {
    await Navigator.of(context).pushNamed(RouteNames.profile);
  }

  Future<void> _openRecipeDetail(String recipeId) async {
    await AppStateScope.read(context).ensureRecipeLoaded(recipeId);
    if (!mounted) {
      return;
    }
    await Navigator.of(
      context,
    ).pushNamed(RouteNames.recipeDetail, arguments: recipeId);
  }

  void _handleSearchChanged(String value) {
    setState(() {});
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 250), () {
      if (!mounted) {
        return;
      }
      AppStateScope.read(context).searchRecipes(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.watch(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        titleSpacing: 20,
        title: const SizedBox.shrink(),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AppIconButton(
              icon: Icons.account_circle_rounded,
              onPressed: _openProfile,
            ),
          ),
        ],
      ),
      floatingActionButton:
          appState.recipeLoadStatus == RecipeLoadStatus.loaded && _query.isEmpty
          ? AddRecipeFab(onPressed: _openAddRecipe)
          : null,
      body: SafeArea(
        top: false,
        child: switch (appState.recipeLoadStatus) {
          RecipeLoadStatus.idle => const RecipeLoadingState(),
          RecipeLoadStatus.loading => const RecipeLoadingState(),
          RecipeLoadStatus.error => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: RecipeErrorState(
                onRetry: appState.retryRecipeLoad,
                message:
                    appState.recipeErrorMessage ??
                    'We couldn\'t load your recipes right now. Please try again.',
              ),
            ),
          ),
          RecipeLoadStatus.loaded => _buildLoadedState(appState),
        },
      ),
    );
  }

  Widget _buildLoadedState(AppState appState) {
    final recipes = appState.recipes;
    final hasQuery = _query.isNotEmpty;
    final collections =
        recipes
            .map((recipe) => recipe.collection?.trim() ?? '')
            .where((collection) => collection.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    final hasCollectionFilter = (_selectedCollection ?? '').isNotEmpty;
    final filteredRecipes = recipes.where((recipe) {
      final matchesCollection =
          !hasCollectionFilter || recipe.collection == _selectedCollection;
      final matchesQuery =
          !hasQuery || recipe.title.toLowerCase().contains(_query);
      return matchesCollection && matchesQuery;
    }).toList();
    final resultsLabel = hasQuery
        ? '${_countLabel(filteredRecipes.length, 'result', 'results')} for "${_searchController.text.trim()}"'
        : hasCollectionFilter
        ? '${_countLabel(filteredRecipes.length, 'recipe', 'recipes')} in ${_selectedCollection!}'
        : '';

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppDimensions.maxContentWidth,
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 88),
          children: <Widget>[
            const HomeHeaderBlock(
              eyebrow: 'Your family cookbook',
              title: 'Recipes worth keeping',
              subtitle:
                  'Keep every family favourite, story, and tradition close.',
            ),
            const SizedBox(height: AppSpacing.md),
            RecipeSearchField(
              controller: _searchController,
              onChanged: _handleSearchChanged,
              onClear: () {
                _searchController.clear();
                setState(() {});
                AppStateScope.read(context).searchRecipes('');
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              hasQuery || hasCollectionFilter
                  ? resultsLabel
                  : '${_countLabel(recipes.length, 'recipe', 'recipes')} in your cookbook',
              style: AppTypography.caption,
            ),
            if (collections.isNotEmpty) ...<Widget>[
              const SizedBox(height: AppSpacing.md),
              Text(
                'Browse family chapters',
                style: AppTypography.bodyLarge.copyWith(fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.xs),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: collections.length + 1,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSpacing.xs),
                  itemBuilder: (context, index) {
                    final collection = index == 0
                        ? null
                        : collections[index - 1];
                    return ChoiceChip(
                      label: Text(collection ?? 'All collections'),
                      selected: _selectedCollection == collection,
                      onSelected: (_) {
                        setState(() => _selectedCollection = collection);
                      },
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            if ((hasQuery || hasCollectionFilter) && filteredRecipes.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xxl),
                child: StatusView(
                  icon: Icons.restaurant_menu_rounded,
                  title: hasQuery ? 'No recipes found' : 'No recipes here yet',
                  message: hasQuery
                      ? 'Try a different title or add this recipe as a new one.'
                      : 'Add a recipe to ${_selectedCollection!} or choose another collection.',
                  primaryAction: AppPrimaryButton(
                    label: 'Add Recipe',
                    onPressed: _openAddRecipe,
                  ),
                  secondaryAction: AppTextButton(
                    label: 'Clear filters',
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _selectedCollection = null);
                      AppStateScope.read(context).searchRecipes('');
                    },
                  ),
                ),
              )
            else if (recipes.isEmpty)
              RecipeEmptyState(onAddRecipe: _openAddRecipe)
            else
              ...filteredRecipes.map(
                (recipe) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: RecipeCard(
                    title: recipe.title,
                    subtitle: recipe.description,
                    prepMinutes: recipe.prepTimeMinutes,
                    cookMinutes: recipe.cookTimeMinutes,
                    servings: recipe.servings,
                    collection: recipe.collection,
                    imageUrl: recipe.imageUrl,
                    imagePath: recipe.imagePath,
                    onTap: () => _openRecipeDetail(recipe.id),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
