import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.memberSince,
    this.photoUrl,
  });

  final String name;
  final String memberSince;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildProfilePicture(),

        SizedBox(height: 14.h),

        Text(
          name,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.primary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: 4.h),

        Text(
          'Reading with Readly since $memberSince',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primaryLight,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePicture() {
    return Container(
      width: 76.w,
      height: 76.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.secondaryLight,
        border: Border.all(
          color: AppColors.buttonBlueDark,
          width: 2.w,
        ),
      ),
      child: ClipOval(
        child: photoUrl != null && photoUrl!.isNotEmpty
            ? Image.network(
                photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return _placeholder();
                },
              )
            : _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Icon(
      Icons.person_rounded,
      size: 38.sp,
      color: AppColors.buttonBlueDark,
    );
  }
}