import '../../domain/models/recipe_draft.dart';

class RecipeUpsertDto {
  const RecipeUpsertDto({
    required this.title,
    this.description,
    required this.ingredients,
    required this.instructions,
    this.imageUrl,
    this.prepTime,
    this.cookTime,
    this.servings,
  });

  final String title;
  final String? description;
  final String ingredients;
  final String instructions;
  final String? imageUrl;
  final int? prepTime;
  final int? cookTime;
  final int? servings;

  factory RecipeUpsertDto.fromDraft(RecipeDraft draft) {
    final description = draft.description.trim();
    return RecipeUpsertDto(
      title: draft.title.trim(),
      description: description.isEmpty ? null : description,
      ingredients: draft.ingredients.join('\n'),
      instructions: draft.instructions.join('\n'),
      imageUrl: draft.image?.imageUrl,
      prepTime: draft.prepTimeMinutes,
      cookTime: draft.cookTimeMinutes,
      servings: draft.servings,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'ingredients': ingredients,
      'instructions': instructions,
      'imageUrl': imageUrl,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'servings': servings,
    };
  }
}
