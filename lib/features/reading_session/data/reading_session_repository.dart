import 'package:readly/features/readly/library/library/model/library_book.dart';

import '../model/reading_session.dart';
import 'reading_session_web_service.dart';

class ReadingSessionRepository {
  final ReadingSessionWebService readingSessionWebService;

  ReadingSessionRepository(this.readingSessionWebService);

  Future<List<ReadingSession>> fetchReadingSessionsForBook(
    String bookId,
  ) async {
    return await readingSessionWebService.fetchReadingSessionsForBook(bookId);
  }

  Future<ReadingSession> saveCompletedReadingSession({
    required LibraryBook updatedBook,
    required DateTime startedAt,
    required DateTime endedAt,
    required int durationSeconds,
    required int pagesRead,
  }) async {
    return await readingSessionWebService.saveCompletedReadingSession(
      updatedBook: updatedBook,
      startedAt: startedAt,
      endedAt: endedAt,
      durationSeconds: durationSeconds,
      pagesRead: pagesRead,
    );
  }

  Future<List<ReadingSession>> fetchTodayReadingSessions() async {
    return await readingSessionWebService.fetchTodayReadingSessions();
  }

  Future<Map<String, int>> fetchDailyGoals() async {
  return await readingSessionWebService.fetchDailyGoals();
}
}
