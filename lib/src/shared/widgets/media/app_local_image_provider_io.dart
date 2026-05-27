import 'dart:io';

import 'package:flutter/widgets.dart';

ImageProvider<Object>? buildLocalImageProvider(String path) {
  return FileImage(File(path));
}
