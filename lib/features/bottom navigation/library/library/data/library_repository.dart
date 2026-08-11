import 'package:readly/features/bottom%20navigation/library/library/data/library_web_service.dart';
import 'package:readly/features/bottom%20navigation/library/library/model/library_book.dart';

class LibraryRepository {
  final LibraryWebService webService;

  LibraryRepository(this.webService);

  Future<LibraryBook> addBook(LibraryBook book) async {
    try {
      final bookId = webService.createBookId();
      String? coverImageUrl;

      // Upload the local cover if one was selected.
      if (book.coverFile != null) {
        coverImageUrl = await webService.uploadBookCover(
          file: book.coverFile!,
          bookId: bookId,
        );
      }

      // Create the final version of the book that will be stored in Firestore.
      // coverFile is local-only, so remove it after the upload has completed.
      final bookToSave = book.copyWith(
        id: bookId,
        coverImageUrl: coverImageUrl,
        createdAt: DateTime.now(),
        removeCoverFile: true,
      );

      // Save the book metadata to:
      // users/{uid}/books/{bookId}
      await webService.saveBook(bookId: bookId, book: bookToSave);

      return bookToSave;
    } catch (e) {
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
