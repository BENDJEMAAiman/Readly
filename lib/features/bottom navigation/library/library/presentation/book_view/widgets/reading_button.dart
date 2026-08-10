//this file should be modified later because we need to decide weather we should 
//display start reading or continue reading.....

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class ReadingButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ReadingButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          Icons.play_arrow_rounded,
          color: AppColors.white,
          size: 24.sp,
        ),
        label: Text(
          'Start Reading',
          style: AppTextStyles.headingMedium,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonBlueDark,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }
}