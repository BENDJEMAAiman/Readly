import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: EdgeInsets.all(4.r),
              child: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.goBackButton,),
            ),
          ),
        ),

        SizedBox(height: 18.h),

        Text("Find your next read", style: AppTextStyles.headingLarge),

        SizedBox(height: 4.h),

        Text(
          "Everything you're reading, in one place.",
          style: AppTextStyles.bodyLarge,
        ),
      ],
    );
  }
}
