import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readly/features/readly/library/add_manually/business_logic/book_form_cubit.dart';
import 'package:readly/features/readly/library/add_manually/business_logic/book_form_state.dart';
import 'package:readly/features/readly/library/add_manually/presentation/widgets/reading_status_chip.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';
import 'package:readly/features/readly/library/search_book_details_api/presentation/widgets/form_section.dart';

class ReadingStatusSection extends StatelessWidget {
  const ReadingStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookFormCubit, BookFormState>(
      builder: (context, state) {
        return FormSection(
          title: "Reading Status",
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ReadingStatusChip(
                icon: Icons.menu_book_outlined,
                label: "Reading",
                selected:
                    state.readingStatus == ReadingStatus.reading,
                onTap: () {
                  context
                      .read<BookFormCubit>()
                      .updateReadingStatus(
                        ReadingStatus.reading,
                      );
                },
              ),

              ReadingStatusChip(
                icon: Icons.check_circle_outline,
                label: "Completed",
                selected:
                    state.readingStatus ==
                    ReadingStatus.completed,
                onTap: () {
                  context
                      .read<BookFormCubit>()
                      .updateReadingStatus(
                        ReadingStatus.completed,
                      );
                },
              ),

              ReadingStatusChip(
                icon: Icons.bookmark_border,
                label: "Want to Read",
                selected:
                    state.readingStatus ==
                    ReadingStatus.wantToRead,
                onTap: () {
                  context
                      .read<BookFormCubit>()
                      .updateReadingStatus(
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