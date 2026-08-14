import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class NoteTitleField extends StatelessWidget {
  const NoteTitleField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.next,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: 'Note Title',
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.grey400,
          fontWeight: FontWeight.w600,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.grey400,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.grey400,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.secondary,
            width: 1.5,
          ),
        ),
        contentPadding: EdgeInsets.only(
          bottom: 10.h,
        ),
      ),
    );
  }
}