import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/readly/profile/presentation/widgets/profile_menu_item.dart';

class ProfileMenuCard extends StatelessWidget {
  const ProfileMenuCard({
    super.key,
    required this.onAccountPressed,
    required this.onReadingGoalsPressed,
    required this.onLogoutPressed,
  });

  final VoidCallback onAccountPressed;
  final VoidCallback onReadingGoalsPressed;
  final VoidCallback onLogoutPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              16.w,
              16.h,
              16.w,
              8.h,
            ),
            child: Text(
              'Account',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          ProfileMenuItem(
            title: 'My account',
            onTap: onAccountPressed,
          ),

          _buildDivider(),

          ProfileMenuItem(
            title: 'Reading goals',
            onTap: onReadingGoalsPressed,
          ),

          _buildDivider(),

          ProfileMenuItem(
            title: 'Log out',
            onTap: onLogoutPressed,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      color: AppColors.divider,
    );
  }
}