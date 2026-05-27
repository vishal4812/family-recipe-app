import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'app_input_decoration.dart';

class AppMultilineField extends StatelessWidget {
  const AppMultilineField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.validator,
    this.helperText,
    this.minLines = 5,
    this.maxLines = 8,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final String? helperText;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.xs),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppDimensions.multilineMinHeight,
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: TextInputType.multiline,
            minLines: minLines,
            maxLines: maxLines,
            textInputAction: TextInputAction.newline,
            style: AppTypography.bodyMedium,
            decoration: buildAppInputDecoration(
              hintText: hintText ?? label,
              helperText: helperText,
            ),
          ),
        ),
      ],
    );
  }
}
