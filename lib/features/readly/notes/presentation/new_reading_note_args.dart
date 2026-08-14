import 'package:readly/features/readly/library/library/model/library_book.dart';
import 'package:readly/features/readly/notes/model/note_entity.dart';

class NewReadingNoteArgs {
  const NewReadingNoteArgs({
    required this.book,
    this.note,
  });

  final LibraryBook book;
  final NoteEntity? note;
}