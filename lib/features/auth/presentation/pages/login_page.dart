import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/core/validators/auth_validators.dart';
import 'package:readly/features/auth/business_logic/auth_cubit.dart';
import 'package:readly/features/auth/business_logic/auth_state.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_header.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_scaffold.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_switch_text.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_text_field.dart';
import 'package:readly/features/auth/presentation/widgets%20/divider_with_text.dart';
import 'package:readly/features/auth/presentation/widgets%20/google_sign_in_button.dart';
import 'package:readly/features/auth/presentation/widgets%20/primaryButton.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _emailFocus.dispose();
    _passwordFocus.dispose();

    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthCubit>().signInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go(Routes.search);
        } else if (state is EmailVerificationRequired) {
          context.go(Routes.checkEmailVerification, extra: state.user.email);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: AuthScaffold(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              const AuthHeader(
                title: 'Welcome Back',
                subtitle: 'Sign to your account',
              ),

              SizedBox(height: 40.h),

              /// Email
              AuthTextField(
                label: 'Email',
                hintText: 'Enter your email',
                controller: _emailController,
                validator: AuthValidators.email,
                focusNode: _emailFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocus);
                },
              ),

              SizedBox(height: 20.h),

              /// Password
              AuthTextField(
                label: 'Password',
                hintText: 'Enter your password',
                controller: _passwordController,
                validator: AuthValidators.password,
                obscureText: true,
                focusNode: _passwordFocus,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _login(),
              ),

              SizedBox(height: 12.h),

              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    context.push(Routes.forgotPassword);
                  },
                  child: Text(
                    'Forgot Password?',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              /// Login button
              BlocBuilder<AuthCubit, AuthState>(
                buildWhen: (previous, current) =>
                    previous is LoginLoading || current is LoginLoading,
                builder: (context, state) {
                  return PrimaryButton(
                    title: 'Login',
                    isLoading: state is LoginLoading,
                    onPressed: _login,
                  );
                },
              ),

              SizedBox(height: 20.h),

              /// Switch to signup
              AuthSwitchText(
                text: "Don't have an account? ",
                actionText: "Sign Up",
                onTap: () {
                  context.push(Routes.signup);
                },
              ),

              SizedBox(height: 28.h),

              /// Divider
              const DividerWithText(text: 'Or with'),

              SizedBox(height: 24.h),

              BlocBuilder<AuthCubit, AuthState>(
                buildWhen: (previous, current) =>
                    previous is GoogleLogLoading || current is GoogleLogLoading,
                builder: (context, state) {
                  return GoogleSignInButton(
                    isLoading: state is GoogleLogLoading,
                    onPressed: () {
                      context.read<AuthCubit>().signInWithGoogle();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
