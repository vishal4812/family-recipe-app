import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class ProfileSummaryCard extends StatelessWidget {
  const ProfileSummaryCard({
    super.key,
    required this.name,
    required this.email,
  });

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? 'F' : name.trim()[0].toUpperCase();
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.radius16,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.low,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: AppDimensions.avatarSize,
            height: AppDimensions.avatarSize,
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: AppRadii.radius20,
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(name, style: AppTypography.bodyLarge),
                const SizedBox(height: AppSpacing.xxs),
                Text(email, style: AppTypography.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
