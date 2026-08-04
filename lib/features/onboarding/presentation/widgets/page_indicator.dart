import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: currentPage == index
                ? AppColors.secondary
                : AppColors.indicatorInactive,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}