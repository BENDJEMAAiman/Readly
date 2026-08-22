import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/constants/app_assets.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/features/auth/business_logic/auth_cubit.dart';
import 'package:readly/features/auth/business_logic/auth_state.dart';
import 'package:readly/features/splash/business_logic/splash_cubit.dart';
import 'package:readly/features/splash/business_logic/splash_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    context.read<SplashCubit>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state is NavigateToOnboarding) {
              context.go(Routes.onboarding);
            }

            if (state is CheckAuthentication) {
              context.read<AuthCubit>().checkAuthStatus();
            }
          },
        ),

        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              context.go(Routes.home);
            }

            if (state is Unauthenticated) {
              context.go(Routes.login);
            }

            if (state is EmailVerificationRequired) {
              context.go(
                Routes.checkEmailVerification,
                extra: state.user.email,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFC3D9EE),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppAssets.splashSticker,
                  width: 247.w,
                  height: 162.h,
                ),

                SizedBox(height: 24.h),

                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Baloo2',
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    children: const [
                      TextSpan(
                        text: 'Read',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: 'ly',
                        style: TextStyle(color: Color(0xFFFEE08F)),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  'Read a little, every day.',
                  style: TextStyle(
                    fontFamily: 'Baloo2',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFF8F5EF),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
