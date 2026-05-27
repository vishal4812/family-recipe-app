import '../models/recipe.dart';
import '../models/recipe_draft.dart';
import '../repositories/recipe_repository.dart';

class RecipeService {
  const RecipeService(this._recipeRepository);

  final RecipeRepository _recipeRepository;

  Future<List<Recipe>> fetchRecipes({String? search}) async {
    final recipes = await _recipeRepository.fetchRecipes(search: search);
    return recipes..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<Recipe> fetchRecipeById(String recipeId) {
    return _recipeRepository.fetchRecipeById(recipeId);
  }

  Future<Recipe> createRecipe(RecipeDraft draft) {
    return _recipeRepository.createRecipe(draft);
  }

  Future<Recipe> updateRecipe({
    required String recipeId,
    required RecipeDraft draft,
  }) {
    return _recipeRepository.updateRecipe(recipeId: recipeId, draft: draft);
  }

  Future<void> deleteRecipe(String recipeId) {
    return _recipeRepository.deleteRecipe(recipeId);
  }
}
