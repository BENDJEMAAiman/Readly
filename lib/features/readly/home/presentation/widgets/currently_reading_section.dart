import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/features/readly/home/presentation/widgets/add_book_card.dart';
import 'package:readly/features/readly/home/presentation/widgets/home_book_card.dart';
import 'package:readly/features/readly/library/library/business_logic/library_cubit.dart';
import 'package:readly/features/readly/library/library/business_logic/library_state.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';

class CurrentlyReadingSection extends StatelessWidget {
  const CurrentlyReadingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryCubit, LibraryState>(
      builder: (context, state) {
        if (state is LibraryLoading) {
          return SizedBox(
            height: 178.h,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.secondary),
            ),
          );
        }

        if (state is LibraryError) {
          return SizedBox(
            height: 178.h,
            child: Center(
              child: Text(state.message, textAlign: TextAlign.center),
            ),
          );
        }

        if (state is LibraryLoaded) {
          final currentlyReadingBooks = state.books
              .where((book) => book.readingStatus == ReadingStatus.reading)
              .take(5)
              .toList();

          return SizedBox(
            height: 190.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: currentlyReadingBooks.length + 1,

              separatorBuilder: (context, index) {
                return SizedBox(width: 12.w);
              },

              itemBuilder: (context, index) {
                // First card is always Add a Book.
                if (index == 0) {
                  return const AddBookCard();
                }

                final book = currentlyReadingBooks[index - 1];

                return HomeBookCard(book: book);
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
