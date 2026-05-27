import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../auth/auth_token_store.dart';
import 'api_client.dart';
import 'api_exception.dart';

class NestApiClient implements ApiClient {
  NestApiClient({
    required this.baseUrl,
    required AuthTokenStore authTokenStore,
    http.Client? httpClient,
    this.requestTimeout = const Duration(seconds: 12),
  }) : _authTokenStore = authTokenStore,
       _httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final AuthTokenStore _authTokenStore;
  final http.Client _httpClient;
  final Duration requestTimeout;

  @override
  Future<Object?> get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final response = await _runRequest(
      () async => _httpClient.get(
        _buildUri(path, queryParameters: queryParameters),
        headers: await _buildHeaders(),
      ),
    );
    return _decodeJson(response);
  }

  @override
  Future<Object?> post(String path, {Map<String, dynamic>? body}) async {
    final response = await _runRequest(
      () async => _httpClient.post(
        _buildUri(path),
        headers: await _buildHeaders(),
        body: jsonEncode(body ?? <String, dynamic>{}),
      ),
    );
    return _decodeJson(response);
  }

  @override
  Future<Object?> patch(String path, {Map<String, dynamic>? body}) async {
    final response = await _runRequest(
      () async => _httpClient.patch(
        _buildUri(path),
        headers: await _buildHeaders(),
        body: jsonEncode(body ?? <String, dynamic>{}),
      ),
    );
    return _decodeJson(response);
  }

  @override
  Future<Object?> postMultipart(
    String path, {
    required String fileField,
    required String filePath,
    Map<String, String>? fields,
  }) async {
    final response = await _runRequest(() async {
      final request = http.MultipartRequest('POST', _buildUri(path));
      request.headers.addAll(
        await _buildHeaders(includeJsonContentType: false),
      );
      if (fields != null && fields.isNotEmpty) {
        request.fields.addAll(fields);
      }
      request.files.add(await http.MultipartFile.fromPath(fileField, filePath));

      final streamedResponse = await _httpClient.send(request);
      return http.Response.fromStream(streamedResponse);
    });
    return _decodeJson(response);
  }

  @override
  Future<void> delete(String path) async {
    final response = await _runRequest(
      () async =>
          _httpClient.delete(_buildUri(path), headers: await _buildHeaders()),
    );
    _guardResponse(response);
  }

  Future<http.Response> _runRequest(
    Future<http.Response> Function() request,
  ) async {
    try {
      return await request().timeout(requestTimeout);
    } on TimeoutException {
      throw ApiException(
        message: 'The server took too long to respond. Please try again.',
        isTimeout: true,
      );
    } on http.ClientException {
      throw ApiException(
        message:
            'We could not reach the server. Check your connection and API base URL.',
        isConnectivityIssue: true,
      );
    } catch (error) {
      final text = error.toString();
      if (text.contains('SocketException')) {
        throw ApiException(
          message:
              'We could not reach the server. Check your connection and API base URL.',
          isConnectivityIssue: true,
        );
      }
      rethrow;
    }
  }

  Uri _buildUri(String path, {Map<String, String>? queryParameters}) {
    final normalizedBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse(
      '$normalizedBase$normalizedPath',
    ).replace(queryParameters: queryParameters);
  }

  Future<Map<String, String>> _buildHeaders({
    bool includeJsonContentType = true,
  }) async {
    final token = await _authTokenStore.readToken();
    return <String, String>{
      if (includeJsonContentType) 'Content-Type': 'application/json',
      'Accept': 'application/json',
      if ((token ?? '').trim().isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Object? _decodeJson(http.Response response) {
    _guardResponse(response);
    if (response.body.trim().isEmpty) {
      return null;
    }

    try {
      return jsonDecode(response.body);
    } on FormatException {
      throw ApiException(
        message: 'The server returned an invalid response.',
        statusCode: response.statusCode,
        body: response.body,
      );
    }
  }

  Never _throwApiException(http.Response response) {
    final decodedBody = _tryDecodeJson(response.body);
    final backendMessage = _extractBackendMessage(decodedBody);
    final mappedMessage = switch (response.statusCode) {
      400 => backendMessage ?? 'The request could not be completed.',
      401 => backendMessage ?? 'Your session has expired. Please log in again.',
      403 => backendMessage ?? 'You do not have permission to do that.',
      404 => backendMessage ?? 'The requested item was not found.',
      409 => backendMessage ?? 'That account already exists.',
      500 => 'The server hit an error. Please try again.',
      _ =>
        backendMessage ?? 'Request failed with status ${response.statusCode}.',
    };

    throw ApiException(
      message: mappedMessage,
      statusCode: response.statusCode,
      body: response.body,
    );
  }

  Object? _tryDecodeJson(String body) {
    if (body.trim().isEmpty) {
      return null;
    }

    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }

  String? _extractBackendMessage(Object? decodedBody) {
    if (decodedBody is! Map<String, dynamic>) {
      return null;
    }

    final message = decodedBody['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }

    if (message is List) {
      final messages = message
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
      if (messages.isNotEmpty) {
        return messages.join('\n');
      }
    }

    return null;
  }

  void _guardResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    _throwApiException(response);
  }
}
