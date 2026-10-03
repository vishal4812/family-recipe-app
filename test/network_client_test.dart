import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:family_recipe_app/src/core/auth/memory_auth_token_store.dart';
import 'package:family_recipe_app/src/core/network/api_exception.dart';
import 'package:family_recipe_app/src/core/network/nest_api_client.dart';

void main() {
  group('NestApiClient hardening', () {
    test('maps request timeout to a friendly ApiException', () async {
      final client = NestApiClient(
        baseUrl: 'http://localhost:3000',
        authTokenStore: MemoryAuthTokenStore(),
        requestTimeout: const Duration(milliseconds: 10),
        httpClient: MockClient((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 40));
          return http.Response('{}', 200);
        }),
      );

      await expectLater(
        () => client.get('/users/me'),
        throwsA(
          isA<ApiException>()
              .having((error) => error.isTimeout, 'isTimeout', isTrue)
              .having(
                (error) => error.message,
                'message',
                'The server took too long to respond. Please try again.',
              ),
        ),
      );
    });

    test('maps unreachable server errors to a friendly ApiException', () async {
      final client = NestApiClient(
        baseUrl: 'http://localhost:3000',
        authTokenStore: MemoryAuthTokenStore(),
        httpClient: MockClient((_) async {
          throw http.ClientException('Connection refused');
        }),
      );

      await expectLater(
        () => client.get('/users/me'),
        throwsA(
          isA<ApiException>()
              .having(
                (error) => error.isConnectivityIssue,
                'isConnectivityIssue',
                isTrue,
              )
              .having(
                (error) => error.message,
                'message',
                'We could not reach the server. Check your connection and API base URL.',
              ),
        ),
      );
    });

    test('sends selected PNG files with an image MIME type', () async {
      final temporaryDirectory = await Directory.systemTemp.createTemp(
        'family-recipe-multipart-',
      );
      addTearDown(() => temporaryDirectory.delete(recursive: true));
      final imageFile = File('${temporaryDirectory.path}/recipe.png');
      await imageFile.writeAsBytes(<int>[137, 80, 78, 71]);

      final client = NestApiClient(
        baseUrl: 'http://localhost:3000',
        authTokenStore: MemoryAuthTokenStore(initialToken: 'jwt-token'),
        httpClient: MockClient((request) async {
          final requestBody = latin1.decode(request.bodyBytes);
          expect(request.method, 'POST');
          expect(request.url.path, '/uploads/image');
          expect(request.headers['authorization'], 'Bearer jwt-token');
          expect(
            request.headers['content-type'],
            startsWith('multipart/form-data; boundary='),
          );
          expect(requestBody, contains('content-type: image/png'));
          expect(requestBody, contains('name="file"'));
          return http.Response(
            '{"url":"http://localhost:3000/upload.png"}',
            201,
          );
        }),
      );

      final response = await client.postMultipart(
        '/uploads/image',
        fileField: 'file',
        filePath: imageFile.path,
      );

      expect(response, <String, dynamic>{
        'url': 'http://localhost:3000/upload.png',
      });
    });
  });
}
