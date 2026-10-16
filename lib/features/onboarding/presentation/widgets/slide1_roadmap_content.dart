import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_strings.dart';

class Slide1RoadmapContent extends StatelessWidget {
  const Slide1RoadmapContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.onb1TrackRole,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            Text(
              AppStrings.onb1TrackProgress,
              style: AppTextStyles.code.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Step 1: HTML & CSS (Completed)
        _buildItem(
          icon: Icons.check_circle_rounded,
          iconColor: AppColors.success,
          title: AppStrings.onb1Item1Title,
          subtitle: AppStrings.onb1Item1Subtitle,
          isHighlighted: false,
        ),
        const SizedBox(height: 10),

        // Step 2: React & TypeScript (Active / Highlighted)
        _buildItem(
          icon: Icons.alt_route_rounded,
          iconColor: AppColors.primary,
          title: AppStrings.onb1Item2Title,
          subtitle: AppStrings.onb1Item2Subtitle,
          isHighlighted: true,
        ),
        const SizedBox(height: 10),

        // Step 3: Locked
        _buildItem(
          icon: Icons.lock_outline_rounded,
          iconColor: AppColors.textSecondary.withOpacity(0.6),
          title: AppStrings.onb1Item3Title,
          subtitle: AppStrings.onb1Item3Subtitle,
          isHighlighted: false,
          isLocked: true,
        ),
        const SizedBox(height: 14),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.onb1Pace,
              style: AppTextStyles.code.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
            Row(
              children: [
                Text(
                  AppStrings.onb1ExplorePath,
                  style: AppTextStyles.code.copyWith(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 12,
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isHighlighted,
    bool isLocked = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isLocked
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 9.5,
                    color: isHighlighted
                        ? AppColors.primaryLight
                        : AppColors.textSecondary,
                    letterSpacing: 0.5,
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
