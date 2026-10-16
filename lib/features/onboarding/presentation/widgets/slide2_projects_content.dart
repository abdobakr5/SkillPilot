import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_strings.dart';

class Slide2ProjectsContent extends StatelessWidget {
  const Slide2ProjectsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.onb2ProjectTitle,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            Text(
              AppStrings.onb2ProjectNumber,
              style: AppTextStyles.code.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Code block 1
        _buildCodeLine(
          icon: Icons.code_rounded,
          codeText: AppStrings.onb2Code1,
          commentText: AppStrings.onb2Comment1,
          isHighlighted: false,
        ),
        const SizedBox(height: 8),

        // Code block 2 (Highlighted)
        _buildCodeLine(
          icon: Icons.alt_route_rounded,
          codeText: AppStrings.onb2Code2,
          commentText: AppStrings.onb2Comment2,
          isHighlighted: true,
        ),
        const SizedBox(height: 8),

        // Code block 3
        _buildCodeLine(
          icon: Icons.rocket_launch_outlined,
          codeText: AppStrings.onb2Code3,
          commentText: AppStrings.onb2Comment3,
          isHighlighted: false,
        ),
        const SizedBox(height: 14),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.onb2Lang,
              style: AppTextStyles.code.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.play_arrow_rounded,
                  size: 14,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 2),
                Text(
                  AppStrings.onb2RunCode,
                  style: AppTextStyles.code.copyWith(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCodeLine({
    required IconData icon,
    required String codeText,
    required String commentText,
    required bool isHighlighted,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppColors.primary.withOpacity(0.12)
            : AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHighlighted ? AppColors.primary : AppColors.border,
          width: isHighlighted ? 1.2 : 0.8,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isHighlighted ? AppColors.primary : AppColors.textSecondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  codeText,
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isHighlighted
                        ? AppColors.primaryLight
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  commentText,
                  style: const TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 9.5,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
