import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/databases/cache_helper.dart';
import '../../../../core/databases/secure_storage_helper.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/deep_link_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../setup/data/datasources/profile_remote_data_source.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _glowAnimation = Tween<double>(begin: 20.0, end: 50.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
      ),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.95, curve: Curves.easeInOutCubic),
      ),
    );

    _controller.forward().then((_) {
      _navigateNext();
    });
  }

  Future<void> _navigateNext() async {
    if (!mounted) return;

    // Check if a deep link was clicked while launching
    final deepLinkService = sl<DeepLinkService>();
    if (deepLinkService.pendingResetCredentials != null) {
      final creds = deepLinkService.pendingResetCredentials!;
      deepLinkService.pendingResetCredentials = null;
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.setNewPassword,
        arguments: creds,
      );
      return;
    }

    final secureStorage = sl<SecureStorageHelper>();
    final token = await secureStorage.getAccessToken();
    final isFirstLaunch =
        CacheHelper.getData(key: AppConstants.isFirstTimeLaunch) ?? true;

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      try {
        final status =
            await sl<ProfileRemoteDataSource>().getOnboardingStatus();
        if (!mounted) return;

        if (status.isOnboardingCompleted) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
          return;
        } else if (status.hasSelectedTrack) {
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.setupProfile,
            arguments: {'trackTitle': status.selectedTrackName},
          );
          return;
        } else if (status.hasAcceptedTerms) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.setupTracks);
          return;
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.setupTerms);
          return;
        }
      } catch (_) {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        return;
      }
    }

    if (isFirstLaunch) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.auth);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ambient Glassmorphism Background Glow
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.18),
                        blurRadius: _glowAnimation.value + 60,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Central Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                // Animated Terminal Icon Card
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.border,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.35),
                              blurRadius: _glowAnimation.value,
                              spreadRadius: -2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: AppStrings.appBrandTerminal,
                                  style: TextStyle(
                                    fontFamily: 'JetBrains Mono',
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                    letterSpacing: -1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // SkillPilot Brand Title
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: const Text(
                      AppStrings.appName,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Tagline
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    AppStrings.appTagline,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // Sleek Linear Progress Bar
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      width: 140,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceCard,
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(color: AppColors.border, width: 0.5),
                      ),
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: _progressAnimation.value.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primaryDark,
                                AppColors.primary,
                                AppColors.primaryLight,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.6),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Version text
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    '${AppStrings.splashVersionPrefix}${AppConstants.appVersion}',
                    style: AppTextStyles.code.copyWith(
                      color: AppColors.textSecondary.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
