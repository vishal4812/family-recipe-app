import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class HomeHeaderBlock extends StatelessWidget {
  const HomeHeaderBlock({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(eyebrow, style: AppTypography.bodySmall),
        const SizedBox(height: AppSpacing.xs),
        Text(title, style: AppTypography.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(subtitle, style: AppTypography.bodySmall),
      ],
    );
  }
}
