import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class CoverActionButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const CoverActionButton({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: AppColors.white,
          shape: const CircleBorder(),
          elevation: 4,
          shadowColor: Colors.black,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Image.asset(
                iconPath,
                width: 24.w,
                height: 24.h,
              ),
            ),
          ),
        ),

        SizedBox(height: 8.h),

        Text(
          label,
          style: AppTextStyles.labelMedium,
        ),
      ],
    );
  }
}