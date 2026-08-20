import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/features/readly/library/library/business_logic/library_cubit.dart';
import 'package:readly/features/readly/library/library/presentation/book_view/widgets/about_book_section.dart';
import 'package:readly/features/readly/library/library/presentation/book_view/widgets/book_cover_section.dart';
import 'package:readly/features/readly/library/library/presentation/book_view/widgets/book_info_card.dart';
import 'package:readly/features/readly/library/library/presentation/book_view/widgets/book_info_grid.dart';
import 'package:readly/features/readly/library/library/presentation/book_view/widgets/reading_button.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';
import 'package:readly/features/readly/library/library/presentation/book_view/widgets/genre_section.dart';
import 'package:readly/features/readly/notes/presentation/new_reading_note_args.dart';
import 'package:readly/features/reading_session/presentation/widgets/reread_book_dialog.dart';

class BookViewScreen extends StatefulWidget {
  final LibraryBook book;

  const BookViewScreen({super.key, required this.book});

  @override
  State<BookViewScreen> createState() => _BookViewScreenState();
}

class _BookViewScreenState extends State<BookViewScreen> {
  late LibraryBook _book;

  @override
  void initState() {
    super.initState();

    _book = widget.book;
  }

  Future<void> _startReading(BuildContext context) async {
    if (_book.readingStatus != ReadingStatus.completed) {
      final updatedBook = await context.push<LibraryBook>(
        Routes.readingSession,
        extra: _book,
      );

      if (!context.mounted || updatedBook == null) {
        return;
      }

      context.read<LibraryCubit>().updateBookLocally(updatedBook);

      setState(() {
        _book = updatedBook;
      });

      return;
    }

    final shouldReread = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return RereadBookDialog(bookTitle: _book.title);
      },
    );

    if (!context.mounted || shouldReread != true) {
      return;
    }

    final rereadBook = await context.read<LibraryCubit>().resetBookForRereading(
      _book.id!,
    );

    if (!context.mounted || rereadBook == null) {
      return;
    }

    // Immediately update the book shown by this screen.
    setState(() {
      _book = rereadBook;
    });

    final updatedBook = await context.push<LibraryBook>(
      Routes.readingSession,
      extra: rereadBook,
    );

    if (!context.mounted || updatedBook == null) {
      return;
    }

    context.read<LibraryCubit>().updateBookLocally(updatedBook);

    setState(() {
      _book = updatedBook;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('BOOK TITLE: ${_book.title}');
    debugPrint('CLOUDINARY URL: ${_book.coverImageUrl}');
    debugPrint('OPEN LIBRARY COVER ID: ${_book.coverId}');

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
                  coverImageUrl: _book.coverImageUrl,
                  coverId: _book.coverId,
                  onCounterPressed: () {
                    context.push(
                      Routes.newReadingNote,
                      extra: NewReadingNoteArgs(book: _book),
                    );
                  },
                  onNotesPressed: () {
                    _startReading(context);
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
                        title: _book.title,
                        author: _book.author,
                        status: _book.readingStatus,
                      ),

                      SizedBox(height: 20.h),

                      BookInfoGrid(
                        pages: _book.pages,
                        language: _book.language,
                        publisher: _book.publisher,
                      ),

                      SizedBox(height: 20.h),

                      // Start Reading
                      ReadingButton(
                        onPressed: () {
                          _startReading(context);
                        },
                      ),

                      SizedBox(height: 24.h),

                      Divider(color: AppColors.grey400, height: 1),

                      SizedBox(height: 24.h),

                      // About this book
                      AboutBookSection(description: _book.description),

                      SizedBox(height: 24.h),

                      // Genres
                      GenresSection(genres: _book.subjects),
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
