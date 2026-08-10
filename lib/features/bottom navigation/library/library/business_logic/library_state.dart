import 'package:readly/features/bottom%20navigation/library/library/model/library_book.dart';

sealed class LibraryState {
  const LibraryState();
}

class LibraryInitial extends LibraryState {
  const LibraryInitial();
}

class LibraryLoading extends LibraryState {
  const LibraryLoading();
}

class LibraryLoaded extends LibraryState {
  final List<LibraryBook> books;
  final List<LibraryBook> filteredBooks;

  final String searchQuery;
  final ReadingStatus? selectedStatus;

  const LibraryLoaded({
    required this.books,
    required this.filteredBooks,
    this.searchQuery = '',
    this.selectedStatus,
  });
}

class LibraryError extends LibraryState {
  final String message;

  const LibraryError(this.message);
}
