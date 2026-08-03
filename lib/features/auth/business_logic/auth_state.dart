import 'package:readly/features/auth/model/user_entity.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState{
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class Authenticated extends AuthState {
  final UserEntity user;

  const Authenticated(this.user);
}

final class Unauthenticated extends AuthState {
  const Unauthenticated();
}

final class EmailVerificationRequired extends AuthState {
  final UserEntity user;

  const EmailVerificationRequired(this.user);
}

final class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}

final class PasswordResetEmailSent extends AuthState {
  const PasswordResetEmailSent();
}

final class VerificationEmailSent extends AuthState {
  const VerificationEmailSent();
}