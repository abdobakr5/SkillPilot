import 'package:dio/dio.dart';
import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/profile_models.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileDataModel> extractCv(String filePath, String fileName);
  Future<void> saveProfile(ProfileDataModel profile);
  Future<ProfileDataModel> getProfile();
  Future<OnboardingStatusModel> getOnboardingStatus();
  Future<void> updateTrack(int trackId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiConsumer apiConsumer;

  ProfileRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ProfileDataModel> extractCv(String filePath, String fileName) async {
    final multipartFile = await MultipartFile.fromFile(
      filePath,
      filename: fileName,
    );

    final formData = FormData.fromMap({
      ApiKeys.file: multipartFile,
    });

    final response = await apiConsumer.post(
      EndPoints.onboardingCvExtract,
      data: formData,
    );

    if (response is Map<String, dynamic>) {
      return ProfileDataModel.fromJson(response);
    }

    throw Exception('Invalid CV extraction response structure');
  }

  @override
  Future<void> saveProfile(ProfileDataModel profile) async {
    await apiConsumer.put(
      EndPoints.onboardingProfile,
      data: profile.toJson(),
    );
  }

  @override
  Future<ProfileDataModel> getProfile() async {
    final response = await apiConsumer.get(EndPoints.onboardingProfile);

    if (response is Map<String, dynamic>) {
      return ProfileDataModel.fromJson(response);
    }

    throw Exception('Invalid profile response structure');
  }

  @override
  Future<OnboardingStatusModel> getOnboardingStatus() async {
    final response = await apiConsumer.get(EndPoints.onboardingStatus);

    if (response is Map<String, dynamic>) {
      return OnboardingStatusModel.fromJson(response);
    }

    throw Exception('Invalid onboarding status response structure');
  }

  @override
  Future<void> updateTrack(int trackId) async {
    await apiConsumer.post(
      EndPoints.onboardingTracksSelect,
      data: {
        ApiKeys.track: trackId,
      },
    );
  }
}
