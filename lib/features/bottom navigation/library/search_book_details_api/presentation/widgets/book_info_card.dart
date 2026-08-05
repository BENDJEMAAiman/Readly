import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class BookInfoCard extends StatelessWidget {
  final String title;
  final String author;
  final String status;

  const BookInfoCard({
    super.key,
    required this.title,
    required this.author,
    required this.status, //this also need to be modified when i add the reading cubit
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.headingLarge.copyWith(
              fontSize: 22.sp,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 6.h),

          Text(
            author,
            style: AppTextStyles.bodyPrimary.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 12.h),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 6.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF1C8),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              status,
              style: AppTextStyles.labelMedium.copyWith(
                color: const Color(0xFF7D6B1F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}