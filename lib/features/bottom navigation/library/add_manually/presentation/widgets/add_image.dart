import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/bottom%20navigation/library/add_manually/business_logic/book_form_cubit.dart';
import 'package:readly/features/bottom%20navigation/library/add_manually/business_logic/book_form_state.dart';

class AddImage extends StatelessWidget {
  const AddImage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookFormCubit, BookFormState>(
      builder: (context, state) {
        return Center(
          child: GestureDetector(
            onTap: () {
              context.read<BookFormCubit>().pickCoverImage();
            },
            child: Container(
              width: 183.w,
              height: 270.h,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: state.coverImage != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(state.coverImage!, fit: BoxFit.cover),

                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: GestureDetector(
                            onTap: () {
                              context.read<BookFormCubit>().removeCoverImage();
                            },
                            child: Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 38.sp,
                              color: AppColors.secondary,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              "Upload Cover",
                              style: AppTextStyles.bodyPrimary,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Recommended: 600×900 px",
                              textAlign: TextAlign.center,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.grey500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
