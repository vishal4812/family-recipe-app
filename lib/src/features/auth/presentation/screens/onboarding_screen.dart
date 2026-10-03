import 'package:flutter/material.dart';

import '../../../../core/navigation/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/branding/brand_mark.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  static const List<_OnboardingPageData> _pages = <_OnboardingPageData>[
    _OnboardingPageData(
      title: 'Recipes from all over your family',
      subtitle: 'Keep every favourite dish, story, and tradition in one place.',
      overlayColor: Color(0xA51D120C),
    ),
    _OnboardingPageData(
      title: 'Every recipe has a story',
      subtitle:
          'Save the little notes that make a family recipe unforgettable.',
      overlayColor: Color(0xAD24100A),
    ),
    _OnboardingPageData(
      title: 'Cook now or save it for later',
      subtitle: 'Your family cookbook is ready whenever you are.',
      overlayColor: Color(0x961B2B20),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_pageIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    Navigator.of(context).pushReplacementNamed(RouteNames.auth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackdrop,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ClipRRect(
                borderRadius: AppRadii.radius20,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    PageView.builder(
                      controller: _pageController,
                      itemCount: _pages.length,
                      onPageChanged: (index) =>
                          setState(() => _pageIndex = index),
                      itemBuilder: (context, index) {
                        final page = _pages[index];
                        return Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/family-table-onboarding.png',
                              fit: BoxFit.cover,
                              alignment: Alignment(
                                index == 0
                                    ? 0
                                    : index == 1
                                    ? -0.35
                                    : 0.4,
                                0,
                              ),
                            ),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: page.overlayColor,
                              ),
                            ),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                    Colors.black.withValues(alpha: 0.12),
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.72),
                                  ],
                                  stops: const <double>[0, 0.38, 1],
                                ),
                              ),
                            ),
                            _OnboardingCopy(page: page),
                          ],
                        );
                      },
                    ),
                    Positioned(
                      top: AppSpacing.lg,
                      left: 0,
                      right: 0,
                      child: const Center(child: BrandMark(size: 60)),
                    ),
                    Positioned(
                      top: AppSpacing.md,
                      right: AppSpacing.md,
                      child: TextButton(
                        onPressed: () => Navigator.of(
                          context,
                        ).pushReplacementNamed(RouteNames.auth),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Skip'),
                      ),
                    ),
                    Positioned(
                      left: AppSpacing.lg,
                      right: AppSpacing.lg,
                      bottom: AppSpacing.lg,
                      child: _OnboardingFooter(
                        selectedIndex: _pageIndex,
                        count: _pages.length,
                        onPressed: _continue,
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

class _OnboardingCopy extends StatelessWidget {
  const _OnboardingCopy({required this.page});

  final _OnboardingPageData page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 132),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              page.title,
              style: AppTypography.displayLarge.copyWith(
                color: Colors.white,
                height: 1.1,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              page.subtitle,
              style: AppTypography.bodyMedium.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingFooter extends StatelessWidget {
  const _OnboardingFooter({
    required this.selectedIndex,
    required this.count,
    required this.onPressed,
  });

  final int selectedIndex;
  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(
            count,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: index == selectedIndex ? 24 : 10,
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: index == selectedIndex
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.55),
                borderRadius: AppRadii.radius28,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.authAction,
              foregroundColor: AppColors.authBackdrop,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.radius28),
              textStyle: AppTypography.buttonSmall,
            ),
            child: Text(
              selectedIndex == count - 1 ? 'Start your cookbook' : 'Continue',
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.overlayColor,
  });

  final String title;
  final String subtitle;
  final Color overlayColor;
}
