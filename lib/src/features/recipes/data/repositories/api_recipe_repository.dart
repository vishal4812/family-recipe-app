import '../../../../core/network/api_client.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/recipe_draft.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../dtos/recipe_dto.dart';
import '../dtos/recipe_upsert_dto.dart';
import '../services/api_recipe_image_upload_service.dart';

class ApiRecipeRepository implements RecipeRepository {
  ApiRecipeRepository({
    required ApiClient apiClient,
    required ApiRecipeImageUploadService imageUploadService,
  }) : _apiClient = apiClient,
       _imageUploadService = imageUploadService;

  final ApiClient _apiClient;
  final ApiRecipeImageUploadService _imageUploadService;

  @override
  Future<List<Recipe>> fetchRecipes({String? search}) async {
    final response = await _apiClient.get(
      '/recipes',
      queryParameters: <String, String>{
        if ((search ?? '').trim().isNotEmpty) 'search': search!.trim(),
      },
    );
    if (response is! List<dynamic>) {
      return <Recipe>[];
    }

    return response
        .whereType<Map<String, dynamic>>()
        .map(RecipeDto.fromJson)
        .map((dto) => dto.toDomain())
        .toList();
  }

  @override
  Future<Recipe> fetchRecipeById(String recipeId) async {
    final response = await _apiClient.get('/recipes/$recipeId');
    if (response is! Map<String, dynamic>) {
      throw Exception('Recipe not found.');
    }

    return RecipeDto.fromJson(response).toDomain();
  }

  @override
  Future<Recipe> createRecipe(RecipeDraft draft) async {
    final resolvedDraft = await _resolveDraftWithUploadedImage(draft);
    final response = await _apiClient.post(
      '/recipes',
      body: RecipeUpsertDto.fromDraft(resolvedDraft).toJson(),
    );
    if (response is! Map<String, dynamic>) {
      throw Exception('Recipe could not be created.');
    }

    return RecipeDto.fromJson(response).toDomain();
  }

  @override
  Future<Recipe> updateRecipe({
    required String recipeId,
    required RecipeDraft draft,
  }) async {
    final resolvedDraft = await _resolveDraftWithUploadedImage(draft);
    final response = await _apiClient.patch(
      '/recipes/$recipeId',
      body: RecipeUpsertDto.fromDraft(resolvedDraft).toJson(),
    );
    if (response is! Map<String, dynamic>) {
      throw Exception('Recipe could not be updated.');
    }

    return RecipeDto.fromJson(response).toDomain();
  }

  @override
  Future<void> deleteRecipe(String recipeId) {
    return _apiClient.delete('/recipes/$recipeId');
  }

  Future<RecipeDraft> _resolveDraftWithUploadedImage(RecipeDraft draft) async {
    final imagePath = draft.image?.imagePath?.trim() ?? '';
    final imageUrl = draft.image?.imageUrl?.trim() ?? '';
    if (imagePath.isEmpty || imageUrl.isNotEmpty) {
      return draft;
    }

    final uploadedImageUrl = await _imageUploadService.uploadImage(imagePath);
    return RecipeDraft(
      title: draft.title,
      description: draft.description,
      ingredients: draft.ingredients,
      instructions: draft.instructions,
      image: uploadedImageUrl.trim().isEmpty
          ? null
          : draft.image!.copyWith(
              imageUrl: uploadedImageUrl,
              imagePath: imagePath,
            ),
      prepTimeMinutes: draft.prepTimeMinutes,
      cookTimeMinutes: draft.cookTimeMinutes,
      servings: draft.servings,
    );
  }
}
