import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/features/auth/business_logic/auth_cubit.dart';
import 'package:readly/features/auth/business_logic/auth_state.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_header.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_scaffold.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_switch_text.dart';
import 'package:readly/features/auth/presentation/widgets%20/primaryButton.dart';

class CheckEmailVerification extends StatefulWidget {
  final String email;
  const CheckEmailVerification({super.key, required this.email});

  @override
  State<CheckEmailVerification> createState() => _CheckEmailVerificationState();
}

class _CheckEmailVerificationState extends State<CheckEmailVerification> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go(Routes.congratulation);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: AuthScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Header
            AuthHeader(
              title: 'Check Your Email',
              subtitle: 'We sent a Verification link to\n${widget.email}',
            ),

            SizedBox(height: 20.h),

            /// Switch to signup
            AuthSwitchText(
              text: "if you didn't receive an email ",
              actionText: "Resend",
              onTap: () {
                context.read<AuthCubit>().sendEmailVerification();
              },
            ),

            SizedBox(height: 24.h),

            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return PrimaryButton(
                  title: "I've Verified",
                  isLoading: state is AuthLoading,
                  onPressed: () {
                    context.read<AuthCubit>().checkAuthStatus();
                  },
                );
              },
            ),

            SizedBox(height: 24.h),

            AuthSwitchText(
              text: 'go back to',
              actionText: 'Sign In',
              onTap: () {
                context.go(Routes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
