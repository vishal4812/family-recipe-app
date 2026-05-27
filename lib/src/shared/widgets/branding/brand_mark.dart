import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: AppRadii.radius20,
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(
        Icons.menu_book_rounded,
        size: size * 0.48,
        color: AppColors.primaryDark,
      ),
    );
  }
}
