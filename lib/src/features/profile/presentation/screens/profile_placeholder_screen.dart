import 'package:flutter/material.dart';

import '../../../../core/navigation/route_names.dart';
import '../../../../core/state/app_state_scope.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/buttons/app_secondary_button.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/stat_tile.dart';

class ProfilePlaceholderScreen extends StatefulWidget {
  const ProfilePlaceholderScreen({super.key});

  @override
  State<ProfilePlaceholderScreen> createState() =>
      _ProfilePlaceholderScreenState();
}

class _ProfilePlaceholderScreenState extends State<ProfilePlaceholderScreen> {
  bool _isLoggingOut = false;

  Future<void> _logout() async {
    if (_isLoggingOut) {
      return;
    }

    final appState = AppStateScope.read(context);
    final navigator = Navigator.of(context);

    setState(() => _isLoggingOut = true);
    await appState.logout();
    if (!mounted) {
      return;
    }
    navigator.pushNamedAndRemoveUntil(RouteNames.auth, (_) => false);
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).pushNamed(RouteNames.settings);
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.watch(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
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
                ProfileSummaryCard(
                  name: appState.user.name,
                  email: appState.user.email,
                ),
                const SizedBox(height: AppSpacing.md),
                StatTile(
                  label: 'Recipes saved',
                  value: '${appState.recipes.length}',
                ),
                const SizedBox(height: AppSpacing.md),
                _ProfileActionCard(onTap: _openSettings),
                const SizedBox(height: AppSpacing.xl),
                AppSecondaryButton(
                  label: _isLoggingOut ? 'Logging Out...' : 'Log Out',
                  leading: const Icon(Icons.logout_rounded),
                  onPressed: _isLoggingOut ? null : _logout,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileActionCard extends StatelessWidget {
  const _ProfileActionCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: <Widget>[
              Icon(Icons.settings_outlined),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Settings'),
                    SizedBox(height: AppSpacing.xxs),
                    Text('Account, privacy, and app information'),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
