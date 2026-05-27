import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';

class AddRecipeFab extends StatelessWidget {
  const AddRecipeFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadii.radius20,
        boxShadow: AppShadows.medium,
      ),
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.radius20),
        icon: const Icon(Icons.add_rounded, size: AppDimensions.fabIconSize),
        label: Text(
          'Add Recipe',
          style: AppTypography.buttonLarge.copyWith(color: AppColors.onPrimary),
        ),
      ),
    );
  }
}
