import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/utils/app_constants.dart';

class GoogleAuthResult {
  final String? idToken;
  final String? accessToken;

  const GoogleAuthResult({
    this.idToken,
    this.accessToken,
  });
}

class OAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: AppConstants.googleAndroidClientId.isNotEmpty
        ? AppConstants.googleAndroidClientId
        : null,
    serverClientId: AppConstants.googleServerClientId.isNotEmpty
        ? AppConstants.googleServerClientId
        : null,
    scopes: ['email', 'profile'],
  );

  /// Initiates native/web Google Sign In flow.
  /// Returns [GoogleAuthResult] with tokens, or null if cancelled by the user.
  Future<GoogleAuthResult?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        return null; // User cancelled
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      return GoogleAuthResult(
        idToken: auth.idToken,
        accessToken: auth.accessToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Initiates GitHub OAuth flow via secure browser tab.
  /// Captures the authorization code from deep link redirect.
  Future<String?> signInWithGitHub({String? clientId}) async {
    final effectiveClientId = (clientId != null && clientId.isNotEmpty)
        ? clientId
        : AppConstants.gitHubClientId;

    final url = 'https://github.com/login/oauth/authorize'
        '?client_id=$effectiveClientId'
        '&redirect_uri=${Uri.encodeComponent(AppConstants.gitHubRedirectUri)}'
        '&scope=read:user%20user:email';

    try {
      final result = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: 'skillpilot',
      );

      final uri = Uri.parse(result);
      final code = uri.queryParameters['code'];
      return code;
    } catch (e) {
      rethrow;
    }
  }
}
