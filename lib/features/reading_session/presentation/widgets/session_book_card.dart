import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';

class SessionBookCard extends StatelessWidget {
  const SessionBookCard({
    super.key,
    required this.book,
    this.onTap,
  });

  final LibraryBook book;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(22.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: AppColors.grey400,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              _buildCover(),

              SizedBox(width: 14.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 8.w),

              Icon(
                Icons.chevron_right_rounded,
                size: 24.sp,
                color: AppColors.grey500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCover() {
    final coverUrl = _getCoverUrl();

    if (coverUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Image.network(
          coverUrl,
          width: 48.w,
          height: 64.h,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _placeholderCover();
          },
        ),
      );
    }

    return _placeholderCover();
  }

  Widget _placeholderCover() {
    return Container(
      width: 48.w,
      height: 64.h,
      decoration: BoxDecoration(
        color: AppColors.secondaryLight,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        Icons.menu_book_outlined,
        size: 24.sp,
        color: AppColors.secondary,
      ),
    );
  }

  String? _getCoverUrl() {
    if (book.coverImageUrl != null &&
        book.coverImageUrl!.isNotEmpty) {
      return book.coverImageUrl;
    }

    if (book.coverId != null) {
      return 'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg';
    }

    return null;
  }
}