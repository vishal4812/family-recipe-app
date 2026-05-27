import 'package:flutter_test/flutter_test.dart';

import 'package:family_recipe_app/src/app.dart';
import 'package:family_recipe_app/src/core/auth/auth_token_store.dart';
import 'package:family_recipe_app/src/core/auth/memory_auth_token_store.dart';
import 'package:family_recipe_app/src/core/di/app_dependencies.dart';
import 'package:family_recipe_app/src/features/profile/domain/models/app_user.dart';
import 'package:family_recipe_app/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:family_recipe_app/src/features/auth/domain/services/auth_service.dart';
import 'package:family_recipe_app/src/features/recipes/data/mock_recipe_seed.dart';
import 'package:family_recipe_app/src/features/recipes/domain/models/recipe.dart';
import 'package:family_recipe_app/src/features/recipes/domain/models/recipe_draft.dart';
import 'package:family_recipe_app/src/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:family_recipe_app/src/features/recipes/domain/services/recipe_image_picker_service.dart';
import 'package:family_recipe_app/src/features/recipes/domain/services/recipe_service.dart';

class FakeRecipeImagePickerService implements RecipeImagePickerService {
  FakeRecipeImagePickerService({this.result});

  final String? result;

  @override
  Future<String?> pickFromGallery() async => result;
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    this.restoredUser,
    this.restoreSessionError,
    this.signInUser,
    this.signUpUser,
    this.signInError,
    this.signUpError,
  });

  final AppUser? restoredUser;
  final Object? restoreSessionError;
  final AppUser? signInUser;
  final AppUser? signUpUser;
  final Object? signInError;
  final Object? signUpError;

  @override
  Future<AppUser?> restoreSession() async {
    if (restoreSessionError != null) {
      throw restoreSessionError!;
    }
    return restoredUser;
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    if (signInError != null) {
      throw signInError!;
    }

    return signInUser ?? AppUser(name: 'Priya Sharma', email: email.trim());
  }

  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    if (signUpError != null) {
      throw signUpError!;
    }

    return signUpUser ??
        AppUser(
          name: (fullName ?? '').trim().isEmpty
              ? 'Family Cook'
              : fullName!.trim(),
          email: email.trim(),
        );
  }

  @override
  Future<void> signOut() async {}
}

class FakeRecipeRepository implements RecipeRepository {
  FakeRecipeRepository({List<Recipe>? initialRecipes, this.fetchError})
    : _recipes = List<Recipe>.from(initialRecipes ?? buildTestRecipes());

  final List<Recipe> _recipes;
  final Object? fetchError;

  @override
  Future<Recipe> createRecipe(RecipeDraft draft) async {
    final now = DateTime(2026, 4, 7, 12);
    final recipe = Recipe(
      id: 'recipe_${_recipes.length + 1}',
      title: draft.title,
      description: draft.description,
      ingredients: draft.ingredients,
      instructions: draft.instructions,
      imageUrl: draft.image?.imageUrl,
      imagePath: draft.image?.imagePath,
      prepTimeMinutes: draft.prepTimeMinutes,
      cookTimeMinutes: draft.cookTimeMinutes,
      servings: draft.servings,
      createdAt: now,
      updatedAt: now,
    );
    _recipes.insert(0, recipe);
    return recipe;
  }

  @override
  Future<void> deleteRecipe(String recipeId) async {
    _recipes.removeWhere((recipe) => recipe.id == recipeId);
  }

  @override
  Future<Recipe> fetchRecipeById(String recipeId) async {
    return _recipes.firstWhere((recipe) => recipe.id == recipeId);
  }

  @override
  Future<List<Recipe>> fetchRecipes({String? search}) async {
    if (fetchError != null) {
      throw fetchError!;
    }

    final normalizedSearch = (search ?? '').trim().toLowerCase();
    return _recipes.where((recipe) {
      if (normalizedSearch.isEmpty) {
        return true;
      }
      return recipe.title.toLowerCase().contains(normalizedSearch);
    }).toList();
  }

  @override
  Future<Recipe> updateRecipe({
    required String recipeId,
    required RecipeDraft draft,
  }) async {
    final index = _recipes.indexWhere((recipe) => recipe.id == recipeId);
    final existing = _recipes[index];
    final updated = existing.copyWith(
      title: draft.title,
      description: draft.description,
      ingredients: draft.ingredients,
      instructions: draft.instructions,
      imageUrl: draft.image?.imageUrl,
      imagePath: draft.image?.imagePath,
      prepTimeMinutes: draft.prepTimeMinutes,
      cookTimeMinutes: draft.cookTimeMinutes,
      servings: draft.servings,
      updatedAt: DateTime(2026, 4, 7, 13),
    );
    _recipes[index] = updated;
    return updated;
  }
}

List<Recipe> buildTestRecipes() {
  return MockRecipeSeed.sampleRecipes
      .map((recipe) => recipe.copyWith(imageUrl: null, imagePath: null))
      .toList();
}

AppDependencies buildTestDependencies({
  bool signedIn = false,
  AppUser? signedInUser,
  List<Recipe>? recipes,
  bool simulateInitialRecipeLoadError = false,
  RecipeImagePickerService? imagePickerService,
}) {
  return AppDependencies.mock(
    splashDelay: Duration.zero,
    authDelay: Duration.zero,
    recipeFetchDelay: Duration.zero,
    recipeMutationDelay: Duration.zero,
    initialSignedInUser: signedIn
        ? (signedInUser ?? MockRecipeSeed.sampleUser)
        : null,
    initialRecipes: recipes ?? buildTestRecipes(),
    simulateInitialRecipeLoadError: simulateInitialRecipeLoadError,
    recipeImagePickerService:
        imagePickerService ?? FakeRecipeImagePickerService(),
  );
}

AppDependencies buildCustomTestDependencies({
  required AuthRepository authRepository,
  RecipeRepository? recipeRepository,
  RecipeImagePickerService? imagePickerService,
  AuthTokenStore? authTokenStore,
}) {
  final resolvedRecipeRepository =
      recipeRepository ??
      FakeRecipeRepository(initialRecipes: buildTestRecipes());
  final resolvedAuthTokenStore = authTokenStore ?? MemoryAuthTokenStore();

  return AppDependencies(
    authRepository: authRepository,
    recipeRepository: resolvedRecipeRepository,
    authService: AuthService(authRepository),
    recipeService: RecipeService(resolvedRecipeRepository),
    recipeImagePickerService:
        imagePickerService ?? FakeRecipeImagePickerService(),
    authTokenStore: resolvedAuthTokenStore,
    splashDelay: Duration.zero,
    showSamplePhotoOptions: true,
  );
}

Future<void> pumpTestApp(
  WidgetTester tester, {
  AppDependencies? dependencies,
}) async {
  await tester.pumpWidget(
    FamilyRecipeApp(dependencies: dependencies ?? buildTestDependencies()),
  );
  await tester.pumpAndSettle();
}
