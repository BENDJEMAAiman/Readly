import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/business%20logic/search_details_cubit.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/business%20logic/search_details_state.dart';
import 'package:readly/features/bottom%20navigation/library/book_management/presentation/added_book/widgets/about_book_section.dart';
import 'package:readly/features/bottom%20navigation/library/book_management/presentation/added_book/widgets/book_cover_section.dart';
import 'package:readly/features/bottom%20navigation/library/book_management/presentation/added_book/widgets/book_info_card.dart';
import 'package:readly/features/bottom%20navigation/library/book_management/presentation/added_book/widgets/book_info_grid.dart';
import 'package:readly/features/bottom%20navigation/library/book_management/presentation/added_book/widgets/genre_section.dart';
import 'package:readly/features/bottom%20navigation/library/book_management/presentation/added_book/widgets/reading_button.dart';

class SearchDetailsBody extends StatelessWidget {
  const SearchDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchDetailsCubit, SearchDetailsState>(
      builder: (context, state) {
        switch (state) {
          case SearchDetailsInitial():
          case SearchDetailsLoading():
            return const Center(child: CircularProgressIndicator());

          case SearchDetailsError(:final msg):
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Text(
                  msg,
                  style: AppTextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            );

          case SearchDetailsSuccess(:final book):
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookCoverSection(
                    coverId: book.coverId,
                    onCounterPressed: () {
                      // TODO
                    },
                    onNotesPressed: () {
                      // TODO
                    },
                  ),

                  SizedBox(height: 24.h),

                  BookInfoCard(
                    title: book.title,
                    author: book.author,
                    status: "Want to Read",
                  ),

                  SizedBox(height: 24.h),

                  ReadingButton(onPressed: () {}),

                  SizedBox(height: 24.h),

                  BookInfoGrid(
                    pages: book.numberOfPages?.toString() ?? "-",
                    language: book.language ?? "-",
                    publisher: book.publisher ?? "-",
                  ),

                  SizedBox(height: 32.h),

                  AboutBookSection(
                    description:
                        book.description ?? "No description available.",
                  ),

                  SizedBox(height: 32.h),

                  GenresSection(genres: book.subjects ?? []),
                ],
              ),
            );
        }
      },
    );
  }
}
