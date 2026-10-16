import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:skillpilot/core/utils/jwt_helper.dart';

void main() {
  group('JwtHelper Tests', () {
    test('extracts email from standard email claim in JWT', () {
      final payload = json.encode({
        'email': 'alex.dev@gmail.com',
        'sub': '101',
      });
      final base64Payload = base64Url.encode(utf8.encode(payload)).replaceAll('=', '');
      final token = 'eyJhbGciOiJIUzI1NiJ9.$base64Payload.dummy_sig';

      final email = JwtHelper.extractEmail(token);
      expect(email, 'alex.dev@gmail.com');
    });

    test('extracts email from ASP.NET Core identity claim in JWT', () {
      final payload = json.encode({
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress':
            'sarah.connor@cyber.io',
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name': 'Sarah',
      });
      final base64Payload = base64Url.encode(utf8.encode(payload)).replaceAll('=', '');
      final token = 'eyJhbGciOiJIUzI1NiJ9.$base64Payload.dummy_sig';

      final email = JwtHelper.extractEmail(token);
      expect(email, 'sarah.connor@cyber.io');
    });

    test('extracts username from name claim in JWT', () {
      final payload = json.encode({
        'email': 'user@example.com',
        'name': 'Alex Developer',
      });
      final base64Payload = base64Url.encode(utf8.encode(payload)).replaceAll('=', '');
      final token = 'eyJhbGciOiJIUzI1NiJ9.$base64Payload.dummy_sig';

      final name = JwtHelper.extractUserName(token);
      expect(name, 'Alex Developer');
    });

    test('returns null gracefully for invalid or malformed tokens', () {
      expect(JwtHelper.extractEmail(''), isNull);
      expect(JwtHelper.extractEmail('not.a.valid.jwt.token'), isNull);
      expect(JwtHelper.decodePayload('single_string'), isNull);
    });
  });
}
