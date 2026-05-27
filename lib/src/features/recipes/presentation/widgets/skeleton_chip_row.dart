import 'package:flutter/material.dart';

import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/state/skeleton_block.dart';

class SkeletonChipRow extends StatelessWidget {
  const SkeletonChipRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: <Widget>[
        SkeletonBlock(height: 32, width: 96, borderRadius: AppRadii.radius28),
        SkeletonBlock(height: 32, width: 96, borderRadius: AppRadii.radius28),
        SkeletonBlock(height: 32, width: 82, borderRadius: AppRadii.radius28),
      ],
    );
  }
}
