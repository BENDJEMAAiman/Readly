import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';
import 'package:readly/features/readly/profile/model/user_stats.dart';

class ProfileWebService {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ProfileWebService(this.firestore, this.auth);

  String _getCurrentUserId() {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    return user.uid;
  }

  Future<UserStats> fetchUserStats() async {
    try {
      final uid = _getCurrentUserId();

      // Fetch the user's document.
      final userDoc = await firestore.collection('users').doc(uid).get();

      final userData = userDoc.data() ?? {};

      // Fetch all books.
      final booksSnapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('books')
          .get();

      int booksCompleted = 0;
      int pagesRead = 0;
      int totalReadingSeconds = 0;
      int todayReadingSeconds = 0;

      final now = DateTime.now();

      for (final bookDoc in booksSnapshot.docs) {
        final bookData = bookDoc.data();

        // Count completed books.
        if (bookData['readingStatus'] == ReadingStatus.completed.name) {
          booksCompleted++;
        }

        // Fetch this book's reading sessions.
        final sessionsSnapshot = await bookDoc.reference
            .collection('reading_sessions')
            .get();

        for (final sessionDoc in sessionsSnapshot.docs) {
          final sessionData = sessionDoc.data();

          final sessionPagesRead = (sessionData['pagesRead'] as int?) ?? 0;

          final durationSeconds = (sessionData['durationSeconds'] as int?) ?? 0;

          pagesRead += sessionPagesRead;
          totalReadingSeconds += durationSeconds;

          final startedAt = sessionData['startedAt'];

          if (startedAt is Timestamp) {
            final sessionDate = startedAt.toDate();

            if (_isSameDay(sessionDate, now)) {
              todayReadingSeconds += durationSeconds;
            }
          }
        }
      }

      return UserStats(
        booksCompleted: booksCompleted,
        pagesRead: pagesRead,
        totalReadingMinutes: totalReadingSeconds ~/ 60,
        dailyGoalMinutes: (userData['dailyGoalMinutes'] as int?) ?? 0,
        todayReadingMinutes: todayReadingSeconds ~/ 60,
      );
    } catch (e) {
      throw Exception('Failed to fetch user stats: $e');
    }
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}
