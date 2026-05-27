abstract interface class ApiClient {
  Future<Object?> get(String path, {Map<String, String>? queryParameters});

  Future<Object?> post(String path, {Map<String, dynamic>? body});

  Future<Object?> patch(String path, {Map<String, dynamic>? body});

  Future<Object?> postMultipart(
    String path, {
    required String fileField,
    required String filePath,
    Map<String, String>? fields,
  });

  Future<void> delete(String path);
}
