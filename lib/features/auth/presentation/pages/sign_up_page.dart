import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/core/validators/auth_validators.dart';
import 'package:readly/features/auth/business_logic/auth_cubit.dart';
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


  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
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
          ),

          SizedBox(height: 20.h),

          /// Email
          AuthTextField(
            label: 'Email',
            hintText: 'Enter your email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: AuthValidators.email,
          ),

          SizedBox(height: 20.h),

          /// Password
          AuthTextField(
            label: 'Password',
            hintText: 'Enter your new password',
            controller: _passwordController,
            obscureText: true,
            validator: AuthValidators.password,
          ),

          SizedBox(height: 32.h),

          /// Sign Up Button
          PrimaryButton(
            title: 'Sign up',
            onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                context.read<AuthCubit>().signUpWithEmail(
                  email: _emailController.text.trim(),
                  password: _passwordController.text,
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

          SizedBox(height: 100.h),

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
    );
  }
}