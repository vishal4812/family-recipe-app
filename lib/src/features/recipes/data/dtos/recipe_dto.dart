import '../../domain/models/recipe.dart';

class RecipeDto {
  const RecipeDto({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
    this.imagePath,
    this.prepTimeMinutes,
    this.cookTimeMinutes,
    this.servings,
  });

  final String id;
  final String userId;
  final String title;
  final String description;
  final List<String> ingredients;
  final List<String> instructions;
  final String? imageUrl;
  final String? imagePath;
  final int? prepTimeMinutes;
  final int? cookTimeMinutes;
  final int? servings;
  final String createdAt;
  final String updatedAt;

  factory RecipeDto.fromDomain(Recipe recipe) {
    return RecipeDto(
      id: recipe.id,
      userId: '',
      title: recipe.title,
      description: recipe.description,
      ingredients: recipe.ingredients,
      instructions: recipe.instructions,
      imageUrl: recipe.imageUrl,
      imagePath: recipe.imagePath,
      prepTimeMinutes: recipe.prepTimeMinutes,
      cookTimeMinutes: recipe.cookTimeMinutes,
      servings: recipe.servings,
      createdAt: recipe.createdAt.toIso8601String(),
      updatedAt: recipe.updatedAt.toIso8601String(),
    );
  }

  factory RecipeDto.fromJson(Map<String, dynamic> json) {
    return RecipeDto(
      id: (json['id'] as String?) ?? '',
      userId: (json['userId'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      ingredients: _splitMultilineText(json['ingredients']),
      instructions: _splitMultilineText(json['instructions']),
      imageUrl: json['imageUrl'] as String?,
      imagePath: null,
      prepTimeMinutes: (json['prepTime'] as num?)?.toInt(),
      cookTimeMinutes: (json['cookTime'] as num?)?.toInt(),
      servings: (json['servings'] as num?)?.toInt(),
      createdAt:
          (json['createdAt'] as String?) ?? DateTime.now().toIso8601String(),
      updatedAt:
          (json['updatedAt'] as String?) ?? DateTime.now().toIso8601String(),
    );
  }

  Recipe toDomain() {
    return Recipe(
      id: id,
      title: title,
      description: description,
      ingredients: ingredients,
      instructions: instructions,
      imageUrl: imageUrl,
      imagePath: imagePath,
      prepTimeMinutes: prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes,
      servings: servings,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'ingredients': ingredients.join('\n'),
      'instructions': instructions.join('\n'),
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'prepTime': prepTimeMinutes,
      'cookTime': cookTimeMinutes,
      'servings': servings,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

List<String> _splitMultilineText(Object? value) {
  final input = (value as String?) ?? '';
  return input
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();
}
