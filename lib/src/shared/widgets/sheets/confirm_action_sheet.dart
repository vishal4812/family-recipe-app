import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../buttons/app_primary_button.dart';
import '../buttons/app_secondary_button.dart';

class ConfirmActionSheet extends StatefulWidget {
  const ConfirmActionSheet({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmLabel = 'Delete',
    this.cancelLabel = 'Cancel',
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required FutureOr<void> Function() onConfirm,
    String confirmLabel = 'Delete',
    String cancelLabel = 'Cancel',
  }) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) {
        return ConfirmActionSheet(
          title: title,
          message: message,
          onConfirm: onConfirm,
          confirmLabel: confirmLabel,
          cancelLabel: cancelLabel,
        );
      },
    );
  }

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final FutureOr<void> Function() onConfirm;

  @override
  State<ConfirmActionSheet> createState() => _ConfirmActionSheetState();
}

class _ConfirmActionSheetState extends State<ConfirmActionSheet> {
  bool _isConfirming = false;

  Future<void> _handleConfirm() async {
    if (_isConfirming) {
      return;
    }

    setState(() => _isConfirming = true);
    Navigator.of(context).pop();
    await Future<void>.sync(widget.onConfirm);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.title, style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(widget.message, style: AppTypography.bodySmall),
          const SizedBox(height: AppSpacing.xl),
          AppPrimaryButton(
            label: widget.confirmLabel,
            isLoading: _isConfirming,
            onPressed: _isConfirming ? null : _handleConfirm,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppSecondaryButton(
            label: widget.cancelLabel,
            onPressed: _isConfirming ? null : () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
