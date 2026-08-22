import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:readly/core/routing/routes.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';

class HomeBookCard extends StatelessWidget {
  const HomeBookCard({super.key, required this.book});

  final LibraryBook book;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.w,
      child: InkWell(
        onTap: () {
          context.push(Routes.viewBook, extra: book);
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BookCover(book: book),

            SizedBox(height: 5.h,),

            Text(
              book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyPrimary.copyWith(fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookCover extends StatelessWidget {
  const _BookCover({required this.book});

  final LibraryBook book;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      height: 150.h,
      decoration: BoxDecoration(
        color: AppColors.secondaryLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildCover(),
    );
  }

  Widget _buildCover() {
    // 1. Supabase / stored image URL
    if (book.coverImageUrl != null && book.coverImageUrl!.isNotEmpty) {
      return Image.network(
        book.coverImageUrl!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return _CoverPlaceholder();
        },
      );
    }

    // 2. Locally selected image
    if (book.coverFile != null) {
      return Image.file(
        File(book.coverFile!.path),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return _CoverPlaceholder();
        },
      );
    }

    // 3. OpenLibrary cover
    if (book.coverId != null) {
      return Image.network(
        'https://covers.openlibrary.org/b/id/${book.coverId}-L.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return _CoverPlaceholder();
        },
      );
    }

    // 4. No image available
    return _CoverPlaceholder();
  }
}

class _CoverPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.menu_book_outlined,
        color: AppColors.secondary,
        size: 32,
      ),
    );
  }
}
