import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    super.key,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final textColor = isDestructive
        ? Colors.red
        : AppColors.primary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 14.h,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              size: 20.sp,
              color: isDestructive
                  ? Colors.red
                  : AppColors.primaryLight,
            ),
          ],
        ),
      ),
    );
  }
}