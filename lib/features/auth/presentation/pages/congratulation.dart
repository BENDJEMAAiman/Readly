import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/constants/app_assets.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_header.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_scaffold.dart';
import 'package:readly/features/auth/presentation/widgets%20/primaryButton.dart';

class Congratulation extends StatefulWidget {
  const Congratulation({super.key});

  @override
  State<Congratulation> createState() => _CongratulationState();
}

class _CongratulationState extends State<Congratulation> {
  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.congratulation,
            width: 137.w,
            height: 158.h,
          ),

          SizedBox(height: 40.h),

          const AuthHeader(
              title: 'Congratulation!',
              subtitle: "You're all set! \nLet's start your reading journey.",
            ),

            SizedBox(height: 24.h),

            /// Login button
            PrimaryButton(
              title: 'Get Started',
              onPressed: () {
                context.go(Routes.search);
              },
            ),

        ],
      ),
    );
  }
}