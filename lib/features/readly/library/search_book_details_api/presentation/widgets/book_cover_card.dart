import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class BookCoverCard extends StatelessWidget {
  final int? coverId;

  const BookCoverCard({
    super.key,
    required this.coverId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 183.w,
      height: 270.h,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: coverId == null
          ? const _CoverPlaceholder()
          : _BookImage(
              coverId: coverId!,
            ),
    );
  }
}

class _BookImage extends StatelessWidget {
  final int coverId;

  const _BookImage({
    required this.coverId,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      "https://covers.openlibrary.org/b/id/$coverId-L.jpg",
      fit: BoxFit.cover,
      loadingBuilder: (_, child, loading) {
        if (loading == null) return child;

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      errorBuilder: (_, __, ___) {
        return const _CoverPlaceholder();
      },
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}