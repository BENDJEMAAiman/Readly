import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/reading_session.dart';

class ReadingSessionWebService {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ReadingSessionWebService(
    this.firestore,
    this.auth,
  );

  String _getCurrentUserId() {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    return user.uid;
  }

  Future<ReadingSession> addReadingSession({
  required String bookId,
  required DateTime startedAt,
  required DateTime endedAt,
  required int durationSeconds,
  required int pagesRead,
}) async {
  try {
    final uid = _getCurrentUserId();

    final sessionsCollection = firestore
        .collection('users')
        .doc(uid)
        .collection('books')
        .doc(bookId)
        .collection('reading_sessions');

    // Firestore generates the document ID.
    final sessionDocument = sessionsCollection.doc();

    final session = ReadingSession(
      sessionId: sessionDocument.id,
      bookId: bookId,
      startedAt: startedAt,
      endedAt: endedAt,
      durationSeconds: durationSeconds,
      pagesRead: pagesRead,
    );

    await sessionDocument.set({
      'bookId': session.bookId,
      'startedAt': Timestamp.fromDate(session.startedAt),
      'endedAt': Timestamp.fromDate(session.endedAt),
      'durationSeconds': session.durationSeconds,
      'pagesRead': session.pagesRead,
    });

    return session;
  } catch (e) {
    throw Exception(
      'Failed to save reading session: $e',
    );
  }
}

  Future<List<ReadingSession>> fetchReadingSessionsForBook(
    String bookId,
  ) async {
    try {
      final uid = _getCurrentUserId();

      final snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('books')
          .doc(bookId)
          .collection('reading_sessions')
          .orderBy('startedAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => ReadingSession.fromFirestore(doc),
          )
          .toList();
    } catch (e) {
      throw Exception(
        'Failed to fetch reading sessions: $e',
      );
    }
  }
}