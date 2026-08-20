import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class DiscardSessionDialog extends StatelessWidget {
  const DiscardSessionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text(
        'Discard reading session?',
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.buttonBlueDark,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        'Your reading time will not be saved.',
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.grey500,
          height: 1.5,
        ),
      ),
      actionsPadding: EdgeInsets.zero,
      actions: [
            SizedBox(
              height: 52.h,
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        'Keep Reading',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.buttonBlueDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1.w,
                    height: 52.h,
                    color: AppColors.buttonBlueDark.withValues(alpha: 0.25),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        'Discard',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.buttonBlueDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
    );
  }
}
