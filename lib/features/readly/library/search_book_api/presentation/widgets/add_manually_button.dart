import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/constants/app_assets.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class AddManuallyButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddManuallyButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.buttonBlue,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                AppAssets.addIcon,
                width: 18.w,
                height: 55.w,
                color: AppColors.white,
              ),

              SizedBox(width: 14.w),

              Text(
                "Not found?",
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                "Add Manually",
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
