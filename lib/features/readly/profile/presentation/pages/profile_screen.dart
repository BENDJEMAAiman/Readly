import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/auth/business_logic/auth_cubit.dart';
import 'package:readly/features/auth/business_logic/auth_state.dart';
import 'package:readly/features/readly/profile/business_logic/profile_cubit.dart';
import 'package:readly/features/readly/profile/business_logic/profile_state.dart';
import 'package:readly/features/readly/profile/model/user_stats.dart';
import 'package:readly/features/readly/profile/presentation/widgets/logout_bottom_sheet.dart';
import 'package:readly/features/readly/profile/presentation/widgets/profile_header.dart';
import 'package:readly/features/readly/profile/presentation/widgets/profile_menu_card.dart';
import 'package:readly/features/readly/profile/presentation/widgets/profile_stat_card.dart';
import 'package:readly/features/readly/profile/presentation/widgets/reading_goal_bottom_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showReadingGoalBottomSheet(BuildContext context, UserStats stats) {
    final profileCubit = context.read<ProfileCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: profileCubit,
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is! ProfileLoaded) {
                return const SizedBox();
              }

              final isLoading =
                  state.readingGoalStatus == ReadingGoalStatus.saving;

              return ReadingGoalBottomSheet(
                initialPages: state.stats.dailyGoalPages,
                initialMinutes: state.stats.dailyGoalMinutes,
                isLoading: isLoading,
                onSave: ({required int pages, required int minutes}) {
                  context.read<ProfileCubit>().updateReadingGoals(
                    dailyGoalPages: pages,
                    dailyGoalMinutes: minutes,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _showDeleteProfilePictureDialog() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),

          title: Text(
            'Delete profile picture?',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.buttonBlueDark,
              fontWeight: FontWeight.w600,
            ),
          ),

          content: Text(
            'Are you sure you want to remove your profile picture?',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey500,
              height: 1.5,
            ),
          ),

          actionsPadding: EdgeInsets.zero,

          actions: [
            SizedBox(
              height: 52.h,
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(false);
                      },
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.buttonBlueDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  Container(
                    width: 1.w,
                    height: 52.h,
                    color: AppColors.buttonBlueDark.withValues(alpha: 0.25),
                  ),

                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(true);
                      },
                      child: Text(
                        'Delete',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.buttonBlueDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true && mounted) {
      context.read<ProfileCubit>().deleteProfilePicture();
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickProfilePicture() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedImage == null) {
        return;
      }

      final imageFile = File(pickedImage.path);

      if (!mounted) return;

      context.read<ProfileCubit>().updateProfilePicture(imageFile);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to select image: $e')));
    }
  }

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
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
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
        ),

        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded &&
                state.readingGoalStatus == ReadingGoalStatus.success) {
              Navigator.of(context).pop();
            }
            if (state is ProfileLoaded &&
                state.readingGoalStatus == ReadingGoalStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.readingGoalError ?? 'Failed to update reading goals.',
                  ),
                ),
              );
            }
            if (state is ProfileLoaded &&
                state.pictureStatus == ProfilePictureStatus.success) {
              context.read<AuthCubit>().checkAuthStatus();
            }

            if (state is ProfileLoaded &&
                state.pictureStatus == ProfilePictureStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.pictureError ?? 'Failed to update profile picture.',
                  ),
                ),
              );
            }
          },
        ),
      ],

      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                final stats = state.stats;

                return BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                    debugPrint(
                      'PROFILE SCREEN AUTH STATE: ${authState.runtimeType}',
                    );

                    String name = 'Reader';
                    String? photoUrl;

                    if (authState is Authenticated) {
                      debugPrint(
                        'PROFILE SCREEN DISPLAY NAME: ${authState.user.displayName}',
                      );

                      final displayName = authState.user.displayName;

                      if (displayName != null &&
                          displayName.trim().isNotEmpty) {
                        name = displayName.trim();
                      }

                      photoUrl = authState.user.photoUrl;
                      debugPrint('FINAL PROFILE NAME: $name');
                    }

                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 24.h,
                      ),
                      child: Column(
                        children: [
                          ProfileHeader(
                            name: name,
                            photoUrl: photoUrl,
                            onImagePressed: _pickProfilePicture,
                            onDeletePressed: _showDeleteProfilePictureDialog,
                          ),

                          SizedBox(height: 30.h),

                          Row(
                            children: [
                              Expanded(
                                child: ProfileStatCard(
                                  value: stats.booksCompleted.toString(),
                                  label: 'Books read',
                                ),
                              ),

                              SizedBox(width: 12.w),

                              Expanded(
                                child: ProfileStatCard(
                                  value: stats.pagesRead.toString(),
                                  label: 'Pages read',
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 24.h),

                          ProfileMenuCard(
                            onAccountPressed: () {},
                            onReadingGoalsPressed: () {
                              _showReadingGoalBottomSheet(context, stats);
                            },
                            onLogoutPressed: () {
                              _showLogoutBottomSheet(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
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
