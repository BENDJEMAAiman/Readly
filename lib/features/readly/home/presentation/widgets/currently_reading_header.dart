import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class CurrentlyReadingHeader extends StatelessWidget {
  const CurrentlyReadingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Currently Reading',
          style: AppTextStyles.headingLarge.copyWith(
            fontSize: 20.sp,
          ),
        ),

        const Spacer(),

        TextButton(
          onPressed: () {
            context.go(Routes.library);
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'See all',
            style: AppTextStyles.bodyPrimary.copyWith(
              fontSize: 16.sp,
            ),
          ),
        ),
      ],
    );
  }
}