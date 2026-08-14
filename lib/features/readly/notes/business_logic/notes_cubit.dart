import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readly/features/readly/library/library/data/library_repository.dart';
import 'package:readly/features/readly/notes/business_logic/notes_state.dart';
import 'package:readly/features/readly/notes/data/notes_repository.dart';
import 'package:readly/features/readly/notes/model/note_entity.dart';



class NotesCubit extends Cubit<NotesState> {
  final NotesRepository notesRepository;
  final LibraryRepository libraryRepository;

  NotesCubit(
    this.notesRepository,
    this.libraryRepository,
  ) : super(NotesInitial());

  Future<void> fetchAllNotes() async {
    emit(NotesLoading());

    try {
      final books = await libraryRepository.getBooks();

      final notes = await notesRepository.fetchAllNotes();

      emit(
        NotesLoaded(
          notes: notes,
          books: books,
        ),
      );
    } catch (e) {
      emit(
        NotesError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> fetchNotesForBook(String bookId) async {
    emit(NotesLoading());

    try {
      final notes = await notesRepository.fetchNotesForBook(bookId);

      final books = await libraryRepository.getBooks();

      emit(
        NotesLoaded(
          notes: notes,
          books: books,
        ),
      );
    } catch (e) {
      emit(
        NotesError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> addNote({
  required String bookId,
  required String title,
  required String content,
  required int pageNumber,
}) async {
  try {
    await notesRepository.addNote(
      bookId: bookId,
      title: title,
      content: content,
      pageNumber: pageNumber,
    );

    await fetchAllNotes();
  } catch (e) {
    emit(
      NotesError(
        e.toString(),
      ),
    );
  }
}

  Future<void> updateNote(NoteEntity note) async {
    try {
      await notesRepository.updateNote(note);

      await fetchAllNotes();
    } catch (e) {
      emit(
        NotesError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> deleteNote({
    required String bookId,
    required String noteId,
  }) async {
    try {
      await notesRepository.deleteNote(
        bookId: bookId,
        noteId: noteId,
      );

      await fetchAllNotes();
    } catch (e) {
      emit(
        NotesError(
          e.toString(),
        ),
      );
    }
  }
}