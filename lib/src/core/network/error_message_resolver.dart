import 'api_exception.dart';

String resolveErrorMessage(Object error, {required String fallbackMessage}) {
  if (error is ApiException) {
    final message = error.message.trim();
    if (message.isNotEmpty) {
      return message;
    }
  }

  final genericMessage = error.toString().trim();
  if (genericMessage.isNotEmpty && genericMessage != 'Exception') {
    const prefix = 'Exception: ';
    if (genericMessage.startsWith(prefix)) {
      return genericMessage.substring(prefix.length).trim();
    }
    return genericMessage;
  }

  return fallbackMessage;
}
