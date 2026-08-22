import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/reading_session/model/reading_goal_achievement.dart';

class ReadingGoalAchievedDialog extends StatelessWidget {
  const ReadingGoalAchievedDialog({
    super.key,
    required this.achievement,
  });

  final ReadingGoalAchievement achievement;

  String get _message {
    if (achievement.timeGoalAchieved &&
        achievement.pagesGoalAchieved) {
      return 'You reached both of your daily reading goals!';
    }

    if (achievement.timeGoalAchieved) {
      return 'You reached your daily reading time goal!';
    }

    return 'You reached your daily reading pages goal!';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 28.h,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🎉',
            style: TextStyle(
              fontSize: 42.sp,
            ),
          ),

          SizedBox(height: 12.h),

          Text(
            'Goal achieved!',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.buttonBlueDark,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 10.h),

          Text(
            _message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primaryLight,
              height: 1.5,
            ),
          ),

          SizedBox(height: 24.h),

          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonBlueDark,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Text(
                'Awesome!',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}