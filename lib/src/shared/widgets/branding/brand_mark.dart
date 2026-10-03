import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.menu_book_rounded,
        size: size * 0.48,
        color: AppColors.onPrimary,
      ),
    );
  }
}
