import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/databases/cache_helper.dart';
import '../../../../core/databases/secure_storage_helper.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/jwt_helper.dart';
import '../../../../core/widgets/app_status_dialog.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';

class SecurityPrivacyScreen extends StatefulWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  State<SecurityPrivacyScreen> createState() => _SecurityPrivacyScreenState();
}

class _SecurityPrivacyScreenState extends State<SecurityPrivacyScreen> {
  String _userEmail = '';
  bool _isLoading = true;
  bool _isSendingReset = false;

  // Privacy toggles
  bool _cvEncryption = true;
  bool _aiAnalysis = true;
  bool _publicProfile = false;

  @override
  void initState() {
    super.initState();
    _loadUserSecurityInfo();
  }

  Future<void> _loadUserSecurityInfo() async {
    try {
      // 1. Try secure storage (reads key or extracts from stored JWT access token)
      String? email = await sl<SecureStorageHelper>().getUserEmail();

      // 2. Try SharedPreferences cache
      if (email == null || email.isEmpty) {
        email = CacheHelper.getString(key: 'USER_EMAIL');
      }

      // 3. Fallback: inspect raw access token directly
      if (email == null || email.isEmpty) {
        final token = await sl<SecureStorageHelper>().getAccessToken();
        if (token != null && token.isNotEmpty) {
          email = JwtHelper.extractEmail(token);
        }
      }

      // 4. Fallback: inspect refresh token directly
      if (email == null || email.isEmpty) {
        final refToken = await sl<SecureStorageHelper>().getRefreshToken();
        if (refToken != null && refToken.isNotEmpty) {
          email = JwtHelper.extractEmail(refToken);
        }
      }

      if (email != null && email.isNotEmpty) {
        await sl<SecureStorageHelper>().saveUserEmail(email);
        await CacheHelper.saveData(key: 'USER_EMAIL', value: email);
      }

      if (!mounted) return;
      setState(() {
        _userEmail = email ?? '';
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendPasswordResetLink() async {
    if (_userEmail.isEmpty) {
      AppStatusDialog.show(
        context: context,
        title: 'Email Required',
        message: 'No registered email found. Please re-authenticate.',
        buttonText: 'OK',
        type: StatusDialogType.info,
      );
      return;
    }
    setState(() => _isSendingReset = true);
    try {
      final result =
          await sl<AuthRepository>().forgotPassword(email: _userEmail);

      if (!mounted) return;
      setState(() => _isSendingReset = false);

      result.fold(
        (failure) {
          AppStatusDialog.show(
            context: context,
            title: 'Request Failed',
            message: failure.message,
            buttonText: 'OK',
            type: StatusDialogType.error,
          );
        },
        (_) {
          AppStatusDialog.show(
            context: context,
            title: 'Reset Link Dispatched',
            message:
                'A secure password reset link has been dispatched to "$_userEmail". Check your inbox or spam folder.',
            buttonText: 'Got It',
            type: StatusDialogType.success,
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSendingReset = false);
      AppStatusDialog.show(
        context: context,
        title: 'Network Error',
        message: 'Could not connect to the security service. Please try again.',
        buttonText: 'OK',
        type: StatusDialogType.error,
      );
    }
  }

  void _copyEmail() {
    if (_userEmail.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _userEmail));
    AppStatusDialog.show(
      context: context,
      title: 'Email Copied',
      message: 'Account email "$_userEmail" copied to clipboard.',
      buttonText: 'Done',
      type: StatusDialogType.info,
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
          'Security & Privacy',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
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
                    // 1. Account Identity & Email Card
                    _buildAccountEmailCard(),

                    const SizedBox(height: 24),

                    // 2. Password & Authentication Section
                    _buildSectionTitle(
                      title: 'AUTHENTICATION & CREDENTIALS',
                      subtitle: 'Control password security and access recovery',
                    ),
                    const SizedBox(height: 12),
                    _buildPasswordManagementCard(),

                    const SizedBox(height: 24),

                    // 3. Privacy & AI Data Controls
                    _buildSectionTitle(
                      title: 'DATA PRIVACY & PREFERENCES',
                      subtitle:
                          'Manage resume privacy and recommendation telemetry',
                    ),
                    const SizedBox(height: 12),
                    _buildPrivacyTogglesCard(),

                    const SizedBox(height: 24),

                    // 4. Active Sessions Card
                    _buildSectionTitle(
                      title: 'ACTIVE SESSIONS',
                      subtitle: 'Currently signed-in devices and sessions',
                    ),
                    const SizedBox(height: 12),
                    _buildActiveSessionsCard(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 10.5,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: AppColors.primaryLight,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountEmailCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.35),
                  ),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppColors.primaryLight,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Primary Account Email',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _userEmail.isNotEmpty
                          ? _userEmail
                          : (_isLoading
                              ? 'Loading account...'
                              : 'No email registered'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              if (_userEmail.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.copy_rounded,
                      color: AppColors.textSecondary, size: 18),
                  tooltip: 'Copy Email',
                  onPressed: _copyEmail,
                ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'VERIFIED & SECURED',
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
              const Text(
                'JWT • 256-Bit SSL',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 9.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordManagementCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.key_rounded,
                  color: AppColors.primaryLight,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password Security',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Request a secure reset link sent directly to your email',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isSendingReset ? null : _sendPasswordResetLink,
              icon: _isSendingReset
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.mail_outline_rounded, size: 18),
              label: Text(
                _isSendingReset ? 'Sending Reset Link...' : 'Send Password Reset Link',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyTogglesCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          SwitchListTile(
            value: _cvEncryption,
            onChanged: (val) {
              setState(() => _cvEncryption = val);
            },
            activeColor: AppColors.primaryLight,
            title: const Text(
              'CV & Resume Encryption',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: const Text(
              'Encrypted storage; parsed solely during ATS resume scans.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          SwitchListTile(
            value: _aiAnalysis,
            onChanged: (val) {
              setState(() => _aiAnalysis = val);
            },
            activeColor: AppColors.primaryLight,
            title: const Text(
              'AI Skill Gap Analysis',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: const Text(
              'Allow SkillPilot to recommend customized milestones for your track.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          SwitchListTile(
            value: _publicProfile,
            onChanged: (val) {
              setState(() => _publicProfile = val);
            },
            activeColor: AppColors.primaryLight,
            title: const Text(
              'Public Talent Directory',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: const Text(
              'Allow verified tech recruiters to match your profile with jobs.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSessionsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.phone_android_rounded,
              color: AppColors.success,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Android Mobile Client',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Current Active Device • Logged in via Secure Token',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'ACTIVE',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
