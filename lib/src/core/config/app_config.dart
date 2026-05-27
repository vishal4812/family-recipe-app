import 'package:flutter/foundation.dart';

abstract final class AppConfig {
  static const String _apiBaseUrlFromEnvironment = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );
  static const bool enableSamplePhotoOptions = bool.fromEnvironment(
    'ENABLE_SAMPLE_PHOTOS',
    defaultValue: false,
  );

  static String get apiBaseUrl {
    final configuredBaseUrl = _apiBaseUrlFromEnvironment.trim();
    if (configuredBaseUrl.isNotEmpty) {
      return _validateConfiguredApiBaseUrl(configuredBaseUrl);
    }

    if (kReleaseMode) {
      throw StateError(
        'API_BASE_URL must be provided for release builds and must use HTTPS.',
      );
    }

    if (kIsWeb) {
      return 'http://localhost:3000';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:3000';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return 'http://localhost:3000';
      case TargetPlatform.fuchsia:
        return 'http://127.0.0.1:3000';
    }
  }

  static String _validateConfiguredApiBaseUrl(String apiBaseUrl) {
    final uri = Uri.tryParse(apiBaseUrl);
    if (uri == null || !uri.hasScheme || (uri.host).trim().isEmpty) {
      throw StateError('API_BASE_URL must be a valid absolute URL.');
    }

    if (kReleaseMode && uri.scheme != 'https') {
      throw StateError('API_BASE_URL must use HTTPS in release builds.');
    }

    return apiBaseUrl;
  }
}
