import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class SearchResultTile extends StatelessWidget {
  final String workKey;
  final String editionKey;
  final String title;
  final String author;
  final int? coverId;
  final VoidCallback onTap;

  const SearchResultTile({
    super.key,
    required this.workKey,
    required this.editionKey,
    required this.title,
    required this.author,
    required this.coverId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  coverId != null
                      ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
                      : '',
                  width: 50.w,
                  height: 72.h,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return SizedBox(
                      width: 50.w,
                      height: 72.h,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) {
                    return Container(
                      width: 50.w,
                      height: 72.h,
                      decoration: BoxDecoration(
                        color: AppColors.grey400,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: AppColors.primaryLight,
                        size: 24.sp,
                      ),
                    );
                  },
                ),
              ),

              SizedBox(width: 16.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyPrimary,
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 12.w),

              Icon(
                Icons.chevron_right,
                size: 22.sp,
                color: AppColors.primaryLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}