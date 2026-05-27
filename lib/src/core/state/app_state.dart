import 'package:flutter/foundation.dart';

import '../../features/auth/domain/services/auth_service.dart';
import '../../features/profile/domain/models/app_user.dart';
import '../../features/recipes/domain/models/recipe.dart';
import '../../features/recipes/domain/models/recipe_draft.dart';
import '../../features/recipes/domain/services/recipe_service.dart';
import '../network/error_message_resolver.dart';

enum RecipeLoadStatus { idle, loading, loaded, error }

class AppState extends ChangeNotifier {
  AppState({
    required AuthService authService,
    required RecipeService recipeService,
  }) : _authService = authService,
       _recipeService = recipeService,
       _bootstrapFuture = Future<void>.value() {
    _bootstrapFuture = _bootstrap();
  }

  final AuthService _authService;
  final RecipeService _recipeService;
  late Future<void> _bootstrapFuture;

  static const AppUser _guestUser = AppUser(
    name: 'Family Cook',
    email: 'family@example.com',
  );
  AppUser _user = _guestUser;
  bool _isAuthenticated = false;
  RecipeLoadStatus _recipeLoadStatus = RecipeLoadStatus.idle;
  String? _recipeErrorMessage;
  String? _pendingAuthMessage;
  List<Recipe> _recipes = <Recipe>[];
  List<Recipe>? _searchResults;
  String _activeSearchQuery = '';

  AppUser get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  RecipeLoadStatus get recipeLoadStatus => _recipeLoadStatus;
  String? get recipeErrorMessage => _recipeErrorMessage;
  String? consumePendingAuthMessage() {
    final message = _pendingAuthMessage;
    _pendingAuthMessage = null;
    return message;
  }

  List<Recipe> get recipes => List<Recipe>.unmodifiable(
    _activeSearchQuery.isEmpty
        ? _recipes
        : (_searchResults ?? _filterLocally(_recipes, _activeSearchQuery)),
  );

  Future<void> waitUntilReady() => _bootstrapFuture;

  Future<void> _bootstrap() async {
    try {
      final restoredUser = await _authService.restoreSession();
      if (restoredUser == null) {
        _clearAuthenticatedState(notify: true);
        return;
      }

      _user = restoredUser;
      _isAuthenticated = true;
      notifyListeners();
      await loadRecipes();
    } catch (error) {
      _clearAuthenticatedState(notify: false);
      _pendingAuthMessage = resolveErrorMessage(
        error,
        fallbackMessage:
            'We could not verify your saved session. Please log in again.',
      );
      notifyListeners();
    }
  }

  Future<void> loadRecipes({bool silently = false}) async {
    if (!silently) {
      _recipeLoadStatus = RecipeLoadStatus.loading;
      _recipeErrorMessage = null;
      notifyListeners();
    }

    try {
      _recipes = await _recipeService.fetchRecipes();
      _recipeLoadStatus = RecipeLoadStatus.loaded;
      if (_activeSearchQuery.isNotEmpty) {
        _searchResults = await _recipeService.fetchRecipes(
          search: _activeSearchQuery,
        );
      }
    } catch (error) {
      if (!silently) {
        _recipeLoadStatus = RecipeLoadStatus.error;
      }
      _recipeErrorMessage = resolveErrorMessage(
        error,
        fallbackMessage: 'We could not load your recipes.',
      );
    }
    notifyListeners();
  }

  Future<void> authenticate({
    required String email,
    required String password,
    required bool isSignup,
    String? fullName,
  }) async {
    final resolvedUser = isSignup
        ? await _authService.signUp(
            email: email,
            password: password,
            fullName: fullName,
          )
        : await _authService.signIn(email: email, password: password);

    _user = resolvedUser;
    _isAuthenticated = true;
    _activeSearchQuery = '';
    _searchResults = null;
    _recipeLoadStatus = RecipeLoadStatus.idle;
    notifyListeners();
    await loadRecipes();
  }

  Future<void> logout() async {
    await _authService.signOut();
    _clearAuthenticatedState(notify: true);
  }

  Recipe? recipeById(String? id) {
    if (id == null) {
      return null;
    }

    for (final recipe in <Recipe>[..._recipes, ...?_searchResults]) {
      if (recipe.id == id) {
        return recipe;
      }
    }

    return null;
  }

  Future<Recipe?> ensureRecipeLoaded(String? recipeId) async {
    if (recipeId == null || recipeId.trim().isEmpty) {
      return null;
    }

    final existingRecipe = recipeById(recipeId);
    if (existingRecipe != null) {
      return existingRecipe;
    }

    try {
      final recipe = await _recipeService.fetchRecipeById(recipeId);
      _recipes = <Recipe>[recipe, ..._recipes]
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      notifyListeners();
      return recipe;
    } catch (_) {
      return null;
    }
  }

  Future<Recipe> createRecipe(RecipeDraft draft) async {
    final created = await _recipeService.createRecipe(draft);
    _recipes = <Recipe>[created, ..._recipes]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    _refreshSearchResults();
    notifyListeners();
    return created;
  }

  Future<Recipe> updateRecipe({
    required String recipeId,
    required RecipeDraft draft,
  }) async {
    final updated = await _recipeService.updateRecipe(
      recipeId: recipeId,
      draft: draft,
    );
    _recipes =
        _recipes
            .map((recipe) => recipe.id == updated.id ? updated : recipe)
            .toList()
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    _refreshSearchResults();
    notifyListeners();
    return updated;
  }

  Future<void> deleteRecipe(String id) async {
    await _recipeService.deleteRecipe(id);
    _recipes = _recipes.where((recipe) => recipe.id != id).toList();
    _refreshSearchResults();
    notifyListeners();
  }

  Future<void> retryRecipeLoad() async {
    if (!_isAuthenticated) {
      notifyListeners();
      return;
    }
    await loadRecipes();
  }

  Future<void> searchRecipes(String query) async {
    final normalizedQuery = query.trim();
    _activeSearchQuery = normalizedQuery;

    if (normalizedQuery.isEmpty) {
      _searchResults = null;
      notifyListeners();
      return;
    }

    notifyListeners();

    try {
      final results = await _recipeService.fetchRecipes(
        search: normalizedQuery,
      );
      if (_activeSearchQuery != normalizedQuery) {
        return;
      }

      _searchResults = results;
      _recipeErrorMessage = null;
      notifyListeners();
    } catch (_) {
      if (_activeSearchQuery != normalizedQuery) {
        return;
      }

      _searchResults = null;
      notifyListeners();
    }
  }

  List<Recipe> _filterLocally(List<Recipe> recipes, String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return recipes;
    }

    return recipes
        .where((recipe) => recipe.title.toLowerCase().contains(normalizedQuery))
        .toList();
  }

  void _refreshSearchResults() {
    if (_activeSearchQuery.isEmpty) {
      _searchResults = null;
      return;
    }

    _searchResults = _filterLocally(_recipes, _activeSearchQuery);
  }

  void _clearAuthenticatedState({required bool notify}) {
    _user = _guestUser;
    _isAuthenticated = false;
    _recipes = <Recipe>[];
    _searchResults = null;
    _activeSearchQuery = '';
    _recipeLoadStatus = RecipeLoadStatus.idle;
    _recipeErrorMessage = null;
    _pendingAuthMessage = null;
    if (notify) {
      notifyListeners();
    }
  }
}
