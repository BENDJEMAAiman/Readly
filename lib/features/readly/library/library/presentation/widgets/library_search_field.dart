import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class LibrarySearchField extends StatelessWidget {
  const LibrarySearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

   final TextEditingController controller;
  final ValueChanged<String> onChanged;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 55.h,
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: "Search your library...",
            hintStyle: AppTextStyles.hintText,

            prefixIcon: Icon(
              Icons.search,
              color: AppColors.grey500,
              size: 22.sp,
            ),

            filled: true,
            fillColor: AppColors.white,

            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 16.h,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.r),
              borderSide: BorderSide(
                color: AppColors.grey400,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.r),
              borderSide: BorderSide(
                color: AppColors.secondary,
                width: 1.5,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.r),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.r),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
          ),
        ),
      );
  }
}