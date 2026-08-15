import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class DiscardSessionDialog extends StatelessWidget {
  const DiscardSessionDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      title: Text(
        'Discard reading session?',
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.primary,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        'Your reading time from this session will not be saved.',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.grey500,
          height: 1.4,
        ),
      ),
      actionsPadding: EdgeInsets.fromLTRB(
        16.w,
        0,
        16.w,
        12.h,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            'Keep Reading',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.buttonBlueDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(
            'Discard',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.red.shade400,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}