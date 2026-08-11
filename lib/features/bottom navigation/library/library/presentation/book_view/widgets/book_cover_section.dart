
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/constants/app_assets.dart';
import 'package:readly/core/theme/app_colors.dart';

class BookCoverSection extends StatelessWidget {
  final int? coverId;
  final String? coverImageUrl;

  final VoidCallback? onCounterPressed;
  final VoidCallback? onNotesPressed;

  const BookCoverSection({
    super.key,
    this.coverId,
    this.coverImageUrl,
    this.onCounterPressed,
    this.onNotesPressed,
  });

  Widget _buildCoverImage() {
    // 1. Prefer the manually uploaded Cloudinary cover.
    if (coverImageUrl != null && coverImageUrl!.isNotEmpty) {
      return Image.network(
        coverImageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return const Center(
            child: Icon(
              Icons.menu_book_rounded,
              size: 80,
            ),
          );
        },
      );
    }

    // 2. If there is no Cloudinary cover,
    //    use the OpenLibrary cover.
    if (coverId != null) {
      return Image.network(
        'https://covers.openlibrary.org/b/id/$coverId-M.jpg',
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return const Center(
            child: Icon(
              Icons.menu_book_rounded,
              size: 80,
            ),
          );
        },
      );
    }

    // 3. No cover available.
    return const Center(
      child: Icon(
        Icons.menu_book_rounded,
        size: 80,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 302.h,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Center(
            child: Container(
              width: 215.w,
              height: 302.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: _buildCoverImage(),
                ),
              ),
            ),
          ),

          Positioned(
            right: 57.w,
            bottom: -2.h,
            child: Container(
              width: 93.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: const Color(0xFF7FABD8),
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: Row(
                children: [
                  SizedBox(width: 10.w),

                  GestureDetector(
                    onTap: onCounterPressed,
                    child: Image.asset(
                      AppAssets.counterIcon,
                      color: Colors.white,
                      width: 24.w,
                      height: 24.h,
                    ),
                  ),

                  SizedBox(width: 10.w),

                  Container(
                    width: 1,
                    height: 24.h,
                    color: Colors.white,
                  ),

                  SizedBox(width: 10.w),

                  GestureDetector(
                    onTap: onNotesPressed,
                    child: Image.asset(
                      AppAssets.noteIcon,
                      color: Colors.white,
                      width: 24.w,
                      height: 24.h,
                    ),
                  ),

                  SizedBox(width: 10.w),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
