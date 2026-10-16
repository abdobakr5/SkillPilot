import 'dart:convert';

class JwtHelper {
  JwtHelper._();

  /// Decodes the payload portion of a JWT string into a Map
  static Map<String, dynamic>? decodePayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return null;

      var payloadBase64 = parts[1];
      // Normalize padding for base64url
      payloadBase64 = base64Url.normalize(payloadBase64);
      final decodedBytes = base64Url.decode(payloadBase64);
      final decodedString = utf8.decode(decodedBytes);
      final dynamic jsonMap = json.decode(decodedString);

      if (jsonMap is Map<String, dynamic>) {
        return jsonMap;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Extracts the authenticated user's email from JWT claims
  static String? extractEmail(String token) {
    final payload = decodePayload(token);
    if (payload == null) return null;

    const emailKeys = [
      'email',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress',
      'email_address',
      'preferred_username',
      'unique_name',
      'sub',
      'upn',
    ];

    for (final key in emailKeys) {
      final val = payload[key];
      if (val is String && val.contains('@')) {
        return val.trim();
      }
    }

    return null;
  }

  /// Extracts the authenticated user's display name or username
  static String? extractUserName(String token) {
    final payload = decodePayload(token);
    if (payload == null) return null;

    const nameKeys = [
      'name',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name',
      'given_name',
      'unique_name',
      'sub',
    ];

    for (final key in nameKeys) {
      final val = payload[key];
      if (val is String && val.trim().isNotEmpty && !val.contains('@')) {
        return val.trim();
      }
    }

    return null;
  }
}
