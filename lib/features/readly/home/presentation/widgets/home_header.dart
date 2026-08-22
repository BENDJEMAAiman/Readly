import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/constants/app_assets.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_header.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, this.profileImage});

  final ImageProvider? profileImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              AppAssets.homeHeaderIcon,
              width: 32.w,
              height: 32.h,
              fit: BoxFit.contain,
            ),

            SizedBox(width: 6.w),

            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Read',
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.buttonBlueDark,
                    ),
                  ),
                  TextSpan(
                    text: 'ly',
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFFEE08F),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            CircleAvatar(
              radius: 23.r,
              backgroundColor: AppColors.secondaryLight,
              backgroundImage: profileImage,
              child: profileImage == null
                  ? Icon(
                      Icons.person_outline,
                      size: 18.sp,
                      color: AppColors.secondary,
                    )
                  : null,
            ),
          ],
        ),

        SizedBox(height: 24.h),

        const AuthHeader(
          title: "Welcome!",
          subtitle: "Ready for today's reading?",
        ),
      ],
    );
  }
}
