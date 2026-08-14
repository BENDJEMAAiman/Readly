import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class NoteContentField extends StatelessWidget {
  const NoteContentField({
    super.key,
    required this.controller,
    this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        expands: true,
        maxLines: null,
        minLines: null,
        textAlignVertical: TextAlignVertical.top,
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.primary,
          height: 1.5,
        ),
        decoration: InputDecoration(
          hintText: 'Write your thoughts...',
          hintStyle: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.grey400,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.only(
            top: 16.h,
          ),
        ),
      ),
    );
  }
}