import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readly/core/network/cloudinary_service.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';

class LibraryWebService {

  final FirebaseFirestore firestore;
  final CloudinaryService storageService;
  final FirebaseAuth auth;

  LibraryWebService(
    this.firestore,
    this.storageService,
    this.auth,
  );

  //Returns the currently authenticated user's UID.
  String _getCurrentUserId() {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user found.');
    }

    return user.uid;
  }

  // Reference to the current user's document.
  DocumentReference<Map<String, dynamic>> _userReference() {
    final uid = _getCurrentUserId();

    return firestore.collection('users').doc(uid);
  }

  // Reference to the current user's books collection.
  CollectionReference<Map<String, dynamic>> _booksReference() {
    return _userReference().collection('books');
  }

  // Generates a new Firestore document ID for a book.
  String createBookId() {
    return _booksReference().doc().id;
  }

  /// Uploads a book cover to Firebase Storage and
  /// returns its download URL.
 Future<String> uploadBookCover({
  required File file,
  required String bookId,
}) async {
  try {
    final uid = _getCurrentUserId();

    return await storageService.uploadBookCover(
      file: file,
      userId: uid,
      bookId: bookId,
    );
  } catch (e) {
    throw Exception(
      'Failed to upload book cover: $e',
    );
  }
}

  /// Saves a book inside: users/{uid}/books/{bookId}
  Future<void> saveBook({
    required String bookId,
    required LibraryBook book,
  }) async {
    try {
      await _booksReference()
          .doc(bookId)
          .set(book.toMap());
    } on FirebaseException catch (e) {
      throw Exception(
        'Failed to save book: ${e.message ?? e.code}',
      );
    } catch (e) {
      throw Exception(
        'Failed to save book: $e',
      );
    }
  }

  // Get one book from the current user's library.
  Future<LibraryBook?> getBook(String bookId) async {
    try {
      final snapshot = await _booksReference()
          .doc(bookId)
          .get();

      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }

      return LibraryBook.fromMap(
        snapshot.data()!,
        id: snapshot.id,
      );
    } on FirebaseException catch (e) {
      throw Exception(
        'Failed to get book: ${e.message ?? e.code}',
      );
    } catch (e) {
      throw Exception(
        'Failed to get book: $e',
      );
    }
  }

  // Get all books belonging to the current user.
  Future<List<LibraryBook>> getBooks() async {
    try {
      final snapshot = await _booksReference().get();

      return snapshot.docs
          .map(
            (doc) => LibraryBook.fromMap(
              doc.data(),
              id: doc.id,
            ),
          )
          .toList();
    } on FirebaseException catch (e) {
      throw Exception(
        'Failed to get books: ${e.message ?? e.code}',
      );
    } catch (e) {
      throw Exception(
        'Failed to get books: $e',
      );
    }
  }

  // Deletes a book document from Firestore.
  Future<void> deleteBook(String bookId) async {
    try {
      await _booksReference()
          .doc(bookId)
          .delete();
    } on FirebaseException catch (e) {
      throw Exception(
        'Failed to delete book: ${e.message ?? e.code}',
      );
    } catch (e) {
      throw Exception(
        'Failed to delete book: $e',
      );
    }
  }


  

  Future<void> updateBook(LibraryBook book) async {
  try {
    if (book.id == null || book.id!.isEmpty) {
      throw Exception('Cannot update a book without an ID.');
    }

    final uid = auth.currentUser?.uid;

    if (uid == null) {
      throw Exception('No authenticated user found.');
    }

    await firestore
        .collection('users')
        .doc(uid)
        .collection('books')
        .doc(book.id)
        .update(book.toMap());
  } catch (e) {
    throw Exception('Failed to update book: $e');
  }
}

}