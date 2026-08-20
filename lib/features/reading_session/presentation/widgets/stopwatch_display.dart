import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class StopwatchDisplay extends StatelessWidget {
  const StopwatchDisplay({
    super.key,
    required this.durationSeconds,
    required this.isActive,
    required this.textColor,
  });

  final int durationSeconds;
  final bool isActive;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatDuration(durationSeconds),
          style: AppTextStyles.bodyLarge.copyWith(
            color: textColor,
            fontSize: 52.sp,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.2,
          ),
        ),

        Text(
          isActive ? 'Reading...' : 'Pause...',
          style: AppTextStyles.bodyLarge.copyWith(
            color: textColor,
            fontSize: 18.sp,
          ),
        ),
      ],
    );
  }

  String _formatDuration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}
