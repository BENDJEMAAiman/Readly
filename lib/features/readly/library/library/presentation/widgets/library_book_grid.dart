import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';
import 'package:readly/features/readly/library/library/presentation/widgets/library_book_card.dart';

class LibraryBooksGrid extends StatelessWidget {
  const LibraryBooksGrid({
    super.key,
    required this.books,
    this.onBookTap,
  });

  final List<LibraryBook> books;
  final ValueChanged<LibraryBook>? onBookTap;

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const _EmptyLibrary();
    }

    return GridView.builder(
      padding: EdgeInsets.only(
        bottom: 100.h,
      ),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 11.w,
        mainAxisSpacing: 20.h,
        childAspectRatio: 158 / 270,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];

        return LibraryBookCard(
          book: book,
          onTap: () => onBookTap?.call(book),
        );
      },
    );
  }
}

class _EmptyLibrary extends StatelessWidget {
  const _EmptyLibrary();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 30.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 48.sp,
              color: AppColors.secondary,
            ),
            SizedBox(height: 12.h),
            Text(
              'No books found',
              style: AppTextStyles.bodyPrimary.copyWith(
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}