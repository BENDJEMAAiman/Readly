import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readly/features/bottom%20navigation/library/add_manually/presentation/widgets/reading_status_chip.dart';
import 'package:readly/features/bottom%20navigation/library/book_management/model/library_book.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/business%20logic/search_details_cubit.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/business%20logic/search_details_state.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/presentation/widgets/form_section.dart';

class SearchReadingStatusSection extends StatelessWidget {
  const SearchReadingStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchDetailsCubit, SearchDetailsState>(
      builder: (context, state) {
        if (state is! SearchDetailsSuccess) {
          return const SizedBox.shrink();
        }
        return FormSection(
          title: "Reading Status",
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ReadingStatusChip(
                icon: Icons.menu_book_outlined,
                label: "Reading",
                selected: state.readingStatus == ReadingStatus.reading,
                onTap: () {
                  context.read<SearchDetailsCubit>().updateReadingStatus(
                    ReadingStatus.reading,
                  );
                },
              ),

              ReadingStatusChip(
                icon: Icons.check_circle_outline,
                label: "Completed",
                selected: state.readingStatus == ReadingStatus.completed,
                onTap: () {
                  context.read<SearchDetailsCubit>().updateReadingStatus(
                    ReadingStatus.completed,
                  );
                },
              ),

              ReadingStatusChip(
                icon: Icons.bookmark_border,
                label: "Want to Read",
                selected: state.readingStatus == ReadingStatus.wantToRead,
                onTap: () {
                  context.read<SearchDetailsCubit>().updateReadingStatus(
                    ReadingStatus.wantToRead,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
