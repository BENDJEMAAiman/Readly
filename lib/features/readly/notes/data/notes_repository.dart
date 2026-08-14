import '../model/note_entity.dart';
import 'notes_web_service.dart';

class NotesRepository {
  final NotesWebService notesWebService;

  NotesRepository(this.notesWebService);

  Future<List<NoteEntity>> fetchNotesForBook(String bookId) async {
    return await notesWebService.fetchNotesForBook(bookId);
  }

  Future<List<NoteEntity>> fetchAllNotes() async {
    return await notesWebService.fetchAllNotes();
  }

  Future<void> addNote({
  required String bookId,
  required String title,
  required String content,
  required int pageNumber,
}) async {
  await notesWebService.addNote(
    bookId: bookId,
    title: title,
    content: content,
    pageNumber: pageNumber,
  );
}

  Future<void> updateNote(NoteEntity note) async {
    await notesWebService.updateNote(note);
  }

  Future<void> deleteNote({
    required String bookId,
    required String noteId,
  }) async {
    await notesWebService.deleteNote(bookId: bookId, noteId: noteId);
  }
}
