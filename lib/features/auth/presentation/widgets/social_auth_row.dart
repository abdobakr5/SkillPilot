import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_strings.dart';

class SocialAuthRow extends StatelessWidget {
  final bool isSignIn;
  final VoidCallback? onGitHubTap;
  final VoidCallback? onGoogleTap;

  const SocialAuthRow({
    super.key,
    required this.isSignIn,
    this.onGitHubTap,
    this.onGoogleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with Text
        Row(
          children: [
            const Expanded(
              child: Divider(color: AppColors.border, thickness: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                isSignIn ? AppStrings.orSignInWith : AppStrings.orSignUpWith,
                style: const TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const Expanded(
              child: Divider(color: AppColors.border, thickness: 1),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 2 Social Buttons: GitHub & Google
        Row(
          children: [
            Expanded(
              child: _buildSocialButton(
                icon: Icons.code_rounded,
                label: AppStrings.gitHub,
                onTap: onGitHubTap,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildSocialButton(
                icon: Icons.g_mobiledata_rounded,
                label: AppStrings.google,
                isGoogle: true,
                onTap: onGoogleTap,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    bool isGoogle = false,
    VoidCallback? onTap,
  }) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isGoogle ? 28 : 20,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
