import 'package:flutter/material.dart';

import '../../../../core/navigation/route_names.dart';
import '../../../../core/network/error_message_resolver.dart';
import '../../../../core/state/app_state_scope.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/branding/brand_mark.dart';
import '../../../../shared/widgets/buttons/app_primary_button.dart';
import '../../../../shared/widgets/buttons/app_text_button.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';
import '../widgets/auth_mode_toggle.dart';
import '../widgets/form_surface_card.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(
    text: 'demo@familyrecipe.app',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: 'Password123!',
  );

  bool _isSignup = false;
  bool _isSubmitting = false;
  String? _authError;
  bool _didReadPendingAuthMessage = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didReadPendingAuthMessage) {
      return;
    }

    _didReadPendingAuthMessage = true;
    final pendingMessage = AppStateScope.read(
      context,
    ).consumePendingAuthMessage();
    if ((pendingMessage ?? '').trim().isNotEmpty) {
      _authError = pendingMessage;
    }
  }

  String? _validateEmail(String? value) {
    final input = (value ?? '').trim();
    if (input.isEmpty) {
      return 'Please enter your email';
    }
    if (!input.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final input = (value ?? '').trim();
    if (input.isEmpty) {
      return 'Please enter your password';
    }
    if (input.length < 6) {
      return 'Password should be at least 6 characters';
    }
    return null;
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _authError = null;
    });

    try {
      final appState = AppStateScope.read(context);
      await appState.authenticate(
        email: _emailController.text,
        password: _passwordController.text,
        isSignup: _isSignup,
        fullName: _isSignup ? _nameController.text : null,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacementNamed(RouteNames.home);
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _authError = resolveErrorMessage(
          error,
          fallbackMessage: _isSignup
              ? 'We could not create your account right now.'
              : 'We could not sign you in right now.',
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _setMode(bool isSignup) {
    setState(() {
      _isSignup = isSignup;
      _authError = null;
      _didReadPendingAuthMessage = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const BrandMark(size: AppDimensions.authLogoBox),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Keep your family recipes close',
                      style: AppTypography.displayLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Save the dishes you grew up with, one recipe at a time.',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    AuthModeToggle(isSignup: _isSignup, onChanged: _setMode),
                    const SizedBox(height: AppSpacing.md),
                    FormSurfaceCard(
                      child: Column(
                        children: <Widget>[
                          if (_isSignup) ...<Widget>[
                            AppTextField(
                              label: 'Full name',
                              controller: _nameController,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: AppSpacing.md),
                          ],
                          AppTextField(
                            label: 'Email',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            label: 'Password',
                            controller: _passwordController,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            validator: _validatePassword,
                          ),
                        ],
                      ),
                    ),
                    if (_authError != null) ...<Widget>[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        _authError!,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    AppPrimaryButton(
                      label: 'Continue',
                      isLoading: _isSubmitting,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Center(
                      child: AppTextButton(
                        label: _isSignup
                            ? 'Already have an account? Log in'
                            : 'New here? Create an account',
                        onPressed: () => _setMode(!_isSignup),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
