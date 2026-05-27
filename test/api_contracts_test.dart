import 'package:flutter_test/flutter_test.dart';

import 'package:family_recipe_app/src/core/auth/memory_auth_token_store.dart';
import 'package:family_recipe_app/src/core/network/api_client.dart';
import 'package:family_recipe_app/src/core/network/api_exception.dart';
import 'package:family_recipe_app/src/features/auth/data/repositories/api_auth_repository.dart';
import 'package:family_recipe_app/src/features/recipes/data/repositories/api_recipe_repository.dart';
import 'package:family_recipe_app/src/features/recipes/data/services/api_recipe_image_upload_service.dart';
import 'package:family_recipe_app/src/features/recipes/domain/models/recipe_draft.dart';
import 'package:family_recipe_app/src/features/recipes/domain/value_objects/recipe_image_selection.dart';

void main() {
  group('API repository contracts', () {
    test(
      'auth sign in stores token and restoreSession uses /users/me',
      () async {
        final tokenStore = MemoryAuthTokenStore();
        final apiClient = _FakeApiClient(
          postHandler: ({required path, body, required multipart}) async {
            expect(path, '/auth/login');
            expect(body, <String, dynamic>{
              'email': 'demo@familyrecipe.app',
              'password': 'Password123!',
            });
            expect(multipart, isFalse);
            return <String, dynamic>{
              'accessToken': 'jwt-token',
              'user': <String, dynamic>{
                'id': 'user_1',
                'name': 'Anita Sharma',
                'email': 'demo@familyrecipe.app',
              },
            };
          },
          getHandler: ({required path, queryParameters}) async {
            expect(path, '/users/me');
            expect(queryParameters, isNull);
            expect(await tokenStore.readToken(), 'jwt-token');
            return <String, dynamic>{
              'id': 'user_1',
              'name': 'Anita Sharma',
              'email': 'demo@familyrecipe.app',
            };
          },
        );

        final repository = ApiAuthRepository(
          apiClient: apiClient,
          authTokenStore: tokenStore,
        );

        final signedInUser = await repository.signIn(
          email: 'demo@familyrecipe.app',
          password: 'Password123!',
        );
        expect(signedInUser.email, 'demo@familyrecipe.app');
        expect(signedInUser.name, 'Anita Sharma');
        expect(await tokenStore.readToken(), 'jwt-token');

        final restoredUser = await repository.restoreSession();
        expect(restoredUser?.email, 'demo@familyrecipe.app');
        expect(restoredUser?.name, 'Anita Sharma');
      },
    );

    test(
      'restoreSession clears invalid tokens on unauthorized response',
      () async {
        final tokenStore = MemoryAuthTokenStore(initialToken: 'expired-token');
        final repository = ApiAuthRepository(
          apiClient: _FakeApiClient(
            getHandler: ({required path, queryParameters}) async {
              throw ApiException(
                message: 'Your session has expired. Please log in again.',
                statusCode: 401,
              );
            },
          ),
          authTokenStore: tokenStore,
        );

        final restoredUser = await repository.restoreSession();
        expect(restoredUser, isNull);
        expect(await tokenStore.readToken(), isNull);
      },
    );

    test(
      'recipe repository maps search and multiline fields for the backend',
      () async {
        late Map<String, dynamic> capturedCreateBody;
        late Map<String, dynamic> capturedUpdateBody;
        late String capturedSearchQuery;
        late String uploadedFilePath;

        final repository = ApiRecipeRepository(
          apiClient: _FakeApiClient(
            getHandler: ({required path, queryParameters}) async {
              expect(path, '/recipes');
              capturedSearchQuery = queryParameters?['search'] ?? '';
              return <Map<String, dynamic>>[
                <String, dynamic>{
                  'id': 'recipe_1',
                  'userId': 'user_1',
                  'title': 'Dal Tadka',
                  'description': 'Comforting dal',
                  'ingredients': '1 cup dal\nSalt',
                  'instructions': 'Cook dal\nAdd tadka',
                  'prepTime': 10,
                  'cookTime': 25,
                  'servings': 3,
                  'imageUrl': null,
                  'createdAt': '2026-04-07T12:00:00.000Z',
                  'updatedAt': '2026-04-07T12:00:00.000Z',
                },
              ];
            },
            postHandler: ({required path, body, required multipart}) async {
              if (path == '/uploads/image') {
                uploadedFilePath = body?['filePath'] as String? ?? '';
                return <String, dynamic>{
                  'url': 'http://localhost:3000/uploads/images/dal.jpg',
                  'path': '/uploads/images/dal.jpg',
                  'originalName': 'dal.jpg',
                  'mimeType': 'image/jpeg',
                  'size': 1024,
                };
              }

              expect(path, '/recipes');
              expect(multipart, isFalse);
              capturedCreateBody = Map<String, dynamic>.from(body ?? const {});
              return <String, dynamic>{
                'id': 'recipe_2',
                'userId': 'user_1',
                'title': capturedCreateBody['title'],
                'description': capturedCreateBody['description'],
                'ingredients': capturedCreateBody['ingredients'],
                'instructions': capturedCreateBody['instructions'],
                'prepTime': capturedCreateBody['prepTime'],
                'cookTime': capturedCreateBody['cookTime'],
                'servings': capturedCreateBody['servings'],
                'imageUrl': capturedCreateBody['imageUrl'],
                'createdAt': '2026-04-07T13:00:00.000Z',
                'updatedAt': '2026-04-07T13:00:00.000Z',
              };
            },
            patchHandler: ({required path, body, required multipart}) async {
              expect(path, '/recipes/recipe_2');
              expect(multipart, isFalse);
              capturedUpdateBody = Map<String, dynamic>.from(body ?? const {});
              return <String, dynamic>{
                'id': 'recipe_2',
                'userId': 'user_1',
                'title': capturedUpdateBody['title'],
                'description': capturedUpdateBody['description'],
                'ingredients': capturedUpdateBody['ingredients'],
                'instructions': capturedUpdateBody['instructions'],
                'prepTime': capturedUpdateBody['prepTime'],
                'cookTime': capturedUpdateBody['cookTime'],
                'servings': capturedUpdateBody['servings'],
                'imageUrl': capturedUpdateBody['imageUrl'],
                'createdAt': '2026-04-07T13:00:00.000Z',
                'updatedAt': '2026-04-07T14:00:00.000Z',
              };
            },
          ),
          imageUploadService: ApiRecipeImageUploadService(
            apiClient: _FakeApiClient(
              postHandler: ({required path, body, required multipart}) async {
                expect(path, '/uploads/image');
                expect(multipart, isTrue);
                uploadedFilePath = body?['filePath'] as String? ?? '';
                return <String, dynamic>{
                  'url': 'http://localhost:3000/uploads/images/dal.jpg',
                  'path': '/uploads/images/dal.jpg',
                  'originalName': 'dal.jpg',
                  'mimeType': 'image/jpeg',
                  'size': 1024,
                };
              },
            ),
          ),
        );

        final fetchedRecipes = await repository.fetchRecipes(search: 'dal');
        expect(capturedSearchQuery, 'dal');
        expect(fetchedRecipes, hasLength(1));
        expect(fetchedRecipes.single.ingredients, <String>[
          '1 cup dal',
          'Salt',
        ]);
        expect(fetchedRecipes.single.instructions, <String>[
          'Cook dal',
          'Add tadka',
        ]);

        final createdRecipe = await repository.createRecipe(
          RecipeDraft(
            title: 'Dal Tadka',
            description: 'Comforting dal',
            ingredients: <String>['1 cup dal', 'Salt'],
            instructions: <String>['Cook dal', 'Add tadka'],
            image: RecipeImageSelection.local('/tmp/dal.jpg'),
            prepTimeMinutes: 10,
            cookTimeMinutes: 25,
            servings: 3,
          ),
        );

        expect(uploadedFilePath, '/tmp/dal.jpg');
        expect(capturedCreateBody, <String, dynamic>{
          'title': 'Dal Tadka',
          'description': 'Comforting dal',
          'ingredients': '1 cup dal\nSalt',
          'instructions': 'Cook dal\nAdd tadka',
          'imageUrl': 'http://localhost:3000/uploads/images/dal.jpg',
          'prepTime': 10,
          'cookTime': 25,
          'servings': 3,
        });
        expect(
          createdRecipe.imageUrl,
          'http://localhost:3000/uploads/images/dal.jpg',
        );

        final updatedRecipe = await repository.updateRecipe(
          recipeId: 'recipe_2',
          draft: RecipeDraft(
            title: 'Dal Tadka Updated',
            description: '',
            ingredients: const <String>['1 cup dal', 'Salt', 'Ghee'],
            instructions: const <String>['Cook dal', 'Add tadka', 'Serve hot'],
            image: RecipeImageSelection.remote(
              'http://localhost:3000/uploads/images/dal.jpg',
            ),
            prepTimeMinutes: 12,
            cookTimeMinutes: 25,
            servings: 4,
          ),
        );

        expect(capturedUpdateBody, <String, dynamic>{
          'title': 'Dal Tadka Updated',
          'description': null,
          'ingredients': '1 cup dal\nSalt\nGhee',
          'instructions': 'Cook dal\nAdd tadka\nServe hot',
          'imageUrl': 'http://localhost:3000/uploads/images/dal.jpg',
          'prepTime': 12,
          'cookTime': 25,
          'servings': 4,
        });
        expect(updatedRecipe.title, 'Dal Tadka Updated');
        expect(updatedRecipe.description, '');
      },
    );
  });
}

