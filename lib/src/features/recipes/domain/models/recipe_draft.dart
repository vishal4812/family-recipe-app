import '../value_objects/recipe_image_selection.dart';

class RecipeDraft {
  const RecipeDraft({
    required this.title,
    required this.description,
    required this.ingredients,
    required this.instructions,
    this.image,
    this.prepTimeMinutes,
    this.cookTimeMinutes,
    this.servings,
  });

  final String title;
  final String description;
  final List<String> ingredients;
  final List<String> instructions;
  final RecipeImageSelection? image;
  final int? prepTimeMinutes;
  final int? cookTimeMinutes;
  final int? servings;
}
