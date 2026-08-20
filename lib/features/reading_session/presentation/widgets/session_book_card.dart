import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/core/constants/app_assets.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';

class SessionBookCard extends StatelessWidget {
  const SessionBookCard({
    super.key,
    required this.book,
    required this.isActive,
    required this.onNotesPressed,
  });

  final LibraryBook book;
  final bool isActive;
  final VoidCallback onNotesPressed;

  @override
  Widget build(BuildContext context) {
    final cardColor = isActive
        ? const Color(0xFFA4C3E4)
        : AppColors.background;

    final borderColor = isActive
        ? AppColors.white.withValues(alpha: 0.35)
        : AppColors.grey400;

    final titleColor = isActive
      ?AppColors.white
      : AppColors.primaryLight;

    final authorColor = isActive
        ? AppColors.white
        : AppColors.grey600;

    return SizedBox(
      height: 120.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(22.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(22.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(22.r),
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    _buildCover(),

                    SizedBox(width: 14.w),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: titleColor,
                              fontWeight: FontWeight.w600,
                            ),
                            child: Text(
                              book.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          SizedBox(height: 4.h),

                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: authorColor,
                            ),
                            child: Text(
                              book.author,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Notes button
          Positioned(
            right: 0.1.w,
            bottom: -1.h,
            child: GestureDetector(
              onTap: onNotesPressed,
              child: Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: isActive
                    ? const Color(0xFF7FABD8)
                    : AppColors.background,
                  borderRadius: BorderRadius.circular(22.r),
                  border: Border.all(color: borderColor, width: 1)
                ),
                child: Center(
                  child: Image.asset(
                    AppAssets.counterIcon,
                    color: authorColor,
                    width: 22.w,
                    height: 22.h,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCover() {
    final coverUrl = _getCoverUrl();

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: SizedBox(
        width: 48.w,
        height: 64.h,
        child: coverUrl != null
            ? Image.network(
                coverUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return _placeholderCover();
                },
              )
            : _placeholderCover(),
      ),
    );
  }

  Widget _placeholderCover() {
    return Container(
      width: 48.w,
      height: 64.h,
      color: AppColors.secondaryLight,
      child: Icon(
        Icons.menu_book_rounded,
        size: 24.sp,
        color: AppColors.buttonBlueDark,
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