import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/auth/business_logic/auth_cubit.dart';
import 'package:readly/features/auth/business_logic/auth_state.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthCubit>().state;

    String name = '';

    if (authState is Authenticated) {
      name = authState.user.displayName ?? '';
    }

    _nameController = TextEditingController(text: name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is! Authenticated) {
              return const SizedBox();
            }

            final user = state.user;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 22.h),

                        // Header
                        _buildHeader(),

                        SizedBox(height: 28.h),

                        // Profile picture
                        _buildProfilePicture(
                          user.photoUrl,
                        ),

                        SizedBox(height: 10.h),

                        // Change picture
                        Center(
                          child: GestureDetector(
                            onTap: _changeProfilePicture,
                            child: Text(
                              'Change Picture',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 32.h),

                        // Full name
                        _buildLabel('Full name'),

                        SizedBox(height: 6.h),

                        _buildNameField(),

                        SizedBox(height: 12.h),

                        // Email
                        _buildLabel('Email'),

                        SizedBox(height: 6.h),

                        _buildEmailField(user.email),
                      ],
                    ),
                  ),
                ),

                // Your existing bottom navigation should stay here.
                // Replace this with your actual navigation widget.
                _buildBottomNavigation(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: SizedBox(
            width: 32.w,
            height: 32.w,
            child: Icon(
              Icons.arrow_back_rounded,
              size: 22.sp,
              color: AppColors.primary,
            ),
          ),
        ),

        Expanded(
          child: Center(
            child: Text(
              'My Account',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.primary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),

        // Keeps the title perfectly centered.
        SizedBox(width: 32.w),
      ],
    );
  }

  Widget _buildProfilePicture(String? photoUrl) {
    return Center(
      child: GestureDetector(
        onTap: _changeProfilePicture,
        child: Container(
          width: 72.w,
          height: 72.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: photoUrl != null && photoUrl.isNotEmpty
                ? Image.network(
                    photoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return _profilePlaceholder();
                    },
                  )
                : _profilePlaceholder(),
          ),
        ),
      ),
    );
  }

  Widget _profilePlaceholder() {
    return Container(
      color: AppColors.secondaryLight,
      child: Icon(
        Icons.person_rounded,
        size: 34.sp,
        color: AppColors.buttonBlueDark,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.primary,
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildNameField() {
    return TextField(
      controller: _nameController,
      textInputAction: TextInputAction.done,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.primary,
        fontSize: 11.sp,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 11.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.r),
          borderSide: BorderSide(
            color: AppColors.divider,
            width: 1.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.r),
          borderSide: BorderSide(
            color: AppColors.divider,
            width: 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.r),
          borderSide: BorderSide(
            color: AppColors.secondary,
            width: 1.w,
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(String? email) {
    return TextField(
      controller: TextEditingController(
        text: email ?? '',
      ),
      enabled: false,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.primaryLight,
        fontSize: 11.sp,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.white,

        contentPadding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 11.h,
        ),

        // 🔒 Indicates that this field cannot be changed.
        suffixIcon: Icon(
          Icons.lock_outline_rounded,
          size: 16.sp,
          color: AppColors.primaryLight,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.r),
          borderSide: BorderSide(
            color: AppColors.divider,
            width: 1.w,
          ),
        ),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.r),
          borderSide: BorderSide(
            color: AppColors.divider,
            width: 1.w,
          ),
        ),
      ),
    );
  }

  void _changeProfilePicture() {
    // We will connect this to your existing
    // ProfileCubit picture upload logic next.
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 64.h,
      color: AppColors.white,
      child: const SizedBox(),
    );
  }
}