import 'package:flutter/material.dart';

import '../../../../shared/widgets/buttons/app_primary_button.dart';
import '../../../../shared/widgets/buttons/app_text_button.dart';
import '../../../../shared/widgets/state/status_view.dart';

class RecipeErrorState extends StatelessWidget {
  const RecipeErrorState({
    super.key,
    required this.onRetry,
    this.onGoBack,
    this.title = 'Something went wrong',
    this.message =
        'We couldn\'t load your recipes right now. Please try again.',
  });

  final VoidCallback onRetry;
  final VoidCallback? onGoBack;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return StatusView(
      icon: Icons.error_outline_rounded,
      title: title,
      message: message,
      primaryAction: AppPrimaryButton(label: 'Try Again', onPressed: onRetry),
      secondaryAction: onGoBack == null
          ? null
          : AppTextButton(label: 'Go Back', onPressed: onGoBack),
    );
  }
}
