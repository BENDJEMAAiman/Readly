import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/features/readly/library/library/presentation/book_view/widgets/about_book_section.dart';
import 'package:readly/features/readly/library/library/presentation/book_view/widgets/book_cover_section.dart';
import 'package:readly/features/readly/library/library/presentation/book_view/widgets/book_info_card.dart';
import 'package:readly/features/readly/library/library/presentation/book_view/widgets/book_info_grid.dart';
import 'package:readly/features/readly/library/library/presentation/book_view/widgets/reading_button.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';
import 'package:readly/features/readly/library/library/presentation/book_view/widgets/genre_section.dart';
import 'package:readly/features/readly/notes/presentation/new_reading_note_args.dart';

class BookViewScreen extends StatelessWidget {
  final LibraryBook book;

  const BookViewScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    debugPrint('BOOK TITLE: ${book.title}');
    debugPrint('CLOUDINARY URL: ${book.coverImageUrl}');
    debugPrint('OPEN LIBRARY COVER ID: ${book.coverId}');
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),

                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.secondary,
                    size: 26.sp,
                  ),
                ),

                SizedBox(height: 16.h),

                BookCoverSection(
                  coverImageUrl: book.coverImageUrl,
                  coverId: book.coverId,
                  onCounterPressed: () {
                    context.push(
                      Routes.newReadingNote,
                      extra: NewReadingNoteArgs(book: book),
                    );
                  },
                  onNotesPressed: () {
                    context.push(Routes.readingSession, extra: book);
                  },
                ),

                SizedBox(height: 24.h),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BookInfoCard(
                        title: book.title,
                        author: book.author,
                        status: book.readingStatus,
                      ),

                      SizedBox(height: 20.h),

                      BookInfoGrid(
                        pages: book.pages,
                        language: book.language,
                        publisher: book.publisher,
                      ),

                      SizedBox(height: 20.h),

                      // Start Reading
                      ReadingButton(
                        onPressed: () {
                          context.push(Routes.readingSession, extra: book);
                        },
                      ),

                      SizedBox(height: 24.h),

                      Divider(color: AppColors.grey400, height: 1),

                      SizedBox(height: 24.h),

                      // About this book
                      AboutBookSection(description: book.description),

                      SizedBox(height: 24.h),

                      // Genres
                      GenresSection(genres: book.subjects),
                    ],
                  ),
                ),

                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
