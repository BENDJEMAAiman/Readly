import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class LogoutBottomSheet extends StatelessWidget {
  const LogoutBottomSheet({
    super.key,
    required this.onLogout,
    required this.isLoading,
  });

  final VoidCallback onLogout;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Logout',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 12.h),

            Text(
              'Are you sure you want to log out of your account?',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryLight,
                height: 1.5,
              ),
            ),

            SizedBox(height: 24.h),

            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: isLoading ? null : onLogout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBlueDark,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 22.w,
                        height: 22.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : Text(
                        'Logout',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            SizedBox(height: 10.h),

            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: OutlinedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        Navigator.of(context).pop();
                      },
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.secondaryLight,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
