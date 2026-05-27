import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_spacing.dart';

class StickyActionBar extends StatelessWidget {
  const StickyActionBar({
    super.key,
    required this.child,
    this.showTopBorder = true,
  });

  final Widget child;
  final bool showTopBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: AppDimensions.stickyActionBarMinHeight,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: showTopBorder
            ? const Border(
                top: BorderSide(
                  color: AppColors.border,
                  width: AppDimensions.dividerThickness,
                ),
              )
            : null,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: child,
        ),
      ),
    );
  }
}
