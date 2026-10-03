import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/branding/brand_mark.dart';

class SplashAuthCheckScreen extends StatelessWidget {
  const SplashAuthCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackdrop,
      body: SafeArea(
        child: Center(
          child: Container(
            width: 184,
            height: 300,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xFFFF9AB2), Color(0xFFFFCCA4)],
              ),
              borderRadius: AppRadii.radius20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const BrandMark(size: AppDimensions.splashLogoBox),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Family Recipe',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.authBackdrop,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: AppColors.authBackdrop,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
