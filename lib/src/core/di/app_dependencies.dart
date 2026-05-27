import '../auth/auth_token_store.dart';
import '../auth/memory_auth_token_store.dart';
import '../auth/secure_auth_token_store.dart';
import '../config/app_config.dart';
import '../../features/auth/data/repositories/api_auth_repository.dart';
import '../../features/auth/data/repositories/mock_auth_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/services/auth_service.dart';
import '../../features/profile/domain/models/app_user.dart';
import '../../features/recipes/data/repositories/api_recipe_repository.dart';
import '../../features/recipes/data/repositories/mock_recipe_repository.dart';
import '../../features/recipes/data/services/api_recipe_image_upload_service.dart';
import '../../features/recipes/data/services/device_recipe_image_picker_service.dart';
import '../../features/recipes/domain/models/recipe.dart';
import '../../features/recipes/domain/repositories/recipe_repository.dart';
import '../../features/recipes/domain/services/recipe_image_picker_service.dart';
import '../../features/recipes/domain/services/recipe_service.dart';
import '../network/api_client.dart';
import '../network/nest_api_client.dart';

class AppDependencies {
  const AppDependencies({
    required this.authRepository,
    required this.recipeRepository,
    required this.authService,
    required this.recipeService,
    required this.recipeImagePickerService,
    required this.authTokenStore,
    required this.splashDelay,
    required this.showSamplePhotoOptions,
    this.apiClient,
  });

  final AuthRepository authRepository;
  final RecipeRepository recipeRepository;
  final AuthService authService;
  final RecipeService recipeService;
  final RecipeImagePickerService recipeImagePickerService;
  final AuthTokenStore authTokenStore;
  final Duration splashDelay;
  final bool showSamplePhotoOptions;
  final ApiClient? apiClient;

  factory AppDependencies.mock({
    Duration splashDelay = const Duration(milliseconds: 900),
    Duration authDelay = const Duration(milliseconds: 450),
    Duration recipeFetchDelay = const Duration(milliseconds: 650),
    Duration recipeMutationDelay = const Duration(milliseconds: 400),
    AppUser? initialSignedInUser,
    List<Recipe>? initialRecipes,
    bool simulateInitialRecipeLoadError = false,
    RecipeImagePickerService? recipeImagePickerService,
  }) {
    final authTokenStore = MemoryAuthTokenStore();
    final authRepository = MockAuthRepository(
      responseDelay: authDelay,
      initialSignedInUser: initialSignedInUser,
    );
    final recipeRepository = MockRecipeRepository(
      fetchDelay: recipeFetchDelay,
      mutationDelay: recipeMutationDelay,
      initialRecipes: initialRecipes,
      simulateInitialLoadError: simulateInitialRecipeLoadError,
    );

    return AppDependencies(
      authRepository: authRepository,
      recipeRepository: recipeRepository,
      authService: AuthService(authRepository),
      recipeService: RecipeService(recipeRepository),
      recipeImagePickerService:
          recipeImagePickerService ?? DeviceRecipeImagePickerService(),
      authTokenStore: authTokenStore,
      splashDelay: splashDelay,
      showSamplePhotoOptions: true,
    );
  }

  factory AppDependencies.api({
    String? baseUrl,
    Duration splashDelay = const Duration(milliseconds: 900),
    RecipeImagePickerService? recipeImagePickerService,
    AuthTokenStore? authTokenStore,
    ApiClient? apiClient,
  }) {
    final resolvedBaseUrl = (baseUrl ?? AppConfig.apiBaseUrl).trim();
    final resolvedAuthTokenStore = authTokenStore ?? SecureAuthTokenStore();
    final resolvedApiClient =
        apiClient ??
        NestApiClient(
          baseUrl: resolvedBaseUrl,
          authTokenStore: resolvedAuthTokenStore,
        );
    final authRepository = ApiAuthRepository(
      apiClient: resolvedApiClient,
      authTokenStore: resolvedAuthTokenStore,
    );
    final recipeRepository = ApiRecipeRepository(
      apiClient: resolvedApiClient,
      imageUploadService: ApiRecipeImageUploadService(
        apiClient: resolvedApiClient,
      ),
    );

    return AppDependencies(
      authRepository: authRepository,
      recipeRepository: recipeRepository,
      authService: AuthService(authRepository),
      recipeService: RecipeService(recipeRepository),
      recipeImagePickerService:
          recipeImagePickerService ?? DeviceRecipeImagePickerService(),
      authTokenStore: resolvedAuthTokenStore,
      splashDelay: splashDelay,
      showSamplePhotoOptions: AppConfig.enableSamplePhotoOptions,
      apiClient: resolvedApiClient,
    );
  }
}
