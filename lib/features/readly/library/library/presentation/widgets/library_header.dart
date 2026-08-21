import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/features/auth/presentation/widgets%20/auth_header.dart';

class LibraryHeader extends StatelessWidget {
  const LibraryHeader({
    super.key,
    this.profileImage,
  });

  final ImageProvider? profileImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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

        const AuthHeader(title: "My library", subtitle: "Everything you're reading, in one place",),
      ],
    );
  }
}