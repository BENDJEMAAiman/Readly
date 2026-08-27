import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readly/features/readly/library/library/business_logic/library_state.dart';
import 'package:readly/features/readly/library/library/data/library_repository.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';

class LibraryCubit extends Cubit<LibraryState> {
  final LibraryRepository repository;

  LibraryCubit(this.repository) : super(const LibraryInitial());

  /// Fetches all books belonging to the currently
  /// authenticated user.
  Future<void> fetchUserBooks() async {
    emit(const LibraryLoading());

    try {
      final books = await repository.getBooks();

      emit(
        LibraryLoaded(
          books: books,
          filteredBooks: books,
          searchQuery: '',
          selectedStatus: null,
        ),
      );
    } catch (e) {
      emit(LibraryError(e.toString()));
    }
  }

  /// Adds a new book to the user's library.
  Future<void> addBook(LibraryBook book) async {
    try {
      debugPrint('========== LIBRARY CUBIT ADD ==========');
      debugPrint('Adding: ${book.title}');
      debugPrint('Current state BEFORE save: $state');

      final savedBook = await repository.addBook(book);

      debugPrint('Repository returned saved book');
      debugPrint('Saved book ID: ${savedBook.id}');
      debugPrint('Saved book title: ${savedBook.title}');

      final currentState = state;

      debugPrint('Current state AFTER save: $currentState');

      if (currentState is! LibraryLoaded) {
        debugPrint('State is NOT LibraryLoaded');
        debugPrint('Fetching books again...');
        await fetchUserBooks();
        return;
      }

      debugPrint('Books BEFORE: ${currentState.books.length}');

      final updatedBooks = [...currentState.books, savedBook];

      debugPrint('Books AFTER: ${updatedBooks.length}');

      final query = currentState.searchQuery;
      final selectedStatus = currentState.selectedStatus;

      final filteredBooks = updatedBooks.where((book) {
        final matchesSearch =
            query.isEmpty || book.title.trim().toLowerCase().contains(query);

        final matchesStatus =
            selectedStatus == null || book.readingStatus == selectedStatus;

        return matchesSearch && matchesStatus;
      }).toList();

      debugPrint('Filtered books AFTER: ${filteredBooks.length}');

      emit(
        LibraryLoaded(
          books: updatedBooks,
          filteredBooks: filteredBooks,
          searchQuery: query,
          selectedStatus: selectedStatus,
        ),
      );

      debugPrint('LibraryLoaded emitted');
      debugPrint('========================================');
    } catch (e) {
      debugPrint('ADD BOOK ERROR: $e');
      emit(LibraryError(e.toString()));
    }
  }

  Future<void> updateBookProgress(String bookId, int currentPage) async {
    try {
      final currentState = state;

      if (currentState is! LibraryLoaded) {
        return;
      }

      final bookIndex = currentState.books.indexWhere(
        (book) => book.id == bookId,
      );

      if (bookIndex == -1) {
        return;
      }

      final book = currentState.books[bookIndex];

      final updatedBook = book.copyWith(currentPage: currentPage);

      await repository.updateBook(updatedBook);

      final updatedBooks = [...currentState.books];

      updatedBooks[bookIndex] = updatedBook;

      final query = currentState.searchQuery;
      final selectedStatus = currentState.selectedStatus;

      final filteredBooks = updatedBooks.where((book) {
        final matchesSearch =
            query.isEmpty || book.title.trim().toLowerCase().contains(query);

        final matchesStatus =
            selectedStatus == null || book.readingStatus == selectedStatus;

        return matchesSearch && matchesStatus;
      }).toList();

      emit(
        LibraryLoaded(
          books: updatedBooks,
          filteredBooks: filteredBooks,
          searchQuery: query,
          selectedStatus: selectedStatus,
        ),
      );
    } catch (e) {
      emit(LibraryError(e.toString()));
    }
  }

  /// Changes the reading status of a book.
  Future<void> changeBookStatus(String bookId, ReadingStatus status) async {
    try {
      final currentState = state;

      if (currentState is! LibraryLoaded) {
        return;
      }

      final bookIndex = currentState.books.indexWhere(
        (book) => book.id == bookId,
      );

      if (bookIndex == -1) {
        return;
      }

      final book = currentState.books[bookIndex];

      final updatedBook = book.copyWith(readingStatus: status);

      await repository.updateBook(updatedBook);

      final updatedBooks = [...currentState.books];

      updatedBooks[bookIndex] = updatedBook;

      final query = currentState.searchQuery;
      final selectedStatus = currentState.selectedStatus;

      final filteredBooks = updatedBooks.where((book) {
        final matchesSearch =
            query.isEmpty || book.title.trim().toLowerCase().contains(query);

        final matchesStatus =
            selectedStatus == null || book.readingStatus == selectedStatus;

        return matchesSearch && matchesStatus;
      }).toList();

      emit(
        LibraryLoaded(
          books: updatedBooks,
          filteredBooks: filteredBooks,
          searchQuery: query,
          selectedStatus: selectedStatus,
        ),
      );
    } catch (e) {
      emit(LibraryError(e.toString()));
    }
  }

