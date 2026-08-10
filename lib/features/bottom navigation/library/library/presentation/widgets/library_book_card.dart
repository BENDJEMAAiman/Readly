
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/bottom%20navigation/library/library/model/library_book.dart';

class LibraryBookCard extends StatelessWidget {
  const LibraryBookCard({
    super.key,
    required this.book,
    this.onTap,
  });

  final LibraryBook book;
  final VoidCallback? onTap;

  double get _progress {
    if (book.pages == null || book.pages! <= 0) {
      return 0;
    }

    return (book.currentPage / book.pages!)
        .clamp(0.0, 1.0);
  }

  String? get _coverUrl {
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 158.w,
        height: 270.h,
        padding: EdgeInsets.fromLTRB(
          15.5.w,
          12.h,
          15.5.w,
          10.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _BookCover(
              book: book,
              coverUrl: _coverUrl,
            ),

            SizedBox(height: 8.h),

            Text(
              book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyPrimary.copyWith(
                fontSize: 13.sp,
                height: 1.2,
              ),
            ),

            SizedBox(height: 3.h),

            Text(
              book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                fontSize: 10.sp,
                height: 1.2,
              ),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(_progress * 100).round()}%',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${book.currentPage}/${book.pages ?? 0} pp.',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),

            SizedBox(height: 4.h),

            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: LinearProgressIndicator(
                value: _progress,
                minHeight: 5.h,
                backgroundColor: AppColors.secondaryLight,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.buttonBlueDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookCover extends StatelessWidget {
  const _BookCover({
    required this.book,
    required this.coverUrl,
  });

  final LibraryBook book;
  final String? coverUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 127.w,
      height: 150.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (book.coverFile != null) {
      return Image.file(
        book.coverFile!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return _placeholder();
        },
      );
    }

    if (coverUrl != null) {
      return Image.network(
        coverUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return _placeholder();
        },
        loadingBuilder: (
          context,
          child,
          loadingProgress,
        ) {
          if (loadingProgress == null) {
            return child;
          }

          return Container(
            color: AppColors.secondaryLight,
            alignment: Alignment.center,
            child: SizedBox(
              width: 18.w,
              height: 18.h,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        },
      );
    }

    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.secondaryLight,
      alignment: Alignment.center,
      child: Icon(
        Icons.menu_book_outlined,
        color: AppColors.secondary,
        size: 32.sp,
      ),
    );
  }
}