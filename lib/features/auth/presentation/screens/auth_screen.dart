import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/databases/cache_helper.dart';
import '../../../../core/databases/secure_storage_helper.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_strings.dart';
import '../../data/services/oauth_service.dart';
import '../../../setup/data/datasources/profile_remote_data_source.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_brand_logo.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/auth_segment_tab.dart';
import '../widgets/social_auth_row.dart';

class AuthScreen extends StatefulWidget {
  final bool initialIsSignIn;

  const AuthScreen({
    super.key,
    this.initialIsSignIn = true,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool _isSignIn;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _rememberMe = true;

  @override
  void initState() {
    super.initState();
    _isSignIn = widget.initialIsSignIn;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onToggleTab(bool isSignIn) {
    if (_isSignIn != isSignIn) {
      setState(() {
        _isSignIn = isSignIn;
      });
    }
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      sl<SecureStorageHelper>().saveUserEmail(email);
      CacheHelper.saveData(key: 'USER_EMAIL', value: email);

      if (_isSignIn) {
        context.read<AuthCubit>().login(
              email: email,
              password: _passwordController.text,
              rememberMe: _rememberMe,
            );
      } else {
        context.read<AuthCubit>().register(
              email: email,
              password: _passwordController.text,
              userName: _fullNameController.text.trim().isNotEmpty
                  ? _fullNameController.text.trim()
                  : null,
            );
      }
    }
  }

  void _onGoogleTap() async {
    try {
      final authResult = await sl<OAuthService>().signInWithGoogle();
      if (!mounted) return;
      if (authResult != null) {
        context.read<AuthCubit>().loginWithGoogle(
              idToken: authResult.idToken,
              accessToken: authResult.accessToken,
            );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.msgOAuthCancelled),
            backgroundColor: AppColors.surfaceCard,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _onGitHubTap() async {
    try {
      final code = await sl<OAuthService>().signInWithGitHub();
      if (!mounted) return;
      if (code != null) {
        context.read<AuthCubit>().loginWithGitHub(code: code);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.msgOAuthCancelled),
            backgroundColor: AppColors.surfaceCard,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _handleLoginSuccess() async {
    await CacheHelper.saveData(key: AppConstants.isFirstTimeLaunch, value: false);
    if (!mounted) return;

    try {
      final status = await sl<ProfileRemoteDataSource>().getOnboardingStatus();
      if (!mounted) return;

      if (status.isOnboardingCompleted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      } else if (status.hasSelectedTrack) {
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.setupProfile,
          arguments: {'trackTitle': status.selectedTrackName},
        );
      } else if (status.hasAcceptedTerms) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.setupTracks);
      } else {
        Navigator.of(context).pushReplacementNamed(AppRoutes.setupTerms);
      }
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              _handleLoginSuccess();
            } else if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.success,
                ),
              );
              setState(() => _isSignIn = true);
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Brand Logo
                    const Center(child: AuthBrandLogo()),

                    const SizedBox(height: 28),

                    // Main Title
                    Text(
                      _isSignIn
                          ? AppStrings.welcomeBackTitle
                          : AppStrings.createAccountTitle,
                      style: AppTextStyles.h1.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Subtitle
                    Text(
                      _isSignIn
                          ? AppStrings.welcomeBackSubtitle
                          : AppStrings.createAccountSubtitle,
                      style: AppTextStyles.bodySecondary.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13.5,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Segment Tab: Sign In / Sign Up
                    AuthSegmentTab(
                      isSignIn: _isSignIn,
                      onTabChanged: _onToggleTab,
                    ),

                    const SizedBox(height: 24),

                    // Sign Up Field: Full Name
                    if (!_isSignIn) ...[
                      AuthInputField(
                        key: const ValueKey('auth_fullname_field'),
                        label: AppStrings.labelFullName,
                        hint: AppStrings.hintFullName,
                        controller: _fullNameController,
                        prefixIcon: Icons.person_outline_rounded,
                        validator: (val) {
                          if (!_isSignIn && (val == null || val.trim().isEmpty)) {
                            return AppStrings.valFullNameRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Field: Email Address
                    AuthInputField(
                      key: const ValueKey('auth_email_field'),
                      label: AppStrings.labelEmailAddress,
                      hint: AppStrings.hintEmailAddress,
                      controller: _emailController,
                      prefixIcon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return AppStrings.valEmailRequired;
                        }
                        final emailRegex =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(val.trim())) {
                          return AppStrings.valEmailInvalid;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Field: Password
                    AuthInputField(
                      key: const ValueKey('auth_password_field'),
                      label: AppStrings.labelPassword,
                      hint: AppStrings.hintPassword,
                      controller: _passwordController,
                      prefixIcon: Icons.lock_outline_rounded,
                      isPassword: true,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return AppStrings.valPasswordRequired;
                        }
                        if (val.length < 8) {
                          return AppStrings.valPasswordMinLength;
                        }
                        return null;
                      },
                    ),

                    // Sign Up Field: Confirm Password
                    if (!_isSignIn) ...[
                      const SizedBox(height: 16),
                      AuthInputField(
                        key: const ValueKey('auth_confirm_password_field'),
                        label: AppStrings.labelConfirmPassword,
                        hint: AppStrings.hintPassword,
                        controller: _confirmPasswordController,
                        prefixIcon: Icons.lock_outline_rounded,
                        isPassword: true,
                        validator: (val) {
                          if (!_isSignIn && val != _passwordController.text) {
                            return AppStrings.valPasswordsDoNotMatch;
                          }
                          return null;
                        },
                      ),
                    ],

                    // Row: Remember Me & Forgot Password (Sign In only)
                    if (_isSignIn) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Remember Me Checkbox
                          GestureDetector(
                            onTap: () =>
                                setState(() => _rememberMe = !_rememberMe),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    onChanged: (val) => setState(
                                        () => _rememberMe = val ?? false),
                                    activeColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: const BorderSide(
                                      color: AppColors.border,
                                      width: 1.2,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppStrings.rememberMe,
                                  style: AppTextStyles.bodySecondary.copyWith(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Forgot Password Link
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.forgotPassword);
                            },
                            child: Text(
                              AppStrings.forgotPasswordAction,
                              style: AppTextStyles.bodySecondary.copyWith(
                                fontSize: 13,
                                color: AppColors.primaryLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Primary Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                _isSignIn
                                    ? AppStrings.btnStartLearning
                                    : AppStrings.btnCreateAccount,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Social Auth Buttons (GitHub & Google)
                    SocialAuthRow(
                      isSignIn: _isSignIn,
                      onGitHubTap: isLoading ? null : _onGitHubTap,
                      onGoogleTap: isLoading ? null : _onGoogleTap,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
