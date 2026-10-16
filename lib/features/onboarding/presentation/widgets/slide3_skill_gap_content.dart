import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_strings.dart';

class Slide3SkillGapContent extends StatelessWidget {
  const Slide3SkillGapContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.onb3CardHeader,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.primary, width: 0.8),
              ),
              child: Text(
                AppStrings.onb3ReadinessPercentage,
                style: AppTextStyles.code.copyWith(
                  color: AppColors.primaryLight,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Mastery Item 1: Mastered Skills
        _buildSkillCard(
          statusIcon: Icons.check_circle_rounded,
          statusColor: AppColors.success,
          title: AppStrings.onb3Skill1Title,
          subtitle: AppStrings.onb3Skill1Sub,
          badge: AppStrings.onb3BadgeAcquired,
          badgeBg: AppColors.success.withOpacity(0.15),
          badgeFg: AppColors.success,
        ),
        const SizedBox(height: 8),

        // Mastery Item 2: In-Progress / Gap Highlighted
        _buildSkillCard(
          statusIcon: Icons.trending_up_rounded,
          statusColor: AppColors.secondary,
          title: AppStrings.onb3Skill2Title,
          subtitle: AppStrings.onb3Skill2Sub,
          badge: AppStrings.onb3BadgeInProgress,
          badgeBg: AppColors.secondary.withOpacity(0.15),
          badgeFg: AppColors.secondary,
          isHighlighted: true,
        ),
        const SizedBox(height: 8),

        // Mastery Item 3: Next Target
        _buildSkillCard(
          statusIcon: Icons.flag_outlined,
          statusColor: AppColors.primaryLight,
          title: AppStrings.onb3Skill3Title,
          subtitle: AppStrings.onb3Skill3Sub,
          badge: AppStrings.onb3BadgeUpcoming,
          badgeBg: AppColors.surfaceCard,
          badgeFg: AppColors.textSecondary,
        ),
        const SizedBox(height: 14),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.onb3GrowthFooter,
              style: AppTextStyles.code.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
            Row(
              children: [
                Text(
                  AppStrings.onb3ViewRoadmap,
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

  Widget _buildSkillCard({
    required IconData statusIcon,
    required Color statusColor,
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeBg,
    required Color badgeFg,
    bool isHighlighted = false,
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
          Icon(statusIcon, size: 17, color: statusColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: badgeFg,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 9.5,
                    color: AppColors.textSecondary,
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
