import 'package:flutter/widgets.dart';
import 'package:readly/features/readly/library/library/data/library_web_service.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';

class LibraryRepository {
  final LibraryWebService webService;

  LibraryRepository(this.webService);

  Future<LibraryBook> addBook(LibraryBook book) async {
    try {
      debugPrint('========== REPOSITORY ADD BOOK ==========');
      debugPrint('Title: ${book.title}');
      debugPrint('Author: ${book.author}');
      debugPrint('Pages: ${book.pages}');
      debugPrint('Reading status: ${book.readingStatus.name}');
      debugPrint('Cover file exists: ${book.coverFile != null}');

      final bookId = webService.createBookId();

      debugPrint('Generated book ID: $bookId');

      String? coverImageUrl;

      // Upload the local cover if one was selected.
      if (book.coverFile != null) {
        debugPrint('Starting cover upload...');

        coverImageUrl = await webService.uploadBookCover(
          file: book.coverFile!,
          bookId: bookId,
        );
        debugPrint('Cover upload completed.');
        debugPrint('Cover URL: $coverImageUrl');
      } else {
        debugPrint('No cover file. Skipping upload.');
      }

      // Create the final version of the book that will be stored in Firestore.
      // coverFile is local-only, so remove it after the upload has completed.
      final bookToSave = book.copyWith(
        id: bookId,
        coverImageUrl: coverImageUrl,
        createdAt: DateTime.now(),
        removeCoverFile: true,
      );

      debugPrint('Book prepared for Firestore.');
      debugPrint('Book ID: ${bookToSave.id}');
      debugPrint('Map: ${bookToSave.toMap()}');

      debugPrint('Starting Firestore save...');

      // Save the book metadata to:
      // users/{uid}/books/{bookId}
      await webService.saveBook(bookId: bookId, book: bookToSave);

      debugPrint('Firestore save SUCCESS.');
      debugPrint('==========================================');

      return bookToSave;
    } catch (e, stackTrace) {
      debugPrint('========== REPOSITORY ADD ERROR ==========');
      debugPrint('Error: $e');
      debugPrint('StackTrace: $stackTrace');
      debugPrint('==========================================');

      throw Exception('Failed to add book: $e');
    }
  }

  Future<LibraryBook?> getBook(String bookId) async {
    try {
      return await webService.getBook(bookId);
    } catch (e) {
      throw Exception('Failed to get book: $e');
    }
  }

  Future<List<LibraryBook>> getBooks() async {
    try {
      return await webService.getBooks();
    } catch (e) {
      throw Exception('Failed to get books: $e');
    }
  }

  Future deleteBook(String bookId) async {
    try {
      await webService.deleteBook(bookId);
    } catch (e) {
      throw Exception('Failed to delete book: $e');
    }
  }

  Future<void> updateBook(LibraryBook book) async {
    try {
      await webService.updateBook(book);
    } catch (e) {
      throw Exception('Failed to update book: $e');
    }
  }
}
