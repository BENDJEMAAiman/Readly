import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class GenreChip extends StatelessWidget {
  final String genre;

  const GenreChip({
    super.key,
    required this.genre,
  });

  @override
 Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondaryLight2,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Text(
        genre,
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.secondary,
        ),
      ),
    );
  }
}