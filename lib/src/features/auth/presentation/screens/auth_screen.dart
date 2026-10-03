import 'package:flutter/material.dart';

import '../../../../core/navigation/route_names.dart';
import '../../../../core/network/error_message_resolver.dart';
import '../../../../core/state/app_state_scope.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/branding/brand_mark.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  String? _validateFullName(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return 'Please enter your name';
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
      _formKey = GlobalKey<FormState>();
      _authError = null;
      _didReadPendingAuthMessage = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackdrop,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 360),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadii.radius20,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Center(
                          child: BrandMark(size: AppDimensions.authLogoBox),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          _isSignup ? 'Create your cookbook' : 'Welcome back',
                          style: AppTypography.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _isSignup
                              ? 'Start saving the recipes your family loves.'
                              : 'Sign in to your family cookbook.',
                          style: AppTypography.caption,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        const _AuthDivider(),
                        const SizedBox(height: AppSpacing.lg),
                        if (_isSignup) ...<Widget>[
                          AppTextField(
                            label: 'Full name',
                            controller: _nameController,
                            hintText: 'Your name',
                            textInputAction: TextInputAction.next,
                            validator: _validateFullName,
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                        AppTextField(
                          label: 'Email',
                          controller: _emailController,
                          hintText: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          label: 'Password',
                          controller: _passwordController,
                          hintText: 'Enter your password',
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          validator: _validatePassword,
                          suffixIcon: const Icon(Icons.visibility_off_outlined),
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
                        SizedBox(
                          height: 48,
                          child: FilledButton(
                            onPressed: _isSubmitting ? null : _submit,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.authAction,
                              disabledBackgroundColor: AppColors.disabled,
                              foregroundColor: AppColors.authBackdrop,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadii.radius28,
                              ),
                              textStyle: AppTypography.buttonSmall,
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.authBackdrop,
                                    ),
                                  )
                                : Text(_isSignup ? 'Sign up' : 'Log in'),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextButton(
                          onPressed: () => _setMode(!_isSignup),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.authActionDark,
                            textStyle: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: Text(
                            _isSignup
                                ? 'Already have an account? Log in'
                                : 'New here? Create an account',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthDivider extends StatelessWidget {
  const _AuthDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text('YOUR FAMILY RECIPES', style: AppTypography.caption),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
