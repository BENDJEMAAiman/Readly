import 'package:equatable/equatable.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';
import 'package:readly/features/readly/notes/model/note_entity.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object?> get props => [];
}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<NoteEntity> notes;
  final List<LibraryBook> books;

  const NotesLoaded({
    required this.notes,
    required this.books,
  });

  @override
  List<Object?> get props => [
        notes,
        books,
      ];
}

class NotesError extends NotesState {
  final String message;

  const NotesError(this.message);

  @override
  List<Object?> get props => [message];
}