import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/note_entity.dart';

class NotesWebService {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  NotesWebService(this.firestore, this.auth);

  String _getCurrentUserId() {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    return user.uid;
  }

  Future<List<NoteEntity>> fetchAllNotes() async {
    try {
      final uid = _getCurrentUserId();

      final booksSnapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('books')
          .get();

      final List<NoteEntity> allNotes = [];

      for (final bookDoc in booksSnapshot.docs) {
        final notesSnapshot = await bookDoc.reference
            .collection('notes')
            .orderBy('updatedAt', descending: true)
            .get();

        final notes = notesSnapshot.docs
            .map((doc) => NoteEntity.fromFirestore(doc))
            .toList();

        allNotes.addAll(notes);
      }

      allNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      return allNotes;
    } catch (e) {
      throw Exception('Failed to fetch all notes: $e');
    }
  }

  Future<List<NoteEntity>> fetchNotesForBook(String bookId) async {
    try {
      final uid = _getCurrentUserId();

      final snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('books')
          .doc(bookId)
          .collection('notes')
          .orderBy('updatedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => NoteEntity.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  Future<void> addNote({
  required String bookId,
  required String title,
  required String content,
  required int pageNumber,
}) async {
  try {
    final uid = _getCurrentUserId();

    final notesCollection = firestore
        .collection('users')
        .doc(uid)
        .collection('books')
        .doc(bookId)
        .collection('notes');

    final noteDocument = notesCollection.doc();

    final now = DateTime.now();

    await noteDocument.set({
      'bookId': bookId,
      'title': title,
      'content': content,
      'pageNumber': pageNumber,
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
    });
  } catch (e) {
    throw Exception('Failed to add note: $e');
  }
}

  Future<void> updateNote(NoteEntity note) async {
  try {
    final uid = _getCurrentUserId();

    await firestore
        .collection('users')
        .doc(uid)
        .collection('books')
        .doc(note.bookId)
        .collection('notes')
        .doc(note.noteId)
        .update({
      'title': note.title,
      'content': note.content,
      'pageNumber': note.pageNumber,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  } catch (e) {
    throw Exception('Failed to update note: $e');
  }
}

  Future<void> deleteNote({
    required String bookId,
    required String noteId,
  }) async {
    try {
      final uid = _getCurrentUserId();

      await firestore
          .collection('users')
          .doc(uid)
          .collection('books')
          .doc(bookId)
          .collection('notes')
          .doc(noteId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }
}
