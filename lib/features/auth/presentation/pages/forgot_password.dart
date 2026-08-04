import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/core/validators/auth_validators.dart';
import 'package:readly/features/auth/business_logic/auth_cubit.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_header.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_scaffold.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_text_field.dart';
import 'package:readly/features/auth/presentation/widgets%20/primaryButton.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            const AuthHeader(
              title: 'Forgot Password',
              subtitle: 'Please enter the email to reset your password',
            ),

            SizedBox(height: 40.h),

            /// Email
            AuthTextField(
              label: 'Email',
              hintText: 'Your email',
              controller: _emailController,
              validator: AuthValidators.email,
              focusNode: _emailFocus,
              textInputAction: TextInputAction.next,
            ),

            SizedBox(height: 24.h),

            /// Login button
            PrimaryButton(
              title: 'Reset Password',
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }

                context.read<AuthCubit>().resetPassword(
                  _emailController.text.trim(),
                );
                context.go(
                  Routes.checkEmailPassword,
                  extra: _emailController.text.trim(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
