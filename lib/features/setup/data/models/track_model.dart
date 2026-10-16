import 'package:flutter/material.dart';

class TrackModel {
  final int id;
  final String code;
  final String title;
  final String description;
  final IconData icon;

  const TrackModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.icon,
  });
}

const List<TrackModel> kSkillPilotTracks = [
  TrackModel(
    id: 1,
    code: 'FrontendDevelopment',
    title: 'Frontend Development',
    description:
        'Master HTML, CSS, JavaScript, React, and modern UI engineering.',
    icon: Icons.aspect_ratio_rounded,
  ),
  TrackModel(
    id: 2,
    code: 'BackendDevelopment',
    title: 'Backend Development',
    description:
        'Build scalable server logic, RESTful APIs, databases, and microservices.',
    icon: Icons.dns_outlined,
  ),
  TrackModel(
    id: 3,
    code: 'FullStackDevelopment',
    title: 'Full-Stack Development',
    description:
        'Combine frontend and backend skills to build end-to-end web apps.',
    icon: Icons.layers_outlined,
  ),
  TrackModel(
    id: 4,
    code: 'MobileAppDevelopment',
    title: 'Mobile App Development',
    description:
        'Build cross-platform iOS and Android apps with React Native and Flutter.',
    icon: Icons.smartphone_rounded,
  ),
  TrackModel(
    id: 5,
    code: 'DataScienceAndAnalytics',
    title: 'Data Science & Analytics',
    description:
        'Turn data into insights with Python, SQL, statistics, and visualization.',
    icon: Icons.trending_up_rounded,
  ),
  TrackModel(
    id: 6,
    code: 'AiAndMachineLearning',
    title: 'AI & Machine Learning',
    description:
        'Train intelligent models and build practical AI-powered applications.',
    icon: Icons.auto_awesome_outlined,
  ),
  TrackModel(
    id: 7,
    code: 'CloudAndDevOps',
    title: 'Cloud & DevOps',
    description:
        'Deploy reliable systems with cloud platforms, containers, and CI/CD.',
    icon: Icons.cloud_outlined,
  ),
  TrackModel(
    id: 8,
    code: 'Cybersecurity',
    title: 'Cybersecurity',
    description:
        'Protect applications and networks with ethical hacking and security testing.',
    icon: Icons.shield_outlined,
  ),
  TrackModel(
    id: 9,
    code: 'UiUxDesign',
    title: 'UI/UX Design',
    description:
        'Create intuitive digital experiences through research, design, and prototyping.',
    icon: Icons.edit_outlined,
  ),
  TrackModel(
    id: 10,
    code: 'GameDevelopment',
    title: 'Game Development',
    description:
        'Create immersive 2D and 3D games with Unity, C#, and interactive gameplay.',
    icon: Icons.sports_esports_outlined,
  ),
  TrackModel(
    id: 11,
    code: 'QaAndTestAutomation',
    title: 'QA & Test Automation',
    description:
        'Ship with confidence using automated tools, quality practices, and debugging.',
    icon: Icons.check_circle_outline_rounded,
  ),
];
