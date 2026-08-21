import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readly/features/auth/business_logic/auth_state.dart';
import 'package:readly/features/auth/data/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  AuthCubit(this.authRepository) : super(const AuthInitial());

  Future<void> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(const SignUpLoading());

    try {
      final user = await authRepository.signUpWithEmail(
         name: name,
        email: email,
        password: password,
      );

      if (user.emailVerified) {
        emit(Authenticated(user));
      } else {
        emit(EmailVerificationRequired(user));
      }
    } catch (e, stackTrace) {
      debugPrint('ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    emit(const LoginLoading());

    try {
      final user = await authRepository.signInWithEmail(
        email: email,
        password: password,
      );

      if (user.emailVerified) {
        emit(Authenticated(user));
      } else {
        emit(EmailVerificationRequired(user));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());

    try {
      final user = await authRepository.checkAuthStatus();

      if (user == null) {
        emit(const Unauthenticated());
        return;
      }

      if (user.emailVerified) {
        emit(Authenticated(user));
      } else {
        emit(EmailVerificationRequired(user));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(const ResetPassLoading());

    try {
      await authRepository.resetPassword(email);

      emit(const PasswordResetEmailSent());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> sendEmailVerification() async {
    emit(const AuthLoading());

    try {
      await authRepository.sendEmailVerification();

      emit(const VerificationEmailSent());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(const LogoutLoading());

    try {
      await authRepository.signOut();
      emit(const Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(const GoogleLogLoading());

    try {
      final user = await authRepository.signInWithGoogle();

      if (user.emailVerified) {
        emit(Authenticated(user));
      } else {
        emit(EmailVerificationRequired(user));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