  /// Deletes a book from the user's library.
  Future<void> deleteBook(String bookId) async {
    try {
      final currentState = state;

      if (currentState is! LibraryLoaded) {
        return;
      }

      await repository.deleteBook(bookId);

      final updatedBooks = currentState.books
          .where((book) => book.id != bookId)
          .toList();

      final query = currentState.searchQuery;
      final selectedStatus = currentState.selectedStatus;

      final filteredBooks = updatedBooks.where((book) {
        final matchesSearch =
            query.isEmpty || book.title.trim().toLowerCase().contains(query);

        final matchesStatus =
            selectedStatus == null || book.readingStatus == selectedStatus;

        return matchesSearch && matchesStatus;
      }).toList();

      emit(
        LibraryLoaded(
          books: updatedBooks,
          filteredBooks: filteredBooks,
          searchQuery: query,
          selectedStatus: selectedStatus,
        ),
      );
    } catch (e) {
      emit(LibraryError(e.toString()));
    }
  }

  /// Searches the currently loaded books by title.
  ///
  /// This is local filtering only.
  /// No Firestore request is made.
  void searchBooks(String query) {
    final currentState = state;

    if (currentState is! LibraryLoaded) {
      return;
    }

    final normalizedQuery = query.trim().toLowerCase();

    final selectedStatus = currentState.selectedStatus;

    final filteredBooks = currentState.books.where((book) {
      final matchesSearch =
          normalizedQuery.isEmpty ||
          book.title.trim().toLowerCase().contains(normalizedQuery);

      final matchesStatus =
          selectedStatus == null || book.readingStatus == selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();

    emit(
      LibraryLoaded(
        books: currentState.books,
        filteredBooks: filteredBooks,
        searchQuery: normalizedQuery,
        selectedStatus: selectedStatus,
      ),
    );
  }

  /// Changes the reading-status filter.
  /// null means "All".
  void changeStatusFilter(ReadingStatus? status) {
    final currentState = state;

    if (currentState is! LibraryLoaded) {
      return;
    }

    final query = currentState.searchQuery;

    final filteredBooks = currentState.books.where((book) {
      final matchesSearch =
          query.isEmpty || book.title.trim().toLowerCase().contains(query);

      final matchesStatus = status == null || book.readingStatus == status;

      return matchesSearch && matchesStatus;
    }).toList();

    emit(
      LibraryLoaded(
        books: currentState.books,
        filteredBooks: filteredBooks,
        searchQuery: query,
        selectedStatus: status,
      ),
    );
  }

  void updateBookLocally(LibraryBook updatedBook) {
    final currentState = state;

    if (currentState is! LibraryLoaded) {
      return;
    }

    final updatedBooks = currentState.books.map((book) {
      if (book.id == updatedBook.id) {
        return updatedBook;
      }

      return book;
    }).toList();

    final query = currentState.searchQuery;
    final selectedStatus = currentState.selectedStatus;

    final filteredBooks = updatedBooks.where((book) {
      final matchesSearch =
          query.isEmpty || book.title.trim().toLowerCase().contains(query);

      final matchesStatus =
          selectedStatus == null || book.readingStatus == selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();

    emit(
      LibraryLoaded(
        books: updatedBooks,
        filteredBooks: filteredBooks,
        searchQuery: query,
        selectedStatus: selectedStatus,
      ),
    );
  }

  Future<LibraryBook?> resetBookForRereading(String bookId) async {
    try {
      final currentState = state;

      if (currentState is! LibraryLoaded) {
        return null;
      }

      final bookIndex = currentState.books.indexWhere(
        (book) => book.id == bookId,
      );

      if (bookIndex == -1) {
        return null;
      }

      final book = currentState.books[bookIndex];

      // Safety check:
      // this operation is only intended for completed books.
      if (book.readingStatus != ReadingStatus.completed) {
        return book;
      }

      final updatedBook = book.copyWith(
        currentPage: 0,
        readingStatus: ReadingStatus.reading,
      );

      await repository.updateBook(updatedBook);

      final updatedBooks = [...currentState.books];

      updatedBooks[bookIndex] = updatedBook;

      final query = currentState.searchQuery;
      final selectedStatus = currentState.selectedStatus;

      final filteredBooks = updatedBooks.where((book) {
        final matchesSearch =
            query.isEmpty || book.title.trim().toLowerCase().contains(query);

        final matchesStatus =
            selectedStatus == null || book.readingStatus == selectedStatus;

        return matchesSearch && matchesStatus;
      }).toList();

      emit(
        LibraryLoaded(
          books: updatedBooks,
          filteredBooks: filteredBooks,
          searchQuery: query,
          selectedStatus: selectedStatus,
        ),
      );

      return updatedBook;
    } catch (e) {
      emit(LibraryError(e.toString()));

      return null;
    }
  }
}
