import 'package:flutter/material.dart';
import '../../../../core/databases/secure_storage_helper.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/app_status_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _onSignOut(BuildContext context) async {
    await sl<SecureStorageHelper>().clearTokens();
    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.auth,
      (route) => false,
    );
  }

  void _showFeatureDialog(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
  }) {
    AppStatusDialog.show(
      context: context,
      title: title,
      message: description,
      buttonText: 'Got It',
      type: StatusDialogType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: _buildNavigationDrawer(context),
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary, size: 24),
            tooltip: 'Navigation Menu',
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.4),
                  width: 1,
                ),
              ),
              child: const Text(
                AppStrings.appBrandTerminal,
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryLight,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              AppStrings.appName,
              style: AppTextStyles.h3.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          // Top-right Profile Avatar / Logo
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.profile);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.6),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.surfaceCard,
                child: Icon(
                  Icons.person_rounded,
                  size: 18,
                  color: AppColors.primaryLight,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner (Inspired by Web design)
              _buildWebInspiredHero(context),

              const SizedBox(height: 24),

              // Active Track Roadmap Card
              _buildActiveTrackCard(context),

              const SizedBox(height: 24),

              // Section Header: Platform Features
              const Text(
                'PLATFORM SUITE',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 12),

              // Features Grid Cards
              _buildFeaturesGrid(context),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  // Navigation Drawer with Platform Links
  Widget _buildNavigationDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
              decoration: const BoxDecoration(
                color: AppColors.surfaceCard,
                border: Border(
                  bottom: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: const Text(
                          AppStrings.appBrandTerminal,
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryLight,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        AppStrings.appName,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'ACTIVE LEARNER • VERIFIED',
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Links List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(
                    icon: Icons.home_rounded,
                    title: 'Home',
                    onTap: () => Navigator.of(context).pop(),
                    isSelected: true,
                  ),
                  _buildDrawerItem(
                    icon: Icons.hub_outlined,
                    title: 'Roadmaps',
                    badge: 'CAREER',
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(AppRoutes.roadmaps);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.auto_awesome_rounded,
                    title: 'Recommendation System',
                    onTap: () {
                      Navigator.of(context).pop();
                      _showFeatureDialog(
                        context,
                        title: 'Recommendation System',
                        description:
                            'AI-driven engine that analyzes your skill profile, detects engineering gaps, and recommends personalized challenges, projects, and interview questions.',
                        icon: Icons.auto_awesome_rounded,
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.description_outlined,
                    title: 'ATS Resume Scanner',
                    onTap: () {
                      Navigator.of(context).pop();
                      _showFeatureDialog(
                        context,
                        title: 'ATS Resume Scanner',
                        description:
                            'Evaluate your CV against real modern hiring algorithms. Get instant score breakdowns, keyword recommendations, and ATS compliance fixes.',
                        icon: Icons.description_outlined,
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.work_outline_rounded,
                    title: 'Jobs & Opportunities',
                    badge: 'NEW',
                    onTap: () {
                      Navigator.of(context).pop();
                      _showFeatureDialog(
                        context,
                        title: 'Jobs Board',
                        description:
                            'Direct matchmaking with tech companies seeking your verified skill stack. No blind applications; get matched by real competency.',
                        icon: Icons.work_outline_rounded,
                      );
                    },
                  ),
                  const Divider(color: AppColors.border, height: 20),
                  _buildDrawerItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Career Profile',
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(AppRoutes.profile);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.security_rounded,
                    title: 'Security & Privacy',
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(AppRoutes.securityPrivacy);
                    },
                  ),
                ],
              ),
            ),

            // Sign Out at Bottom
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: ListTile(
                leading: const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                title: const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _onSignOut(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? badge,
    bool isSelected = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        size: 20,
        color: isSelected ? AppColors.primaryLight : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 13.5,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? AppColors.primaryLight : AppColors.textPrimary,
        ),
      ),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 8.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryLight,
                ),
              ),
            )
          : null,
      onTap: onTap,
    );
  }

  // Web-inspired Hero Section
  Widget _buildWebInspiredHero(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.12),
            blurRadius: 28,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Elevate Your ',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.25,
                  ),
                ),
                TextSpan(
                  text: 'Career & Tech ',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryLight,
                    height: 1.25,
                  ),
                ),
                TextSpan(
                  text: 'Journey',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Join SkillPilot to build, test, and pilot your career skills across top industry tracks with AI recommendations, CV intelligence, and interactive roadmaps.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.roadmaps);
            },
            icon: const Icon(Icons.rocket_launch_rounded, size: 16),
            label: const Text(
              'Explore Features •',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              minimumSize: const Size(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  // Active Track Card
  Widget _buildActiveTrackCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  AppStrings.homeActiveTrack,
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ),
              const Text(
                '35% Completed',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            AppStrings.homeTrackName,
            style: AppTextStyles.h3.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Milestone 2: Modern Framework & State Architecture',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.35,
              minHeight: 6,
              backgroundColor: AppColors.background,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.roadmaps);
                  },
                  icon: const Icon(Icons.play_arrow_rounded, size: 18),
                  label: const Text(
                    AppStrings.homeContinueLesson,
                    style: TextStyle(fontFamily: 'Inter', fontSize: 12.5),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.roadmaps);
                },
                icon: const Icon(Icons.hub_outlined, size: 16),
                label: const Text(
                  AppStrings.homeExploreRoadmaps,
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12.5),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Features Grid
  Widget _buildFeaturesGrid(BuildContext context) {
    final features = [
      {
        'title': 'Roadmaps',
        'subtitle': 'Structured paths & milestones',
        'icon': Icons.hub_outlined,
        'onTap': () => Navigator.of(context).pushNamed(AppRoutes.roadmaps),
      },
      {
        'title': 'Career Profile',
        'subtitle': 'Skills, experience & track credentials',
        'icon': Icons.badge_outlined,
        'onTap': () => Navigator.of(context).pushNamed(AppRoutes.profile),
      },
      {
        'title': 'Recommendations',
        'subtitle': 'AI gap analysis & study plans',
        'icon': Icons.auto_awesome_rounded,
        'onTap': () => _showFeatureDialog(
              context,
              title: 'Recommendation System',
              description:
                  'AI-driven engine that analyzes your skill profile, detects engineering gaps, and recommends personalized challenges, projects, and interview questions.',
              icon: Icons.auto_awesome_rounded,
            ),
      },
      {
        'title': 'ATS CV Scanner',
        'subtitle': 'Check and optimize resume pass rate',
        'icon': Icons.document_scanner_outlined,
        'onTap': () => _showFeatureDialog(
              context,
              title: 'ATS Resume Scanner',
              description:
                  'Evaluate your CV against real modern hiring algorithms. Get instant score breakdowns, keyword recommendations, and ATS compliance fixes.',
              icon: Icons.document_scanner_outlined,
            ),
      },
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final childRatio = screenWidth < 360 ? 1.05 : (screenWidth < 400 ? 1.12 : 1.18);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: features.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: childRatio,
      ),
      itemBuilder: (context, index) {
        final f = features[index];
        return InkWell(
          onTap: f['onTap'] as VoidCallback,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    f['icon'] as IconData,
                    size: 20,
                    color: AppColors.primaryLight,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      f['title'] as String,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      f['subtitle'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
