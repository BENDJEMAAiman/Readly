import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class BookInfoTile extends StatelessWidget {
  final String label;
  final String value;

  const BookInfoTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 110.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey400),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.labelSemiBold.copyWith(
              fontSize: 11.sp,
              letterSpacing: 1.2,
              color: AppColors.primaryLight,
            ),
          ),

          SizedBox(height: 10.h),

          Text(
            value,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyPrimary.copyWith(fontSize: 18.sp),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
