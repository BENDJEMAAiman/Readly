import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class FormSection extends StatelessWidget {
  final String title;
  final Widget child;

  const FormSection({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: AppTextStyles.bodyPrimary.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 14.h),

          child,
        ],
      ),
    );
  }
}