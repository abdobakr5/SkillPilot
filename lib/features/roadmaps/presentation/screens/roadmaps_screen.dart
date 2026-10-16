import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class RoadmapsScreen extends StatefulWidget {
  const RoadmapsScreen({super.key});

  @override
  State<RoadmapsScreen> createState() => _RoadmapsScreenState();
}

class _RoadmapsScreenState extends State<RoadmapsScreen> {
  int _selectedTrackIndex = 0;

  final List<Map<String, dynamic>> _tracks = [
    {
      'title': 'Frontend Development',
      'icon': Icons.aspect_ratio_rounded,
      'progress': 0.35,
      'milestones': 12,
      'completed': 4,
      'tag': 'IN PROGRESS',
    },
    {
      'title': 'Backend Development',
      'icon': Icons.dns_outlined,
      'progress': 0.15,
      'milestones': 14,
      'completed': 2,
      'tag': 'EXPLORE',
    },
    {
      'title': 'Mobile App Development',
      'icon': Icons.smartphone_rounded,
      'progress': 0.0,
      'milestones': 10,
      'completed': 0,
      'tag': 'EXPLORE',
    },
    {
      'title': 'Full-Stack Development',
      'icon': Icons.layers_outlined,
      'progress': 0.0,
      'milestones': 16,
      'completed': 0,
      'tag': 'EXPLORE',
    },
    {
      'title': 'Cloud & DevOps',
      'icon': Icons.cloud_outlined,
      'progress': 0.0,
      'milestones': 11,
      'completed': 0,
      'tag': 'EXPLORE',
    },
    {
      'title': 'AI & Machine Learning',
      'icon': Icons.auto_awesome_outlined,
      'progress': 0.0,
      'milestones': 15,
      'completed': 0,
      'tag': 'EXPLORE',
    },
  ];

  final List<Map<String, dynamic>> _currentMilestones = [
    {
      'step': '01',
      'title': 'Core Languages & Version Control',
      'desc': 'Git workflows, clean code, algorithmic problem solving & data structures.',
      'status': 'COMPLETED',
      'isCompleted': true,
      'isActive': false,
    },
    {
      'step': '02',
      'title': 'Modern Framework & State Architecture',
      'desc': 'Deep dive into component lifecycles, unidirectional data flow, and async streams.',
      'status': 'CURRENT',
      'isCompleted': false,
      'isActive': true,
    },
    {
      'step': '03',
      'title': 'Enterprise APIs & Distributed Data',
      'desc': 'RESTful endpoints, caching layers, offline-first syncing, and WebSocket feeds.',
      'status': 'UPCOMING',
      'isCompleted': false,
      'isActive': false,
    },
    {
      'step': '04',
      'title': 'Production Deployment & Observability',
      'desc': 'Automated CI/CD pipelines, container orchestration, metrics, and latency tracing.',
      'status': 'LOCKED',
      'isCompleted': false,
      'isActive': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final activeTrack = _tracks[_selectedTrackIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Engineering Roadmaps',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.hub_outlined, size: 14, color: AppColors.primaryLight),
                SizedBox(width: 4),
                Text(
                  'SYNCED',
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Banner Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.surfaceCard,
                      AppColors.surfaceCard.withOpacity(0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.08),
                      blurRadius: 20,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'CAREER ROADMAP HUB',
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Structured Learning Trajectory',
                      style: AppTextStyles.h2.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Navigate from fundamental principles to production architecture with battle-tested milestones.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tracks Horizontal Selector
              const Text(
                'SELECT SPECIALIZATION',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _tracks.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final track = _tracks[index];
                    final isSelected = index == _selectedTrackIndex;
                    return ChoiceChip(
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedTrackIndex = index),
                      avatar: Icon(
                        track['icon'] as IconData,
                        size: 16,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                      label: Text(
                        track['title'] as String,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.5,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                      backgroundColor: AppColors.surfaceCard,
                      selectedColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.border,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Selected Track Overview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          activeTrack['title'] as String,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: (activeTrack['tag'] == 'IN PROGRESS'
                                    ? AppColors.success
                                    : AppColors.textSecondary)
                                .withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            activeTrack['tag'] as String,
                            style: TextStyle(
                              fontFamily: 'JetBrains Mono',
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: activeTrack['tag'] == 'IN PROGRESS'
                                  ? AppColors.success
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${activeTrack['completed']} / ${activeTrack['milestones']} Milestones Completed',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '${((activeTrack['progress'] as double) * 100).toInt()}%',
                          style: const TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: activeTrack['progress'] as double,
                        minHeight: 6,
                        backgroundColor: AppColors.background,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Milestone Timeline
              const Text(
                'ROADMAP MILESTONES',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 14),

              ..._currentMilestones.asMap().entries.map((entry) {
                final index = entry.key;
                final m = entry.value;
                final isLast = index == _currentMilestones.length - 1;

                Color nodeColor;
                IconData nodeIcon;

                if (m['isCompleted'] == true) {
                  nodeColor = AppColors.success;
                  nodeIcon = Icons.check_circle_rounded;
                } else if (m['isActive'] == true) {
                  nodeColor = AppColors.primary;
                  nodeIcon = Icons.play_circle_fill_rounded;
                } else {
                  nodeColor = AppColors.textSecondary;
                  nodeIcon = Icons.lock_outline_rounded;
                }

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Node icon + timeline vertical line
                      Column(
                        children: [
                          Icon(nodeIcon, size: 22, color: nodeColor),
                          if (!isLast)
                            Expanded(
                              child: Container(
                                width: 2,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                color: AppColors.border,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      // Card details
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceCard,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: m['isActive'] == true
                                    ? AppColors.primary.withOpacity(0.5)
                                    : AppColors.border,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        m['title'] as String,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.bold,
                                          color: m['isActive'] == true
                                              ? AppColors.primaryLight
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: nodeColor.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        m['status'] as String,
                                        style: TextStyle(
                                          fontFamily: 'JetBrains Mono',
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: nodeColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  m['desc'] as String,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
