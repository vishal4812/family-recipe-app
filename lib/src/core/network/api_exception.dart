class ApiException implements Exception {
  ApiException({
    required this.message,
    this.statusCode,
    this.body,
    this.isConnectivityIssue = false,
    this.isTimeout = false,
  });

  final String message;
  final int? statusCode;
  final String? body;
  final bool isConnectivityIssue;
  final bool isTimeout;

  @override
  String toString() {
    return message;
  }
}
