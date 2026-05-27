import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class StatusView extends StatelessWidget {
  const StatusView({
    super.key,
    required this.title,
    required this.message,
    this.illustration,
    this.icon,
    this.primaryAction,
    this.secondaryAction,
  });

  final Widget? illustration;
  final IconData? icon;
  final String title;
  final String message;
  final Widget? primaryAction;
  final Widget? secondaryAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            illustration ??
                Container(
                  width: AppDimensions.emptyGraphicSize,
                  height: AppDimensions.emptyGraphicSize,
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: AppRadii.radius28,
                    border: Border.all(color: AppColors.border),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    icon ?? Icons.restaurant_menu_rounded,
                    size: 40,
                    color: AppColors.primaryDark,
                  ),
                ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTypography.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
            if (primaryAction != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              primaryAction!,
            ],
            if (secondaryAction != null) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              secondaryAction!,
            ],
          ],
        ),
      ),
    );
  }
}
