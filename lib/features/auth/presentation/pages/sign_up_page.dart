import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/features/auth/presentation/validators/auth_validators.dart';
import 'package:readly/features/auth/business_logic/auth_cubit.dart';
import 'package:readly/features/auth/business_logic/auth_state.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_header.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_scaffold.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_switch_text.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_text_field.dart';
import 'package:readly/features/auth/presentation/widgets%20/primaryButton.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _nameController = TextEditingController();
  final _nameFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();

    _emailFocus.dispose();
    _passwordFocus.dispose();
    _nameFocus.dispose();

    super.dispose();
  }

  void _signUp() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthCubit>().signUpWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackButton: false,
      child: BlocListener<AuthCubit, AuthState>(
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 26.h),

              /// Header
              const AuthHeader(
                title: 'Sign Up',
                subtitle: 'Create an account and start reading ',
              ),

              SizedBox(height: 40.h),

              /// Full Name
              AuthTextField(
                label: 'Full Name',
                hintText: 'Enter your name',
                controller: _nameController,
                validator: AuthValidators.fullName,
                focusNode: _nameFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_emailFocus);
                },
              ),

              SizedBox(height: 20.h),

              /// Email
              AuthTextField(
                label: 'Email',
                hintText: 'Enter your email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
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
                hintText: 'Enter your new password',
                controller: _passwordController,
                obscureText: true,
                validator: AuthValidators.password,
                focusNode: _passwordFocus,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _signUp(),
              ),

              SizedBox(height: 32.h),

              /// Sign Up Button
              BlocBuilder<AuthCubit, AuthState>(
                buildWhen: (previous, current) =>
                    previous is SignUpLoading || current is SignUpLoading,
                builder: (context, state) {
                  return PrimaryButton(
                    title: 'Sign Up',
                    isLoading: state is SignUpLoading,
                    onPressed: _signUp,
                  );
                },
              ),

              SizedBox(height: 20.h),

              /// Already have account
              AuthSwitchText(
                text: 'Have an account? ',
                actionText: 'Sign In',
                onTap: () {
                  context.push(Routes.login);
                },
              ),

              SizedBox(height: 80.h),

              /// Terms & Policy
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'By clicking Sign Up, you agree to our\n',
                    style: Theme.of(context).textTheme.bodySmall,
                    children: [
                      TextSpan(
                        text: 'Terms and Data Policy.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
