import 'package:flutter/foundation.dart';

@immutable
class RecipeImageSelection {
  const RecipeImageSelection({this.imageUrl, this.imagePath});

  final String? imageUrl;
  final String? imagePath;

  bool get hasImage =>
      (imageUrl ?? '').trim().isNotEmpty || (imagePath ?? '').trim().isNotEmpty;

  factory RecipeImageSelection.remote(String imageUrl) {
    return RecipeImageSelection(imageUrl: imageUrl);
  }

  factory RecipeImageSelection.local(String imagePath) {
    return RecipeImageSelection(imagePath: imagePath);
  }

  RecipeImageSelection copyWith({
    Object? imageUrl = _sentinel,
    Object? imagePath = _sentinel,
  }) {
    return RecipeImageSelection(
      imageUrl: identical(imageUrl, _sentinel)
          ? this.imageUrl
          : imageUrl as String?,
      imagePath: identical(imagePath, _sentinel)
          ? this.imagePath
          : imagePath as String?,
    );
  }
}

const Object _sentinel = Object();
