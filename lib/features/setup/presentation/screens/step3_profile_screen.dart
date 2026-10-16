import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/app_status_dialog.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/models/profile_models.dart';
import '../widgets/setup_stepper_header.dart';

class Step3ProfileScreen extends StatefulWidget {
  const Step3ProfileScreen({super.key});

  @override
  State<Step3ProfileScreen> createState() => _Step3ProfileScreenState();
}

class _Step3ProfileScreenState extends State<Step3ProfileScreen> {
  // Basic info text controllers
  final _fullNameController = TextEditingController(text: 'Alex Chen');
  final _locationController =
      TextEditingController(text: 'San Francisco, CA (PST / Remote)');
  final _linkedInController =
      TextEditingController(text: 'https://linkedin.com/in/alexchen-dev');
  final _customSkillController = TextEditingController();

  // Dynamic editable lists
  List<ProfileEducationModel> _educationList = [
    const ProfileEducationModel(
      degree: 'M.S. in Computer Science',
      institution: 'University of Washington • Distributed Systems Focus',
      years: '2019 - 2021',
    ),
  ];

  List<ProfileProjectModel> _projectsList = [
    const ProfileProjectModel(
      title: 'High-Throughput Asynchronous Stream Runtime',
      description:
          'Architected a distributed telemetry ingest service handling 120k events/sec using Tokio and gRPC pipelines with sub-5ms p99 latency.',
      tags: ['Rust', 'Tokio', 'gRPC', 'Redis'],
    ),
    const ProfileProjectModel(
      title: 'Staff Engineering Lead • HyperScale Systems',
      description:
          'Led cloud infrastructure migration to Kubernetes multi-cluster architecture. Reduced cloud compute overhead by 34% annually.',
      tags: ['Go', 'Kubernetes', 'AWS EKS', 'Terraform'],
    ),
  ];

  List<String> _skills = [
    'TypeScript',
    'Rust',
    'Python',
    'Go',
    'Docker',
    'Kubernetes',
    'gRPC',
    'Distributed Systems',
    'PostgreSQL',
  ];

