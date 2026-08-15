import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class ReadingSessionTopBar extends StatelessWidget {
  const ReadingSessionTopBar({
    super.key,
    required this.onClose,
    required this.onFinish,
    required this.foregroundColor,
    required this.finishBackgroundColor,
    this.isSaving = false,
  });

  final VoidCallback onClose;
  final VoidCallback onFinish;

  final Color foregroundColor;
  final Color finishBackgroundColor;

  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      child: Row(
        children: [
          IconButton(
            onPressed: isSaving ? null : onClose,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 44.w, minHeight: 44.h),
            icon: Icon(Icons.close, size: 25.sp, color: foregroundColor),
          ),

          const Spacer(),

          Material(
            color: finishBackgroundColor,
            borderRadius: BorderRadius.circular(28.r),
            child: InkWell(
              onTap: isSaving ? null : onFinish,
              borderRadius: BorderRadius.circular(28.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSaving)
                      SizedBox(
                        width: 15.w,
                        height: 15.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: foregroundColor,
                        ),
                      )
                    else
                      Icon(Icons.check, size: 18.sp, color: foregroundColor),

                    SizedBox(width: 7.w),

                    Text(
                      'Finish',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: foregroundColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
