import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/validators/auth_validators.dart';
import 'package:readly/features/auth/business_logic/auth_cubit.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_header.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_scaffold.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_text_field.dart';
import 'package:readly/features/auth/presentation/widgets%20/primaryButton.dart';

class SetNewPassword extends StatefulWidget {
  const SetNewPassword({super.key});

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  final _formKey = GlobalKey<FormState>();
  final _confirmPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _confirmPasswordController.dispose();
    _passwordController.dispose();

    _confirmPasswordFocus.dispose();
    _passwordFocus.dispose();

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
                label: 'Password',
                hintText: 'Enter your password',
                controller: _passwordController,
                validator: AuthValidators.password,
                obscureText: true,
                focusNode: _passwordFocus,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_confirmPasswordFocus);
                },
              ),

              AuthTextField(
                label: 'Confirm Password',
                hintText: 'Re-enter password',
                controller: _confirmPasswordController,
                validator: AuthValidators.password,
                obscureText: true,
                focusNode: _passwordFocus,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  if (_formKey.currentState!.validate()) {
                    context.read<AuthCubit>();
                  }
                },
              ),

            SizedBox(height: 24.h),

            /// Login button
            PrimaryButton(
              title: 'Reset Password',
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }

                context.read<AuthCubit>().
              },
            ),
          ],
        ),
      ),
    );
  }
}
