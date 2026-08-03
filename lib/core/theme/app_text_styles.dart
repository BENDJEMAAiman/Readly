
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  /// Large page titles
  static final headingLarge = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    height: 1.35,
    letterSpacing: -0.84,
  );

  static final headingMedium = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    height: 1.5,
    letterSpacing: .3,
  );

  static final bodyLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static final bodyMedium = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static final bodyPrimary = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    height: 1.5,
  );

  static final labelMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    height: 1.4,
  );

  static final labelSemiBold = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    height: 1.4,
  );

  static final hintText = TextStyle(
    fontFamily: "Nunito",
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.grey400,
    height: 1.5,
  );

  static final googleButton = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
    height: 24 / 14,
  );
}
