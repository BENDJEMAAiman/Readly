import 'package:readly/features/auth/model/user_entity.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState{
  const AuthInitial();
}

//i'll use mutiple loading instead of generic one

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class LoginLoading extends AuthState {
  const LoginLoading();
}

final class GoogleLogLoading extends AuthState{
  const GoogleLogLoading();
}

final class SignUpLoading extends AuthState {
  const SignUpLoading();
}

final class ResetPassLoading extends AuthState{
  const ResetPassLoading();
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