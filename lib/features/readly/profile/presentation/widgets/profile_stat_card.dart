import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class ProfileStatCard extends StatelessWidget {
  const ProfileStatCard({
    super.key,
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 88.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.buttonBlueDark,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 5.h),

            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryLight,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}