class ProfileBasicInfoModel {
  final String? fullName;
  final String? location;
  final String? linkedInUrl;

  const ProfileBasicInfoModel({
    this.fullName,
    this.location,
    this.linkedInUrl,
  });

  factory ProfileBasicInfoModel.fromJson(Map<String, dynamic> json) {
    return ProfileBasicInfoModel(
      fullName: json['fullName'] as String?,
      location: json['location'] as String?,
      linkedInUrl: json['linkedInUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'location': location,
      'linkedInUrl': linkedInUrl,
    };
  }

  ProfileBasicInfoModel copyWith({
    String? fullName,
    String? location,
    String? linkedInUrl,
  }) {
    return ProfileBasicInfoModel(
      fullName: fullName ?? this.fullName,
      location: location ?? this.location,
      linkedInUrl: linkedInUrl ?? this.linkedInUrl,
    );
  }
}

class ProfileEducationModel {
  final String? degree;
  final String? institution;
  final String? years;

  const ProfileEducationModel({
    this.degree,
    this.institution,
    this.years,
  });

  factory ProfileEducationModel.fromJson(Map<String, dynamic> json) {
    return ProfileEducationModel(
      degree: json['degree'] as String?,
      institution: json['institution'] as String?,
      years: json['years'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'institution': institution,
      'years': years,
    };
  }

  ProfileEducationModel copyWith({
    String? degree,
    String? institution,
    String? years,
  }) {
    return ProfileEducationModel(
      degree: degree ?? this.degree,
      institution: institution ?? this.institution,
      years: years ?? this.years,
    );
  }
}

class ProfileProjectModel {
  final String? title;
  final String? description;
  final List<String> tags;

  const ProfileProjectModel({
    this.title,
    this.description,
    this.tags = const [],
  });

  factory ProfileProjectModel.fromJson(Map<String, dynamic> json) {
    final rawTags = json['tags'];
    List<String> parsedTags = [];
    if (rawTags is List) {
      parsedTags = rawTags.map((e) => e.toString()).toList();
    }

    return ProfileProjectModel(
      title: json['title'] as String?,
      description: json['description'] as String?,
      tags: parsedTags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'tags': tags,
    };
  }

  ProfileProjectModel copyWith({
    String? title,
    String? description,
    List<String>? tags,
  }) {
    return ProfileProjectModel(
      title: title ?? this.title,
      description: description ?? this.description,
      tags: tags ?? this.tags,
    );
  }
}

class ProfileExperienceModel {
  final String? organization;
  final String? role;
  final String? location;
  final String? dates;
  final String? description;

  const ProfileExperienceModel({
    this.organization,
    this.role,
    this.location,
    this.dates,
    this.description,
  });

  factory ProfileExperienceModel.fromJson(Map<String, dynamic> json) {
    return ProfileExperienceModel(
      organization: json['organization'] as String?,
      role: json['role'] as String?,
      location: json['location'] as String?,
      dates: json['dates'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organization': organization,
      'role': role,
      'location': location,
      'dates': dates,
      'description': description,
    };
  }

  ProfileExperienceModel copyWith({
    String? organization,
    String? role,
    String? location,
    String? dates,
    String? description,
  }) {
    return ProfileExperienceModel(
      organization: organization ?? this.organization,
      role: role ?? this.role,
      location: location ?? this.location,
      dates: dates ?? this.dates,
      description: description ?? this.description,
    );
  }
}

class ProfileDataModel {
  final ProfileBasicInfoModel? basicInfo;
  final List<ProfileEducationModel> education;
  final List<ProfileProjectModel> projects;
  final List<String> skills;
  final List<String> certifications;
  final List<ProfileExperienceModel> experience;

  const ProfileDataModel({
    this.basicInfo,
    this.education = const [],
    this.projects = const [],
    this.skills = const [],
    this.certifications = const [],
    this.experience = const [],
  });

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) {
    // Check if wrapped in data or profileData
    final source = json['profileData'] is Map<String, dynamic>
        ? json['profileData'] as Map<String, dynamic>
        : (json['data'] is Map<String, dynamic>
            ? (json['data']['profileData'] is Map<String, dynamic>
                ? json['data']['profileData'] as Map<String, dynamic>
                : json['data'] as Map<String, dynamic>)
            : json);

    ProfileBasicInfoModel? basic;
    if (source['basicInfo'] is Map<String, dynamic>) {
      basic = ProfileBasicInfoModel.fromJson(
        source['basicInfo'] as Map<String, dynamic>,
      );
    }

    List<ProfileEducationModel> eduList = [];
    if (source['education'] is List) {
      eduList = (source['education'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => ProfileEducationModel.fromJson(e))
          .toList();
    }

    List<ProfileProjectModel> projList = [];
    if (source['projects'] is List) {
      projList = (source['projects'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => ProfileProjectModel.fromJson(e))
          .toList();
    }

    List<String> skillList = [];
    if (source['skills'] is List) {
      skillList = (source['skills'] as List).map((e) => e.toString()).toList();
    }

    List<String> certList = [];
    if (source['certifications'] is List) {
      certList =
          (source['certifications'] as List).map((e) => e.toString()).toList();
    }

    List<ProfileExperienceModel> expList = [];
    if (source['experience'] is List) {
      expList = (source['experience'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => ProfileExperienceModel.fromJson(e))
          .toList();
    }

    return ProfileDataModel(
      basicInfo: basic,
      education: eduList,
      projects: projList,
      skills: skillList,
      certifications: certList,
      experience: expList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'basicInfo': basicInfo?.toJson() ?? {},
      'education': education.map((e) => e.toJson()).toList(),
      'projects': projects.map((e) => e.toJson()).toList(),
      'skills': skills,
      'certifications': certifications,
      'experience': experience.map((e) => e.toJson()).toList(),
    };
  }

  ProfileDataModel copyWith({
    ProfileBasicInfoModel? basicInfo,
    List<ProfileEducationModel>? education,
    List<ProfileProjectModel>? projects,
    List<String>? skills,
    List<String>? certifications,
    List<ProfileExperienceModel>? experience,
  }) {
    return ProfileDataModel(
      basicInfo: basicInfo ?? this.basicInfo,
      education: education ?? this.education,
      projects: projects ?? this.projects,
      skills: skills ?? this.skills,
      certifications: certifications ?? this.certifications,
      experience: experience ?? this.experience,
    );
  }
}

class OnboardingStatusModel {
  final int? currentStep;
  final String? currentStepName;
  final bool hasAcceptedTerms;
  final bool hasSelectedTrack;
  final int? selectedTrack;
  final String? selectedTrackName;
  final bool isOnboardingCompleted;
  final String? nextStepRoute;

  const OnboardingStatusModel({
    this.currentStep,
    this.currentStepName,
    this.hasAcceptedTerms = false,
    this.hasSelectedTrack = false,
    this.selectedTrack,
    this.selectedTrackName,
    this.isOnboardingCompleted = false,
    this.nextStepRoute,
  });

  factory OnboardingStatusModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return OnboardingStatusModel(
      currentStep: data['currentStep'] as int?,
      currentStepName: data['currentStepName'] as String?,
      hasAcceptedTerms: data['hasAcceptedTerms'] as bool? ?? false,
      hasSelectedTrack: data['hasSelectedTrack'] as bool? ?? false,
      selectedTrack: data['selectedTrack'] as int?,
      selectedTrackName: data['selectedTrackName'] as String?,
      isOnboardingCompleted: data['isOnboardingCompleted'] as bool? ?? false,
      nextStepRoute: data['nextStepRoute'] as String?,
    );
  }
}
