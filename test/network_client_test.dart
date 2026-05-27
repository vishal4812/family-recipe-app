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
  });
}
