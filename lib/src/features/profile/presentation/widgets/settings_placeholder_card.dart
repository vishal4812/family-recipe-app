import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class SettingsPlaceholderCard extends StatelessWidget {
  const SettingsPlaceholderCard({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.radius16,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.low,
      ),
      child: Column(
        children: List<Widget>.generate(items.length, (int index) {
          final isLast = index == items.length - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.md),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(items[index], style: AppTypography.bodyMedium),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
