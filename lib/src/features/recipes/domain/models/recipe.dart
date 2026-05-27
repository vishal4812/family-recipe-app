import 'package:flutter/foundation.dart';

@immutable
class Recipe {
  const Recipe({
    required this.id,
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
  final String title;
  final String description;
  final List<String> ingredients;
  final List<String> instructions;
  final String? imageUrl;
  final String? imagePath;
  final int? prepTimeMinutes;
  final int? cookTimeMinutes;
  final int? servings;
  final DateTime createdAt;
  final DateTime updatedAt;

  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? ingredients,
    List<String>? instructions,
    Object? imageUrl = _sentinel,
    Object? imagePath = _sentinel,
    int? prepTimeMinutes,
    int? cookTimeMinutes,
    int? servings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      imageUrl: identical(imageUrl, _sentinel)
          ? this.imageUrl
          : imageUrl as String?,
      imagePath: identical(imagePath, _sentinel)
          ? this.imagePath
          : imagePath as String?,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
      servings: servings ?? this.servings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

const Object _sentinel = Object();
