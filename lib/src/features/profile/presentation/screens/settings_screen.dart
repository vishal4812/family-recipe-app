import 'package:flutter/material.dart';

import '../../../../core/state/app_state_scope.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showInfo(BuildContext context, String title, String message) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.watch(context);
    final user = appState.user;
    final recipeCount = appState.recipes.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.maxContentWidth,
            ),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: <Widget>[
                const _SettingsSectionLabel('Account'),
                _SettingsCard(
                  children: <Widget>[
                    _SettingsTile(
                      icon: Icons.person_outline_rounded,
                      title: 'Profile',
                      subtitle: user.name,
                      onTap: () => _showInfo(
                        context,
                        'Your profile',
                        'Name: ${user.name}\nEmail: ${user.email}',
                      ),
                    ),
                    const Divider(height: 1),
                    _SettingsTile(
                      icon: Icons.restaurant_menu_rounded,
                      title: 'Family cookbook',
                      subtitle:
                          '$recipeCount ${recipeCount == 1 ? 'recipe' : 'recipes'} saved',
                      onTap: () => _showInfo(
                        context,
                        'Family cookbook',
                        'Every recipe you save is private to your account and available from your recipe list.',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                const _SettingsSectionLabel('Privacy and help'),
                _SettingsCard(
                  children: <Widget>[
                    _SettingsTile(
                      icon: Icons.lock_outline_rounded,
                      title: 'Recipe privacy',
                      subtitle: 'Your recipes are private to your account',
                      onTap: () => _showInfo(
                        context,
                        'Recipe privacy',
                        'Only your signed-in account can view, edit, or delete the recipes you save.',
                      ),
                    ),
                    const Divider(height: 1),
                    _SettingsTile(
                      icon: Icons.help_outline_rounded,
                      title: 'Using Family Recipe',
                      subtitle: 'Create, search, and keep family recipes close',
                      onTap: () => _showInfo(
                        context,
                        'Using Family Recipe',
                        'Tap Add Recipe to save a dish. Add one ingredient and instruction per line, then search by recipe title whenever you need it.',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                const _SettingsSectionLabel('About'),
                _SettingsCard(
                  children: <Widget>[
                    _SettingsTile(
                      icon: Icons.info_outline_rounded,
                      title: 'Family Recipe',
                      subtitle: 'Version 1.0.0',
                      onTap: () => _showInfo(
                        context,
                        'Family Recipe',
                        'A simple home for the dishes and stories your family wants to keep.',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsSectionLabel extends StatelessWidget {
  const _SettingsSectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        bottom: AppSpacing.sm,
      ),
      child: Text(label, style: AppTypography.caption),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.radius16,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.low,
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.radius16,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: <Widget>[
            Icon(icon, color: AppColors.primaryDark),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: AppTypography.bodyMedium),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(subtitle, style: AppTypography.bodySmall),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
