import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/dependency_injection/repositories.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/features/onboarding/business_logic/onboarding_cubit.dart';
import 'package:readly/features/onboarding/business_logic/onboarding_state.dart';
import 'package:readly/features/onboarding/presentation/widgets/onboarding_actions.dart';
import 'package:readly/features/onboarding/presentation/widgets/onboarding_app_bar.dart';
import 'package:readly/features/onboarding/presentation/widgets/onboarding_item.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;

  late final pages;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    pages = onboardingRepository.getPages();
  }

  int _currentPage = 0;

  bool get isLastPage => _currentPage == pages.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (isLastPage) {
      context.read<OnboardingCubit>().finishOnboarding();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _skip() {
    context.read<OnboardingCubit>().finishOnboarding();
  }

  void _signIn() {
    context.read<OnboardingCubit>().finishOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          context.go(Routes.login);
        } else if (state is OnboardingError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: OnboardingAppBar(onSkip: _skip),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    key: const PageStorageKey('onboarding'),
                    controller: _pageController,
                    physics: const ClampingScrollPhysics(),
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      final page = pages[index];

                      return OnboardingItem(
                        imagePath: page.image,
                        title: page.title,
                        description: page.description,
                        currentPage: _currentPage,
                        pageCount: pages.length,
                      );
                    },
                  ),
                ),

                OnboardingActions(
                  isLastPage: isLastPage,
                  onNext: _nextPage,
                  onSignIn: _signIn,
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
