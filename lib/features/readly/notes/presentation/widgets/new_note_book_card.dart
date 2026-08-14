import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';

class NewNoteBookCard extends StatelessWidget {
  const NewNoteBookCard({
    super.key,
    required this.book,
  });

  final LibraryBook book;

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

  @override
  Widget build(BuildContext context) {
    final coverUrl = _getCoverUrl();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.grey400,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 60.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.secondaryLight,
            ),
            clipBehavior: Clip.antiAlias,
            child: coverUrl != null
                ? Image.network(
                    coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return Icon(
                        Icons.menu_book_outlined,
                        color: AppColors.secondary,
                        size: 24.sp,
                      );
                    },
                  )
                : Icon(
                    Icons.menu_book_outlined,
                    color: AppColors.secondary,
                    size: 24.sp,
                  ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyLarge.copyWith(
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
        ],
      ),
    );
  }
}