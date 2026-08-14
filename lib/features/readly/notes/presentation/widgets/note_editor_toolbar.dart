import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';

class NoteEditorToolbar extends StatelessWidget {
  const NoteEditorToolbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58.h,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.grey400,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.format_bold,
            size: 22.sp,
            color: AppColors.primary,
          ),

          SizedBox(width: 18.w),

          Icon(
            Icons.format_italic,
            size: 22.sp,
            color: AppColors.primary,
          ),

          SizedBox(width: 18.w),

          Icon(
            Icons.format_list_bulleted,
            size: 22.sp,
            color: AppColors.primary,
          ),

          SizedBox(width: 18.w),

          Text(
            '"',
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),

          SizedBox(width: 18.w),

          Container(
            width: 1.w,
            height: 24.h,
            color: AppColors.grey400,
          ),

          SizedBox(width: 18.w),

          Icon(
            Icons.image_outlined,
            size: 22.sp,
            color: AppColors.primary,
          ),

          SizedBox(width: 18.w),

          Icon(
            Icons.content_paste_outlined,
            size: 22.sp,
            color: AppColors.primary,
          ),

          const Spacer(),

          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: AppColors.buttonBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              size: 19.sp,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}