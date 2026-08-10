import 'package:readly/features/bottom%20navigation/library/library/data/library_web_service.dart';
import 'package:readly/features/bottom%20navigation/library/library/model/library_book.dart';

class LibraryRepository {
  final LibraryWebService webService;

  LibraryRepository(this.webService);

  Future<LibraryBook> addBook(LibraryBook book) async {
    String? bookId;
    bool coverUploaded = false;

    try {

      bookId = webService.createBookId();
      String? coverImageUrl;

      // Upload the local cover if one was selected.
      if (book.coverFile != null) {
        coverImageUrl = await webService.uploadBookCover(
          file: book.coverFile!,
          bookId: bookId,
        );

        coverUploaded = true;
      }

      // Create the final version of the book that will be stored in Firestore.
      // coverFile is local-only, so remove it after the upload has completed.

      final bookToSave = book.copyWith(
        id: bookId,
        coverImageUrl: coverImageUrl,
        createdAt: DateTime.now(),
        removeCoverFile: true,
      );

      // Save the book metadata to: users/{uid}/books/{bookId}
      await webService.saveBook(
        bookId: bookId,
        book: bookToSave,
      );

      return bookToSave;
    } catch (e) {

      if (bookId != null && coverUploaded) {
        try {
          await webService.deleteBookCover(bookId);
        } catch (_) {
          // Keep the original error. Cleanup failure should
          // not hide the actual operation failure.
        }
      }

      throw Exception(
        'Failed to add book: $e',
      );
    }
  }

  Future<LibraryBook?> getBook(String bookId) async {
    try {
      return await webService.getBook(bookId);
    } catch (e) {
      throw Exception(
        'Failed to get book: $e',
      );
    }
  }

  Future<List<LibraryBook>> getBooks() async {
    try {
      return await webService.getBooks();
    } catch (e) {
      throw Exception(
        'Failed to get books: $e',
      );
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      await webService.deleteBook(bookId);
      try {
        await webService.deleteBookCover(bookId);
      } catch (e) {
        // The book itself was already deleted.
        // Report the cover cleanup failure separately.
        throw Exception(
          'Book deleted, but its cover could not be removed: $e',
        );
      }
    } catch (e) {
      throw Exception(
        'Failed to delete book: $e',
      );
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
