import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_typography.dart';

InputDecoration buildAppInputDecoration({
  required String hintText,
  String? helperText,
  Widget? prefixIcon,
  Widget? suffixIcon,
}) {
  OutlineInputBorder border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: AppRadii.radius14,
      borderSide: BorderSide(color: color, width: width),
    );
  }

  return InputDecoration(
    hintText: hintText,
    hintStyle: AppTypography.bodyMedium.copyWith(
      color: AppColors.textSecondary,
    ),
    helperText: helperText,
    helperStyle: AppTypography.caption,
    filled: true,
    fillColor: AppColors.surface,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    enabledBorder: border(AppColors.border),
    focusedBorder: border(AppColors.primary, width: 1.5),
    errorBorder: border(AppColors.error),
    focusedErrorBorder: border(AppColors.error, width: 1.5),
    disabledBorder: border(AppColors.border),
  );
}
