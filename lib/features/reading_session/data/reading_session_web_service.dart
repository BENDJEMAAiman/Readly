import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';
import '../model/reading_session.dart';

class ReadingSessionWebService {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ReadingSessionWebService(this.firestore, this.auth);

  String _getCurrentUserId() {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    return user.uid;
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
          .map((doc) => ReadingSession.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch reading sessions: $e');
    }
  }

  Future<ReadingSession> saveCompletedReadingSession({
    required LibraryBook updatedBook,
    required DateTime startedAt,
    required DateTime endedAt,
    required int durationSeconds,
    required int pagesRead,
  }) async {
    try {
      final uid = _getCurrentUserId();

      if (updatedBook.id == null || updatedBook.id!.isEmpty) {
        throw Exception('Cannot save session for a book without an ID.');
      }

      final bookReference = firestore
          .collection('users')
          .doc(uid)
          .collection('books')
          .doc(updatedBook.id);

      final sessionReference = bookReference
          .collection('reading_sessions')
          .doc();

      final session = ReadingSession(
        sessionId: sessionReference.id,
        bookId: updatedBook.id!,
        startedAt: startedAt,
        endedAt: endedAt,
        durationSeconds: durationSeconds,
        pagesRead: pagesRead,
      );

      final batch = firestore.batch();

      // 1. Update the book.
      batch.update(bookReference, updatedBook.toMap());

      // 2. Create the reading session.
      batch.set(sessionReference, {
        'bookId': session.bookId,
        'startedAt': Timestamp.fromDate(session.startedAt),
        'endedAt': Timestamp.fromDate(session.endedAt),
        'durationSeconds': session.durationSeconds,
        'pagesRead': session.pagesRead,
      });

      // 3. Commit both operations together.
      await batch.commit();

      return session;
    } catch (e) {
      throw Exception('Failed to save completed reading session: $e');
    }
  }

  Future<List<ReadingSession>> fetchTodayReadingSessions() async {
    try {
      final uid = _getCurrentUserId();

      final now = DateTime.now();

      final startOfToday = DateTime(now.year, now.month, now.day);

      final startOfTomorrow = startOfToday.add(const Duration(days: 1));

      final booksSnapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('books')
          .get();

      final List<ReadingSession> sessions = [];

      for (final book in booksSnapshot.docs) {
        final sessionsSnapshot = await book.reference
            .collection('reading_sessions')
            .where(
              'startedAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfToday),
            )
            .where('startedAt', isLessThan: Timestamp.fromDate(startOfTomorrow))
            .get();

        sessions.addAll(
          sessionsSnapshot.docs.map((doc) => ReadingSession.fromFirestore(doc)),
        );
      }

      return sessions;
    } catch (e) {
      throw Exception('Failed to fetch today reading sessions: $e');
    }
  }

  Future<Map<String, int>> fetchDailyGoals() async {
    try {
      final uid = _getCurrentUserId();

      final userDoc = await firestore.collection('users').doc(uid).get();

      final data = userDoc.data() ?? {};

      return {
        'dailyGoalPages': (data['dailyGoalPages'] as int?) ?? 0,
        'dailyGoalMinutes': (data['dailyGoalMinutes'] as int?) ?? 0,
      };
    } catch (e) {
      throw Exception('Failed to fetch daily goals: $e');
    }
  }
}
