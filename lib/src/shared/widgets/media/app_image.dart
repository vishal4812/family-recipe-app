import 'package:flutter/material.dart';

import 'app_local_image_provider.dart'
    if (dart.library.io) 'app_local_image_provider_io.dart'
    if (dart.library.html) 'app_local_image_provider_web.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    this.imageUrl,
    this.imagePath,
    this.fit = BoxFit.cover,
    this.errorBuilder,
  });

  final String? imageUrl;
  final String? imagePath;
  final BoxFit fit;
  final WidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    final provider = _resolveImageProvider();
    if (provider == null) {
      return _buildError(context);
    }

    return Image(
      image: provider,
      fit: fit,
      errorBuilder: (_, __, ___) => _buildError(context),
    );
  }

  ImageProvider<Object>? _resolveImageProvider() {
    final trimmedPath = imagePath?.trim() ?? '';
    if (trimmedPath.isNotEmpty) {
      return buildLocalImageProvider(trimmedPath);
    }

    final trimmedUrl = imageUrl?.trim() ?? '';
    if (trimmedUrl.isNotEmpty) {
      return NetworkImage(trimmedUrl);
    }

    return null;
  }

  Widget _buildError(BuildContext context) {
    if (errorBuilder != null) {
      return errorBuilder!(context);
    }
    return const SizedBox.shrink();
  }
}
