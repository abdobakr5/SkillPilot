import 'package:flutter_test/flutter_test.dart';
import 'package:skillpilot/features/setup/data/models/profile_models.dart';
import 'package:skillpilot/features/setup/data/models/track_model.dart';

void main() {
  group('Profile Models Tests', () {
    test('ProfileBasicInfoModel serialize & deserialize correctly', () {
      final json = {
        'fullName': 'Alex Chen',
        'location': 'San Francisco, CA',
        'linkedInUrl': 'https://linkedin.com/in/alexchen',
      };

      final model = ProfileBasicInfoModel.fromJson(json);
      expect(model.fullName, 'Alex Chen');
      expect(model.location, 'San Francisco, CA');
      expect(model.linkedInUrl, 'https://linkedin.com/in/alexchen');

      final serialized = model.toJson();
      expect(serialized['fullName'], 'Alex Chen');
    });

    test('ProfileEducationModel serialize & deserialize correctly', () {
      final json = {
        'degree': 'B.S. Computer Science',
        'institution': 'UC Berkeley',
        'years': '2018 - 2022',
      };

      final model = ProfileEducationModel.fromJson(json);
      expect(model.degree, 'B.S. Computer Science');
      expect(model.institution, 'UC Berkeley');
      expect(model.years, '2018 - 2022');
    });

    test('ProfileProjectModel parses tags correctly', () {
      final json = {
        'title': 'Distributed KV',
        'description': 'Raft consensus in Rust',
        'tags': ['Rust', 'Raft'],
      };

      final model = ProfileProjectModel.fromJson(json);
      expect(model.title, 'Distributed KV');
      expect(model.tags, contains('Rust'));
      expect(model.tags.length, 2);
    });

    test('ProfileDataModel full parse handles clean envelope structure', () {
      final json = {
        'data': {
          'profileData': {
            'basicInfo': {
              'fullName': 'Sarah Connor',
              'location': 'Los Angeles, CA',
            },
            'education': [
              {
                'degree': 'Cybersecurity M.S.',
                'institution': 'MIT',
                'years': '2020 - 2022',
              }
            ],
            'projects': [
              {
                'title': 'Defense AI',
                'description': 'Securing critical grids',
                'tags': ['Python', 'AI'],
              }
            ],
            'skills': ['Python', 'C++', 'Security'],
          }
        }
      };

      final model = ProfileDataModel.fromJson(json);
      expect(model.basicInfo?.fullName, 'Sarah Connor');
      expect(model.education.length, 1);
      expect(model.projects.first.title, 'Defense AI');
      expect(model.skills, contains('Python'));
    });

    test('kSkillPilotTracks contains all 11 defined engineering tracks', () {
      expect(kSkillPilotTracks.length, 11);
      expect(kSkillPilotTracks.first.title, 'Frontend Development');
      expect(kSkillPilotTracks.any((t) => t.id == 2 && t.title == 'Backend Development'), isTrue);
      expect(kSkillPilotTracks.any((t) => t.id == 4 && t.title == 'Mobile App Development'), isTrue);
      expect(kSkillPilotTracks.any((t) => t.id == 6 && t.title == 'AI & Machine Learning'), isTrue);
    });
  });
}
