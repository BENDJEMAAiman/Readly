import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/onboarding/presentation/widgets/page_indicator.dart';

class OnboardingItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final int currentPage;
  final int pageCount;

  const OnboardingItem({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imagePath,
          width: 271.w,
          height: 216.h,
          fit: BoxFit.contain,
        ),

        SizedBox(height: 48.h),

        SizedBox(
          width: 243.w,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.headingMedium.copyWith(
              color: const Color(0xFF4A90D8),
            ),
          ),
        ),

        SizedBox(height: 16.h),

        SizedBox(
          width: 292.w,
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge,
          ),
        ),

        SizedBox(height: 24.h),

        PageIndicator(
          currentPage: currentPage,
          pageCount: pageCount,
        ),
      ],
    );
  }
}