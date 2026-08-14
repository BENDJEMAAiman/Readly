import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';
import 'package:readly/features/readly/notes/business_logic/notes_cubit.dart';
import 'package:readly/features/readly/notes/model/note_entity.dart';
import 'package:readly/features/readly/notes/presentation/new_reading_note_args.dart';
import 'package:readly/features/readly/notes/presentation/widgets/note_card.dart';

class NotesList extends StatelessWidget {
  const NotesList({super.key, required this.notes, required this.books});

  final List<NoteEntity> notes;
  final List<LibraryBook> books;

  @override
  Widget build(BuildContext context) {
    final booksById = {
      for (final book in books)
        if (book.id != null) book.id!: book,
    };

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: notes.length,
      separatorBuilder: (context, index) {
        return SizedBox(height: 32.h);
      },
      itemBuilder: (context, index) {
        final note = notes[index];
        final book = booksById[note.bookId];

        if (book == null) {
          return const SizedBox.shrink();
        }

        return NoteCard(
          note: note,
          book: book,
          onTap: () async {
            final result = await context.push<bool>(
              Routes.newReadingNote,
              extra: NewReadingNoteArgs(book: book, note: note),
            );

            if (result == true && context.mounted) {
              await context.read<NotesCubit>().fetchAllNotes();
            }
          },
          onDelete: () async {
            final shouldDelete = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: AppColors.white,
                  surfaceTintColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),

                  title: Text(
                    'Delete Note!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.buttonBlueDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  content: Text(
                    'Are you sure you want to delete this note',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.grey500,
                      height: 1.5,
                    ),
                  ),
                  actionsPadding: EdgeInsets.zero,

                  actions: [
                    SizedBox(
              height: 52.h,
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.buttonBlueDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1.w,
                    height: 52.h,
                    color: AppColors.buttonBlueDark.withValues(alpha: 0.25),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text(
                        'Delete',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.buttonBlueDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
                  ],
                );
              },
            );

            if (shouldDelete == true && context.mounted) {
              context.read<NotesCubit>().deleteNote(
                bookId: note.bookId,
                noteId: note.noteId,
              );
            }
          },
        );
      },
    );
  }
}


