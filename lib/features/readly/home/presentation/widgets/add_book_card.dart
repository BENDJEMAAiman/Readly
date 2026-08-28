import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/core/theme/app_colors.dart';

class AddBookCard extends StatelessWidget {
  const AddBookCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(Routes.library);
      },
      child: Column(
        children: [
          Container(
            width: 130.w,
            height: 155.h,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.buttonBlueDark,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 16.h),
                  Icon(
                    Icons.add_circle_outline,
                    size: 32.sp,
                    color: AppColors.buttonBlueDark,
                  ),
          
                  SizedBox(height: 2.h),
          
                  Text(
                    'Add a book',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.buttonBlueDark,
                    ),
                  ),
          
                  SizedBox(height: 2.h),
          
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      'Is there a book you\nwant to read ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey500,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}