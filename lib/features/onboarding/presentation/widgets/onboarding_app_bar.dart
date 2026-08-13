import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class OnboardingAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onSkip;

  const OnboardingAppBar({
    super.key,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,

      titleSpacing: 24.w,

      title: GestureDetector(
        onTap: onSkip,
        child: Text(
          'Skip',
          style: AppTextStyles.bodyMedium,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}