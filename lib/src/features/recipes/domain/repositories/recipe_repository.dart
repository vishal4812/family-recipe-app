import '../models/recipe.dart';
import '../models/recipe_draft.dart';

abstract interface class RecipeRepository {
  Future<List<Recipe>> fetchRecipes({String? search});

  Future<Recipe> fetchRecipeById(String recipeId);

  Future<Recipe> createRecipe(RecipeDraft draft);

  Future<Recipe> updateRecipe({
    required String recipeId,
    required RecipeDraft draft,
  });

  Future<void> deleteRecipe(String recipeId);
}