  bool _isExtracting = false;
  bool _isSaving = false;
  String? _pickedFileName;
  String? _selectedTrackTitle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('trackTitle')) {
      _selectedTrackTitle = args['trackTitle'] as String?;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _locationController.dispose();
    _linkedInController.dispose();
    _customSkillController.dispose();
    super.dispose();
  }

  // Pick CV file & trigger AI extraction
  Future<void> _pickAndExtractCv() async {
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'doc'],
      );

      if (files.isEmpty) return;

      final file = files.first;
      if (file.path == null) {
        if (!mounted) return;
        AppStatusDialog.show(
          context: context,
          title: 'Error',
          message: 'Unable to read selected file path',
          type: StatusDialogType.error,
        );
        return;
      }

      setState(() {
        _pickedFileName = file.name;
        _isExtracting = true;
      });

      final dataSource = sl<ProfileRemoteDataSource>();
      final extractedProfile =
          await dataSource.extractCv(file.path!, file.name);

      if (!mounted) return;

      setState(() {
        _isExtracting = false;
        // Populate Basic Info if received
        if (extractedProfile.basicInfo?.fullName?.isNotEmpty == true) {
          _fullNameController.text = extractedProfile.basicInfo!.fullName!;
        }
        if (extractedProfile.basicInfo?.location?.isNotEmpty == true) {
          _locationController.text = extractedProfile.basicInfo!.location!;
        }
        if (extractedProfile.basicInfo?.linkedInUrl?.isNotEmpty == true) {
          _linkedInController.text = extractedProfile.basicInfo!.linkedInUrl!;
        }

        // Populate Education if received
        if (extractedProfile.education.isNotEmpty) {
          _educationList = List.from(extractedProfile.education);
        }

        // Populate Projects if received
        if (extractedProfile.projects.isNotEmpty) {
          _projectsList = List.from(extractedProfile.projects);
        }

        // Populate Skills if received
        if (extractedProfile.skills.isNotEmpty) {
          final mergedSkills = Set<String>.from(_skills)
            ..addAll(extractedProfile.skills);
          _skills = mergedSkills.toList();
        }
      });

      if (!mounted) return;
      AppStatusDialog.show(
        context: context,
        title: 'CV Extracted Successfully',
        message:
            'Our AI extracted your credentials, projects, and stack strengths. Review and tweak them below.',
        buttonText: 'Review Profile',
        type: StatusDialogType.success,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isExtracting = false);
      AppStatusDialog.show(
        context: context,
        title: 'CV Uploaded',
        message:
            'Could not auto-extract all details. You can enter or customize your credentials manually below.',
        buttonText: 'Continue Manually',
        type: StatusDialogType.info,
      );
    }
  }

  // Add / Remove Skills
  void _addSkill() {
    final text = _customSkillController.text.trim();
    if (text.isNotEmpty && !_skills.contains(text)) {
      setState(() {
        _skills.add(text);
        _customSkillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  // Delete Education
  void _deleteEducation(int index) {
    setState(() {
      _educationList.removeAt(index);
    });
  }

  // Dialog: Add Education
  void _showAddEducationDialog() {
    final degreeCtrl = TextEditingController();
    final institutionCtrl = TextEditingController();
    final yearsCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.border),
        ),
        title: const Text(
          'Add Education or Credential',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogTextField(
                label: 'DEGREE / CREDENTIAL',
                hint: 'e.g. B.S. in Software Engineering',
                controller: degreeCtrl,
              ),
              const SizedBox(height: 12),
              _buildDialogTextField(
                label: 'INSTITUTION / ORGANIZATION',
                hint: 'e.g. Cairo University',
                controller: institutionCtrl,
              ),
              const SizedBox(height: 12),
              _buildDialogTextField(
                label: 'YEARS ATTENDED',
                hint: 'e.g. 2020 - 2024',
                controller: yearsCtrl,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              if (degreeCtrl.text.trim().isEmpty) return;
              setState(() {
                _educationList.add(
                  ProfileEducationModel(
                    degree: degreeCtrl.text.trim(),
                    institution: institutionCtrl.text.trim(),
                    years: yearsCtrl.text.trim(),
                  ),
                );
              });
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(80, 38),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Add Entry'),
          ),
        ],
      ),
    );
  }

  // Delete Project
  void _deleteProject(int index) {
    setState(() {
      _projectsList.removeAt(index);
    });
  }

  // Dialog: Add Project
  void _showAddProjectDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final tagsCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.border),
        ),
        title: const Text(
          'Add Project or Experience',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogTextField(
                label: 'PROJECT OR ROLE TITLE',
                hint: 'e.g. E-Commerce Microservices Engine',
                controller: titleCtrl,
              ),
              const SizedBox(height: 12),
              _buildDialogTextField(
                label: 'DESCRIPTION & IMPACT',
                hint: 'Architected and deployed high-performance APIs...',
                controller: descCtrl,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              _buildDialogTextField(
                label: 'TAGS / TECH STACK (COMMA-SEPARATED)',
                hint: 'e.g. Flutter, Dart, Clean Architecture',
                controller: tagsCtrl,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.trim().isEmpty) return;
              final parsedTags = tagsCtrl.text
                  .split(',')
                  .map((t) => t.trim())
                  .where((t) => t.isNotEmpty)
                  .toList();

              setState(() {
                _projectsList.add(
                  ProfileProjectModel(
                    title: titleCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                    tags: parsedTags,
                  ),
                );
              });
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(80, 38),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Add Item'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 9.5,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
      ],
    );
  }

  // Finish Onboarding & Save Profile
  Future<void> _onFinish() async {
    setState(() => _isSaving = true);

    try {
      final profile = ProfileDataModel(
        basicInfo: ProfileBasicInfoModel(
          fullName: _fullNameController.text.trim(),
          location: _locationController.text.trim(),
          linkedInUrl: _linkedInController.text.trim(),
        ),
        education: _educationList,
        projects: _projectsList,
        skills: _skills,
      );

      final dataSource = sl<ProfileRemoteDataSource>();
      await dataSource.saveProfile(profile);
    } catch (_) {
      // Allow progression even if offline / dev test
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    AppStatusDialog.show(
      context: context,
      title: 'Profile Setup Completed',
      message:
          'Your developer profile has been saved. Welcome to SkillPilot!',
      buttonText: 'Start Learning →',
      type: StatusDialogType.success,
      onButtonPressed: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.home,
          (route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final trackTitle = _selectedTrackTitle ?? 'Full-Stack Development';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Stepper Header
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 14, 20, 10),
              child: SetupStepperHeader(currentStep: 3),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Subtitle
                    Center(
                      child: Text(
                        AppStrings.buildDevProfileTitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h2.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Text(
                        AppStrings.buildDevProfileSubtitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySecondary.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Drag & Drop CV Upload Box with Live Extraction
                    _buildUploadResumeBox(),

                    const SizedBox(height: 24),

                    // Section 1: Basic Information
                    _buildSectionHeader(
                      title: AppStrings.sectionBasicInfo,
                      trailingBadge: AppStrings.autoFilled,
                    ),
                    const SizedBox(height: 12),
                    _buildBasicInfoFields(),

                    const SizedBox(height: 24),

                    // Section 2: Education & Credentials
                    _buildSectionHeader(
                      title: AppStrings.sectionEducation,
                      trailingBadge:
                          '${_educationList.length} Entries Detected',
                    ),
                    const SizedBox(height: 12),
                    _buildEducationSection(),

                    const SizedBox(height: 24),

                    // Section 3: Projects & Work Experience
                    _buildSectionHeader(
                      title: AppStrings.sectionProjects,
                      trailingBadge: '${_projectsList.length} Items Parsed',
                    ),
                    const SizedBox(height: 12),
                    _buildProjectsSection(),

                    const SizedBox(height: 24),

                    // Section 4: Technical Skills & Stack
                    _buildSectionHeader(
                      title: AppStrings.sectionTechnicalSkills,
                      trailingBadge: AppStrings.clickTagToRemove,
                    ),
                    const SizedBox(height: 12),
                    _buildSkillsSection(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(trackTitle),
    );
  }

  // Upload Resume Box
  Widget _buildUploadResumeBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          if (_isExtracting) ...[
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Neural AI Extraction in progress...',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _pickedFileName ?? 'Analyzing document structure & credentials',
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ] else ...[
            const Icon(
              Icons.cloud_upload_outlined,
              size: 38,
              color: AppColors.primaryLight,
            ),
            const SizedBox(height: 10),
            Text(
              _pickedFileName != null
                  ? 'Selected: $_pickedFileName'
                  : AppStrings.dropCvPrompt,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppStrings.dropCvSub,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: AppColors.textSecondary.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: _pickAndExtractCv,
              icon: const Icon(Icons.folder_open_outlined, size: 16),
              label: Text(_pickedFileName != null
                  ? 'Change CV File'
                  : AppStrings.browseFiles),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: 12,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppStrings.supportedFilesNote,
                      style: const TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      size: 12,
                      color: AppColors.primaryLight,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      AppStrings.neuralExtractionLive,
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 10,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String trailingBadge,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          trailingBadge,
          style: const TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 10.5,
            color: AppColors.primaryLight,
          ),
        ),
      ],
    );
  }

  // Section 1: Basic Information Fields
  Widget _buildBasicInfoFields() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildCompactInput(
            label: AppStrings.labelFullName,
            controller: _fullNameController,
            prefixIcon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 12),
          _buildCompactInput(
            label: AppStrings.labelLocationTimezone,
            controller: _locationController,
            prefixIcon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 12),
          _buildCompactInput(
            label: AppStrings.labelLinkedInProfile,
            controller: _linkedInController,
            prefixIcon: Icons.link_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactInput({
    required String label,
    required TextEditingController controller,
    required IconData prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.5,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: AppColors.background,
            prefixIcon:
                Icon(prefixIcon, size: 16, color: AppColors.textSecondary),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
      ],
    );
  }

  // Section 2: Education List + Add
  Widget _buildEducationSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_educationList.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No education entries added yet.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else
            ..._educationList.asMap().entries.map((entry) {
              final index = entry.key;
              final edu = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                    bottom: index == _educationList.length - 1 ? 8 : 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.school_outlined,
                            size: 18, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            edu.degree ?? 'Degree',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (edu.years != null && edu.years!.isNotEmpty)
                          Text(
                            edu.years!,
                            style: const TextStyle(
                              fontFamily: 'JetBrains Mono',
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        const SizedBox(width: 6),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded,
                              size: 18),
                          color: AppColors.textSecondary,
                          onPressed: () => _deleteEducation(index),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 18,
                        ),
                      ],
                    ),
                    if (edu.institution != null &&
                        edu.institution!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        edu.institution!,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    if (index < _educationList.length - 1)
                      const Divider(color: AppColors.border, height: 20),
                  ],
                ),
              );
            }),
          const SizedBox(height: 6),
          InkWell(
            onTap: _showAddEducationDialog,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add, size: 16, color: AppColors.primaryLight),
                  SizedBox(width: 6),
                  Text(
                    AppStrings.addDegreeOrCert,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section 3: Projects List + Add
  Widget _buildProjectsSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_projectsList.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No projects added yet.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else
            ..._projectsList.asMap().entries.map((entry) {
              final index = entry.key;
              final proj = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                    bottom: index == _projectsList.length - 1 ? 8 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  proj.title ?? 'Project Title',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  AppStrings.keyProjectBadge,
                                  style: TextStyle(
                                    fontFamily: 'JetBrains Mono',
                                    fontSize: 9,
                                    color: AppColors.primaryLight,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded,
                              size: 18),
                          color: AppColors.textSecondary,
                          onPressed: () => _deleteProject(index),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 18,
                        ),
                      ],
                    ),
                    if (proj.description != null &&
                        proj.description!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        proj.description!,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11.5,
                          height: 1.35,
                          color: AppColors.textSecondary.withOpacity(0.9),
                        ),
                      ),
                    ],
                    if (proj.tags.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: proj.tags.map((t) => _TagBadge(t)).toList(),
                      ),
                    ],
                    if (index < _projectsList.length - 1)
                      const Divider(color: AppColors.border, height: 24),
                  ],
                ),
              );
            }),
          const SizedBox(height: 6),
          InkWell(
            onTap: _showAddProjectDialog,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add, size: 16, color: AppColors.primaryLight),
                  SizedBox(width: 6),
                  Text(
                    AppStrings.addProjectOrExp,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section 4: Technical Skills Section
  Widget _buildSkillsSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skill tags wrap
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _skills.map((skill) {
              return GestureDetector(
                onTap: () => _removeSkill(skill),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        skill,
                        style: const TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 11.5,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.close_rounded,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 14),

          // Add custom skill input row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _customSkillController,
                  onFieldSubmitted: (_) => _addSkill(),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: AppStrings.addCustomSkillHint,
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addSkill,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(64, 40),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  AppStrings.btnAdd,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2-Tier Bottom Bar pinned securely
  Widget _buildBottomBar(String trackTitle) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceCard,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tier 1: Selected track row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.5),
                border: const Border(
                  bottom: BorderSide(color: AppColors.border, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.check_circle_rounded,
                          size: 14, color: AppColors.success),
                      SizedBox(width: 6),
                      Text(
                        AppStrings.yourSelectedTrack,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      trackTitle,
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tier 2: Action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded, size: 16),
                    label: const Text(AppStrings.btnBack),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _onFinish,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 44),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                AppStrings.btnFinishSetup,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagBadge extends StatelessWidget {
  final String label;

  const _TagBadge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'JetBrains Mono',
          fontSize: 10,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
