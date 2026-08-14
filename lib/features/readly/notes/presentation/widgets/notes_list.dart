import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';
import 'package:readly/features/readly/notes/model/note_entity.dart';
import 'package:readly/features/readly/notes/presentation/widgets/note_card.dart';

class NotesList extends StatelessWidget {
  const NotesList({
    super.key,
    required this.notes,
    required this.books,
  });

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
        );
      },
    );
  }
}