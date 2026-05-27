import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';

class SkeletonBlock extends StatelessWidget {
  const SkeletonBlock({
    super.key,
    this.height,
    this.width,
    this.borderRadius = AppRadii.radius12,
  });

  final double? height;
  final double? width;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.skeleton,
        borderRadius: borderRadius,
      ),
    );
  }
}
