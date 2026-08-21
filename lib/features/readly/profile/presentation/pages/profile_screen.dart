import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/routing/routes.dart';

import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/features/auth/business_logic/auth_cubit.dart';
import 'package:readly/features/auth/business_logic/auth_state.dart';
import 'package:readly/features/readly/profile/business_logic/profile_cubit.dart';
import 'package:readly/features/readly/profile/business_logic/profile_state.dart';
import 'package:readly/features/readly/profile/presentation/widgets/logout_bottom_sheet.dart';
import 'package:readly/features/readly/profile/presentation/widgets/profile_menu_card.dart';
import 'package:readly/features/readly/profile/presentation/widgets/profile_stat_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showLogoutBottomSheet(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: authCubit,
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final isLoading = state is LogoutLoading;

              return LogoutBottomSheet(
                isLoading: isLoading,
                onLogout: () {
                  context.read<AuthCubit>().signOut();
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go(Routes.login);
        }

        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                final stats = state.stats;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 24.h,
                  ),
                  child: Column(
                    children: [
                      // Temporary empty space/header for now.
                      SizedBox(height: 30.h),

                      Row(
                        children: [
                          ProfileStatCard(
                            value: stats.booksCompleted.toString(),
                            label: 'Books read',
                          ),

                          SizedBox(width: 12.w),

                          ProfileStatCard(
                            value: stats.pagesRead.toString(),
                            label: 'Pages read',
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      ProfileMenuCard(
                        onAccountPressed: () {
                          // We will handle navigation later.
                        },

                        onReadingGoalsPressed: () {
                          // We will handle navigation later.
                        },

                        onLogoutPressed: () {
                          _showLogoutBottomSheet(context);
                        },
                      ),

                      // Menu comes next.
                    ],
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
