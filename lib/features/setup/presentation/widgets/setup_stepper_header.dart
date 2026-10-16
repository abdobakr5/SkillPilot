import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_strings.dart';

class SetupStepperHeader extends StatelessWidget {
  final int currentStep; // 1, 2, or 3

  const SetupStepperHeader({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top App Bar row with SkillPilot & Secure account setup
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: const Center(
                    child: Text(
                      AppStrings.appBrandTerminal,
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 14,
                  color: AppColors.textSecondary.withOpacity(0.8),
                ),
                const SizedBox(width: 5),
                Text(
                  AppStrings.secureAccountSetup,
                  style: AppTextStyles.code.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 18),

        // Stepper Visual Row with flexible connectors
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              // Row of Circles & Connecting Lines
              Row(
                children: [
                  const Spacer(flex: 1),
                  _buildCircle(1),
                  Expanded(
                    flex: 4,
                    child: _buildLine(isActive: currentStep > 1),
                  ),
                  _buildCircle(2),
                  Expanded(
                    flex: 4,
                    child: _buildLine(isActive: currentStep > 2),
                  ),
                  _buildCircle(3),
                  const Spacer(flex: 1),
                ],
              ),
              const SizedBox(height: 6),

              // Row of Labels aligned directly below each circle
              Row(
                children: [
                  Expanded(
                    child: _buildLabel(
                      stepNumber: 1,
                      label: AppStrings.step1Terms,
                    ),
                  ),
                  Expanded(
                    child: _buildLabel(
                      stepNumber: 2,
                      label: AppStrings.step2Track,
                    ),
                  ),
                  Expanded(
                    child: _buildLabel(
                      stepNumber: 3,
                      label: AppStrings.step3Cv,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircle(int stepNumber) {
    final isDone = currentStep > stepNumber;
    final isCurrent = currentStep == stepNumber;

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isDone || isCurrent ? AppColors.primary : AppColors.surfaceCard,
        shape: BoxShape.circle,
        border: Border.all(
          color: isCurrent
              ? AppColors.primaryLight
              : (isDone ? AppColors.primary : AppColors.border),
          width: 1.5,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: Center(
        child: isDone
            ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
            : Text(
                '$stepNumber',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: isCurrent ? Colors.white : AppColors.textSecondary,
                ),
              ),
      ),
    );
  }

  Widget _buildLine({required bool isActive}) {
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildLabel({required int stepNumber, required String label}) {
    final isCurrent = currentStep == stepNumber;
    final isDone = currentStep > stepNumber;

    return Text(
      label,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 10.5,
        fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
        color: isCurrent
            ? AppColors.primaryLight
            : (isDone ? AppColors.textPrimary : AppColors.textSecondary),
      ),
    );
  }
}