typedef _GetHandler =
    Future<Object?> Function({
      required String path,
      Map<String, String>? queryParameters,
    });
typedef _WriteHandler =
    Future<Object?> Function({
      required String path,
      Map<String, dynamic>? body,
      required bool multipart,
    });

class _FakeApiClient implements ApiClient {
  _FakeApiClient({this.getHandler, this.postHandler, this.patchHandler});

  final _GetHandler? getHandler;
  final _WriteHandler? postHandler;
  final _WriteHandler? patchHandler;

  @override
  Future<void> delete(String path) async {}

  @override
  Future<Object?> get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    return getHandler?.call(path: path, queryParameters: queryParameters);
  }

  @override
  Future<Object?> patch(String path, {Map<String, dynamic>? body}) async {
    return patchHandler?.call(path: path, body: body, multipart: false);
  }

  @override
  Future<Object?> post(String path, {Map<String, dynamic>? body}) async {
    return postHandler?.call(path: path, body: body, multipart: false);
  }

  @override
  Future<Object?> postMultipart(
    String path, {
    required String fileField,
    required String filePath,
    Map<String, String>? fields,
  }) async {
    return postHandler?.call(
      path: path,
      body: <String, dynamic>{
        'fileField': fileField,
        'filePath': filePath,
        if (fields != null) ...fields,
      },
      multipart: true,
    );
  }
}
