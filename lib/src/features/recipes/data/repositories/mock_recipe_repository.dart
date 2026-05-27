import '../../data/mock_recipe_seed.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/recipe_draft.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../dtos/recipe_dto.dart';

class MockRecipeRepository implements RecipeRepository {
  MockRecipeRepository({
    this.fetchDelay = const Duration(milliseconds: 650),
    this.mutationDelay = const Duration(milliseconds: 400),
    List<Recipe>? initialRecipes,
    this.simulateInitialLoadError = false,
  }) : _recipes = (initialRecipes ?? MockRecipeSeed.sampleRecipes)
           .map(RecipeDto.fromDomain)
           .toList();

  final Duration fetchDelay;
  final Duration mutationDelay;
  final bool simulateInitialLoadError;

  final List<RecipeDto> _recipes;
  bool _hasReturnedLoadError = false;

  @override
  Future<List<Recipe>> fetchRecipes({String? search}) async {
    await Future<void>.delayed(fetchDelay);

    if (simulateInitialLoadError && !_hasReturnedLoadError) {
      _hasReturnedLoadError = true;
      throw Exception('We could not load your recipes.');
    }

    final normalizedSearch = (search ?? '').trim().toLowerCase();
    final matches = normalizedSearch.isEmpty
        ? _recipes
        : _recipes
              .where(
                (dto) => dto.title.toLowerCase().contains(normalizedSearch),
              )
              .toList();

    return matches.map((dto) => dto.toDomain()).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<Recipe> fetchRecipeById(String recipeId) async {
    await Future<void>.delayed(fetchDelay);
    final dto = _recipes.cast<RecipeDto?>().firstWhere(
      (recipe) => recipe?.id == recipeId,
      orElse: () => null,
    );
    if (dto == null) {
      throw Exception('Recipe not found.');
    }

    return dto.toDomain();
  }

  @override
  Future<Recipe> createRecipe(RecipeDraft draft) async {
    await Future<void>.delayed(mutationDelay);
    final now = DateTime.now();
    final dto = RecipeDto(
      id: now.microsecondsSinceEpoch.toString(),
      userId: '',
      title: draft.title,
      description: draft.description,
      ingredients: draft.ingredients,
      instructions: draft.instructions,
      imageUrl: draft.image?.imageUrl,
      imagePath: draft.image?.imagePath,
      prepTimeMinutes: draft.prepTimeMinutes,
      cookTimeMinutes: draft.cookTimeMinutes,
      servings: draft.servings,
      createdAt: now.toIso8601String(),
      updatedAt: now.toIso8601String(),
    );
    _recipes.insert(0, dto);
    return dto.toDomain();
  }

  @override
  Future<Recipe> updateRecipe({
    required String recipeId,
    required RecipeDraft draft,
  }) async {
    await Future<void>.delayed(mutationDelay);
    final index = _recipes.indexWhere((dto) => dto.id == recipeId);
    if (index == -1) {
      throw Exception('Recipe not found.');
    }
    final existing = _recipes[index];
    final updated = RecipeDto(
      id: existing.id,
      userId: existing.userId,
      title: draft.title,
      description: draft.description,
      ingredients: draft.ingredients,
      instructions: draft.instructions,
      imageUrl: draft.image?.imageUrl,
      imagePath: draft.image?.imagePath,
      prepTimeMinutes: draft.prepTimeMinutes,
      cookTimeMinutes: draft.cookTimeMinutes,
      servings: draft.servings,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
    _recipes[index] = updated;
    return updated.toDomain();
  }

  @override
  Future<void> deleteRecipe(String recipeId) async {
    await Future<void>.delayed(mutationDelay);
    _recipes.removeWhere((dto) => dto.id == recipeId);
  }
}
