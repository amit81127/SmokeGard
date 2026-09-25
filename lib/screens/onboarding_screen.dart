import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _slides = [
    const OnboardingData(
      title: 'Stay Aware of Smoke Exposure',
      subtitle:
          'Continuous real-time air quality & smoke particulate monitoring in public spaces, transport hubs, and outdoor corridors.',
      icon: Icons.air_rounded,
      badge: 'MONITORING',
    ),
    const OnboardingData(
      title: 'Get Instant Alerts',
      subtitle:
          'Receive instant haptic and audio warning notifications on your smartphone & wearable band the moment VOCs or PM2.5 spike.',
      icon: Icons.notifications_active_outlined,
      badge: 'REAL-TIME ALERTS',
    ),
    const OnboardingData(
      title: 'Track Your Exposure',
      subtitle:
          'Deep analytics, PSEI risk index calculations, and personalized AI recommendations to protect your respiratory health.',
      icon: Icons.insights_rounded,
      badge: 'PSEI INDEXING',
    ),
  ];

  void _finish() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, anim, secAnim) => const AuthScreen(),
        transitionsBuilder: (context, anim, secAnim, child) {
          return FadeTransition(opacity: anim, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // Top Header: Logo Brand & Skip Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.shield_outlined,
                              size: 16,
                              color: isDark ? AppColors.pureBlack : AppColors.pureWhite,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'SMOKEGUARD',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _finish,
                        child: Text(
                          _currentPage == _slides.length - 1 ? '' : 'Skip',
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Page Carousel (Flexible to prevent any overflow on any screen size)
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _slides.length,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemBuilder: (context, index) {
                      final item = _slides[index];
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 12),
                            // Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkCard : AppColors.lightCardElevated,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                ),
                              ),
                              child: Text(
                                item.badge,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Minimalist High-Contrast Graphic Icon Container
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark ? AppColors.darkCard : AppColors.pureWhite,
                                border: Border.all(
                                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isDark ? Colors.black : Colors.black12).withValues(alpha: 0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  item.icon,
                                  size: 64,
                                  color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Title
                            Text(
                              item.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.4,
                                color: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Subtitle
                            Text(
                              item.subtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Dots & High Contrast CTA Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Smooth Indicator Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_slides.length, (index) {
                          final isActive = index == _currentPage;
                          return GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 240),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 6,
                              width: isActive ? 32 : 6,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? (isDark ? AppColors.pureWhite : AppColors.pureBlack)
                                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),

                      // High Contrast Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentPage < _slides.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              _finish();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? AppColors.pureWhite : AppColors.pureBlack,
                            foregroundColor: isDark ? AppColors.pureBlack : AppColors.pureWhite,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _currentPage == _slides.length - 1 ? 'Get Started' : 'Continue',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppColors.pureBlack : AppColors.pureWhite,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                _currentPage == _slides.length - 1
                                    ? Icons.arrow_forward_rounded
                                    : Icons.chevron_right_rounded,
                                size: 18,
                                color: isDark ? AppColors.pureBlack : AppColors.pureWhite,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final IconData icon;
  final String badge;

  const OnboardingData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.badge,
  });
}
