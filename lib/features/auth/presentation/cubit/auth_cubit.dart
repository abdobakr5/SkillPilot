import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_strings.dart';
import '../../data/repositories/auth_repository_impl.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(const AuthInitial());

  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    emit(const AuthLoading());

    final result = await authRepository.login(
      email: email,
      password: password,
      rememberMe: rememberMe,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authToken) => emit(LoginSuccess(authToken)),
    );
  }

  Future<void> register({
    required String email,
    required String password,
    String? userName,
  }) async {
    emit(const AuthLoading());

    final result = await authRepository.register(
      email: email,
      password: password,
      userName: userName,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const RegisterSuccess(AppStrings.msgRegistrationSuccess)),
    );
  }

  Future<void> forgotPassword({required String email}) async {
    emit(const AuthLoading());

    final result = await authRepository.forgotPassword(email: email);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const ForgotPasswordSuccess(AppStrings.msgResetEmailSent)),
    );
  }

  Future<void> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    emit(const AuthLoading());

    final result = await authRepository.resetPassword(
      email: email,
      token: token,
      newPassword: newPassword,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const ResetPasswordSuccess(AppStrings.msgPasswordResetSuccess)),
    );
  }

  Future<bool> validateResetToken({
    required String email,
    required String token,
  }) async {
    final result = await authRepository.validateResetToken(
      email: email,
      token: token,
    );
    return result.fold(
      (failure) {
        emit(AuthError(failure.message));
        return false;
      },
      (isValid) => isValid,
    );
  }

  Future<void> loginWithGoogle({
    String? idToken,
    String? accessToken,
  }) async {
    emit(const AuthLoading());

    final result = await authRepository.loginWithGoogle(
      idToken: idToken,
      accessToken: accessToken,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authToken) => emit(LoginSuccess(authToken)),
    );
  }

  Future<void> loginWithGitHub({
    required String code,
  }) async {
    emit(const AuthLoading());

    final result = await authRepository.loginWithGitHub(
      code: code,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authToken) => emit(LoginSuccess(authToken)),
    );
  }

  void resetState() {
    emit(const AuthInitial());
  }
}
