import 'package:flutter/widgets.dart';

ImageProvider<Object>? buildLocalImageProvider(String path) {
  return NetworkImage(path);
}
