import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/dependency_injection/repositories.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/features/auth/business_logic/auth_cubit.dart';
import 'package:readly/features/auth/presentation/pages/check_email_password.dart';
import 'package:readly/features/auth/presentation/pages/check_email_verification.dart';
import 'package:readly/features/auth/presentation/pages/congratulation.dart';
import 'package:readly/features/auth/presentation/pages/login_page.dart';
import 'package:readly/features/auth/presentation/pages/sign_up_page.dart';
import 'package:readly/features/auth/presentation/pages/forgot_password.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/business_logic/search_cubit.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/model/search_model.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/presentation/search_screen.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/business%20logic/search_details_cubit.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/presentation/search_details_screen.dart';
import 'package:readly/features/onboarding/business_logic/onboarding_cubit.dart';
import 'package:readly/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:readly/features/splash/business_logic/splash_cubit.dart';
import 'package:readly/features/splash/presentation/splash_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: Routes.search,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => SearchCubit(searchRepository),
          child: const SearchScreen(),
        );
      },
    ),

    GoRoute(
      path: Routes.searchDetails,
      builder: (context, state) {
        final basicInfo = state.extra as SearchModel;

        return BlocProvider(
          create: (_) => SearchDetailsCubit(searchDetailsRepository),
          child: SearchDetailsScreen(basicInfo: basicInfo),
        );
      },
    ),

    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => AuthCubit(authRepository),
          child: const LoginPage(),
        );
      },
    ),

    GoRoute(
      path: Routes.signup,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => AuthCubit(authRepository),
          child: const SignupPage(),
        );
      },
    ),

    GoRoute(
      path: Routes.forgotPassword,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => AuthCubit(authRepository),
          child: const ForgotPassword(),
        );
      },
    ),

    GoRoute(
      path: Routes.checkEmailPassword,
      builder: (context, state) {
        final email = state.extra as String;

        return BlocProvider(
          create: (_) => AuthCubit(authRepository),
          child: CheckEmailPassword(email: email),
        );
      },
    ),

    GoRoute(
      path: Routes.checkEmailVerification,
      builder: (context, state) {
        final email = state.extra as String;

        return BlocProvider(
          create: (_) => AuthCubit(authRepository),
          child: CheckEmailVerification(email: email),
        );
      },
    ),

    GoRoute(
      path: Routes.congratulation,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => AuthCubit(authRepository),
          child: const Congratulation(),
        );
      },
    ),

    GoRoute(
      path: Routes.splash,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => SplashCubit(splashRepository),
          child: const SplashPage(),
        );
      },
    ),

    GoRoute(
      path: Routes.onboarding,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => OnboardingCubit(onboardingRepository),
          child: const OnboardingPage(),
        );
      },
    ),
  ],
);
