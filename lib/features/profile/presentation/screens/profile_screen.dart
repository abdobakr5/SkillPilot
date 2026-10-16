import 'package:flutter/material.dart';
import '../../../../core/databases/secure_storage_helper.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_status_dialog.dart';
import '../../../setup/data/datasources/profile_remote_data_source.dart';
import '../../../setup/data/models/profile_models.dart';
import '../../../setup/data/models/track_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _fullNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _linkedInController = TextEditingController();
  final _customSkillController = TextEditingController();

  List<ProfileEducationModel> _educationList = [];
  List<ProfileProjectModel> _projectsList = [];
  List<String> _skills = [];

  int _selectedTrackId = 1;
  String _selectedTrackTitle = 'Frontend Development';
  bool _isUpdatingTrack = false;

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _locationController.dispose();
    _linkedInController.dispose();
    _customSkillController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final dataSource = sl<ProfileRemoteDataSource>();
      final profile = await dataSource.getProfile();

      // Retrieve active track status from backend
      try {
        final status = await dataSource.getOnboardingStatus();
        if (status.selectedTrack != null) {
          _selectedTrackId = status.selectedTrack!;
          final track = kSkillPilotTracks.firstWhere(
            (t) => t.id == _selectedTrackId,
            orElse: () => kSkillPilotTracks.first,
          );
          _selectedTrackTitle = status.selectedTrackName ?? track.title;
        } else if (status.selectedTrackName != null &&
            status.selectedTrackName!.isNotEmpty) {
          _selectedTrackTitle = status.selectedTrackName!;
          final match = kSkillPilotTracks.firstWhere(
            (t) =>
                t.title.toLowerCase() == _selectedTrackTitle.toLowerCase() ||
                t.code.toLowerCase() == _selectedTrackTitle.toLowerCase(),
            orElse: () => kSkillPilotTracks.first,
          );
          _selectedTrackId = match.id;
        }
      } catch (_) {
        // Fallback to default track if onboarding status request fails
      }

      if (!mounted) return;
      setState(() {
        _fullNameController.text = profile.basicInfo?.fullName ?? 'Developer';
        _locationController.text = profile.basicInfo?.location ?? '';
        _linkedInController.text = profile.basicInfo?.linkedInUrl ?? '';
        _educationList = List.from(profile.education);
        _projectsList = List.from(profile.projects);
        _skills = List.from(profile.skills);
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        if (_fullNameController.text.isEmpty) {
          _fullNameController.text = 'Developer';
        }
        if (_skills.isEmpty) {
          _skills = ['Dart', 'Flutter', 'TypeScript', 'Docker', 'PostgreSQL'];
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
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

      if (!mounted) return;
      AppStatusDialog.show(
        context: context,
        title: 'Profile Updated',
        message: 'Your profile changes have been saved to your account.',
        buttonText: 'Done',
        type: StatusDialogType.success,
      );
    } catch (e) {
      if (!mounted) return;
      AppStatusDialog.show(
        context: context,
        title: 'Update Failed',
        message:
            'Could not save profile changes right now. Please check your connection and try again.',
        buttonText: 'OK',
        type: StatusDialogType.error,
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _updateTrack(int newTrackId) async {
    setState(() => _isUpdatingTrack = true);
    final targetTrack = kSkillPilotTracks.firstWhere(
      (t) => t.id == newTrackId,
      orElse: () => kSkillPilotTracks.first,
    );

    try {
      final dataSource = sl<ProfileRemoteDataSource>();
      await dataSource.updateTrack(newTrackId);

      if (!mounted) return;
      setState(() {
        _selectedTrackId = newTrackId;
        _selectedTrackTitle = targetTrack.title;
        _isUpdatingTrack = false;
      });

      AppStatusDialog.show(
        context: context,
        title: 'Track Switched',
        message:
            'Your engineering track has been updated to "${targetTrack.title}". Roadmaps and recommendations are now aligned with your new focus.',
        buttonText: 'Done',
        type: StatusDialogType.success,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isUpdatingTrack = false);
      AppStatusDialog.show(
        context: context,
        title: 'Track Update Failed',
        message:
            'Could not update your engineering track right now. Please check your connection and try again.',
        buttonText: 'OK',
        type: StatusDialogType.error,
      );
    }
  }

  void _showChangeTrackBottomSheet() {
    int tempSelectedTrackId = _selectedTrackId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.82,
              ),
              decoration: const BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                border: Border(
                  top: BorderSide(color: AppColors.border),
                  left: BorderSide(color: AppColors.border),
                  right: BorderSide(color: AppColors.border),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    // Drag handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Header Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.alt_route_rounded,
                                  color: AppColors.primaryLight,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Switch Career Track',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded,
                                color: AppColors.textSecondary, size: 20),
                            onPressed: () =>
                                Navigator.of(bottomSheetContext).pop(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Switching your track personalizes your interactive roadmaps, project suggestions, and ATS skills matching.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: AppColors.textSecondary.withOpacity(0.85),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: AppColors.border, height: 1),
                    // Tracks List
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        physics: const BouncingScrollPhysics(),
                        itemCount: kSkillPilotTracks.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final track = kSkillPilotTracks[index];
                          final isSelected = track.id == tempSelectedTrackId;

                          return InkWell(
                            onTap: () {
                              setSheetState(() {
                                tempSelectedTrackId = track.id;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withOpacity(0.08)
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary.withOpacity(0.2)
                                          : AppColors.surface,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      track.icon,
                                      size: 18,
                                      color: isSelected
                                          ? AppColors.primaryLight
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          track.title,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 13.5,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                            color: isSelected
                                                ? Colors.white
                                                : AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          track.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 11,
                                            color: isSelected
                                                ? AppColors.textSecondary
                                                : AppColors.textSecondary
                                                    .withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.border,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: isSelected
                                        ? const Icon(Icons.check,
                                            size: 13, color: Colors.white)
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(color: AppColors.border, height: 1),
                    // Confirm Button
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(bottomSheetContext).pop();
                            if (tempSelectedTrackId != _selectedTrackId) {
                              await _updateTrack(tempSelectedTrackId);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            minimumSize: const Size(0, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Confirm & Switch Track',
                            style: TextStyle(
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
            );
          },
        );
      },
    );
  }

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

  void _deleteEducation(int index) {
    setState(() => _educationList.removeAt(index));
  }

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
              _buildDialogField(
                label: 'DEGREE / CREDENTIAL',
                hint: 'e.g. B.S. in Computer Science',
                controller: degreeCtrl,
              ),
              const SizedBox(height: 12),
              _buildDialogField(
                label: 'INSTITUTION',
                hint: 'e.g. Cairo University',
                controller: institutionCtrl,
              ),
              const SizedBox(height: 12),
              _buildDialogField(
                label: 'YEARS',
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
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _deleteProject(int index) {
    setState(() => _projectsList.removeAt(index));
  }

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
              _buildDialogField(
                label: 'TITLE',
                hint: 'e.g. Distributed Consensus Engine',
                controller: titleCtrl,
              ),
              const SizedBox(height: 12),
              _buildDialogField(
                label: 'DESCRIPTION',
                hint: 'Built Raft consensus in Rust with high throughput...',
                controller: descCtrl,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              _buildDialogField(
                label: 'TAGS (COMMA SEPARATED)',
                hint: 'e.g. Rust, Raft, Distributed Systems',
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
              final tags = tagsCtrl.text
                  .split(',')
                  .map((t) => t.trim())
                  .where((t) => t.isNotEmpty)
                  .toList();
              setState(() {
                _projectsList.add(
                  ProfileProjectModel(
                    title: titleCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                    tags: tags,
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
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField({
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

  void _onSignOut() async {
    await sl<SecureStorageHelper>().clearTokens();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.auth,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Career Profile',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
                    ),
                  )
                : const Icon(Icons.check_rounded, color: AppColors.primaryLight),
            tooltip: 'Save Profile',
            onPressed: _isSaving ? null : _saveProfile,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header Card
                    _buildProfileHeaderCard(),

                    const SizedBox(height: 16),

                    // Primary Track Focus & Switcher
                    _buildCurrentTrackCard(),

                    const SizedBox(height: 24),

                    // Section 1: Basic Information
                    _buildSectionHeader(
                      title: '1. Basic Information',
                      badge: 'EDITABLE',
                    ),
                    const SizedBox(height: 12),
                    _buildBasicInfoFields(),

                    const SizedBox(height: 24),

                    // Section 2: Education
                    _buildSectionHeader(
                      title: '2. Education & Credentials',
                      badge: '${_educationList.length} Entries',
                    ),
                    const SizedBox(height: 12),
                    _buildEducationSection(),

                    const SizedBox(height: 24),

                    // Section 3: Projects
                    _buildSectionHeader(
                      title: '3. Projects & Work Experience',
                      badge: '${_projectsList.length} Projects',
                    ),
                    const SizedBox(height: 12),
                    _buildProjectsSection(),

                    const SizedBox(height: 24),

                    // Section 4: Skills
                    _buildSectionHeader(
                      title: '4. Technical Skills & Stack',
                      badge: '${_skills.length} Skills',
                    ),
                    const SizedBox(height: 12),
                    _buildSkillsSection(),

                    const SizedBox(height: 28),

                    // Section 5: Account Security & Actions
                    _buildSectionHeader(
                      title: '5. Account & Security',
                      badge: 'SECURE',
                    ),
                    const SizedBox(height: 12),
                    _buildSecuritySection(),

                    const SizedBox(height: 32),

                    // Save Profile Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : _saveProfile,
                        icon: _isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Icon(Icons.save_outlined, size: 18),
                        label: Text(
                          _isSaving
                              ? 'Saving Changes...'
                              : 'Save Profile Changes',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileHeaderCard() {
    final name = _fullNameController.text.trim();
    final initials = name.isNotEmpty
        ? name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join()
        : 'DEV';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primary.withOpacity(0.2),
            child: Text(
              initials.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryLight,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isNotEmpty ? name : 'Tech Professional',
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _locationController.text.isNotEmpty
                      ? _locationController.text
                      : 'Remote / Global',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'ACTIVE PROFILE',
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.35),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        _selectedTrackTitle.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTrackCard() {
    final track = kSkillPilotTracks.firstWhere(
      (t) => t.id == _selectedTrackId,
      orElse: () => kSkillPilotTracks.first,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Flexible(
                      child: Text(
                        'CURRENT CAREER TRACK',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _isUpdatingTrack ? null : _showChangeTrackBottomSheet,
                icon: const Icon(Icons.swap_horiz_rounded, size: 14),
                label: const Text('Change Track'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryLight,
                  side: const BorderSide(color: AppColors.primary),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: const Size(0, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: _isUpdatingTrack ? null : _showChangeTrackBottomSheet,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: _isUpdatingTrack
                        ? const Center(
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryLight),
                              ),
                            ),
                          )
                        : Icon(
                            track.icon,
                            color: AppColors.primaryLight,
                            size: 22,
                          ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          track.title,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          track.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.5,
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required String badge}) {
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
          badge,
          style: const TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 10,
            color: AppColors.primaryLight,
          ),
        ),
      ],
    );
  }

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
          _buildCompactField(
            label: 'FULL NAME',
            controller: _fullNameController,
            prefixIcon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 12),
          _buildCompactField(
            label: 'LOCATION / TIMEZONE',
            controller: _locationController,
            prefixIcon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 12),
          _buildCompactField(
            label: 'LINKEDIN / PORTFOLIO URL',
            controller: _linkedInController,
            prefixIcon: Icons.link_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactField({
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
            const Text(
              'No education records added.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: AppColors.textSecondary,
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
                    '+ Add Degree or Certification',
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
            const Text(
              'No projects added yet.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: AppColors.textSecondary,
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
                          child: Text(
                            proj.title ?? 'Project Title',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
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
                        children: proj.tags
                            .map((t) => _ProjectTagChip(t))
                            .toList(),
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
                    '+ Add Project or Experience',
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
                      const Icon(Icons.close_rounded,
                          size: 13, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
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
                    hintText: 'Add custom skill (e.g. GraphQL, Docker)',
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
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text('Add'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Security & Privacy Settings tile
          ListTile(
            leading: const Icon(Icons.security_rounded,
                color: AppColors.primaryLight),
            title: const Text(
              'Security & Privacy',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: const Text(
              'Manage password, email verification & data privacy',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
            trailing: const Icon(Icons.chevron_right_rounded,
                color: AppColors.textSecondary),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.securityPrivacy);
            },
          ),
          const Divider(color: AppColors.border, height: 1),
          // Sign Out tile
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.error),
            title: const Text(
              'Sign Out',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
            subtitle: const Text(
              'End session and clear credentials',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
            trailing: const Icon(Icons.chevron_right_rounded,
                color: AppColors.textSecondary),
            onTap: _onSignOut,
          ),
        ],
      ),
    );
  }
}

class _ProjectTagChip extends StatelessWidget {
  final String label;

  const _ProjectTagChip(this.label);

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
