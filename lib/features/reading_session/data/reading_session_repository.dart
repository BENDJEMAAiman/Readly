import '../model/reading_session.dart';
import 'reading_session_web_service.dart';

class ReadingSessionRepository {
  final ReadingSessionWebService readingSessionWebService;

  ReadingSessionRepository(this.readingSessionWebService);

  Future<ReadingSession> addReadingSession({
    required String bookId,
    required DateTime startedAt,
    required DateTime endedAt,
    required int durationSeconds,
    required int pagesRead,
  }) async {
    return await readingSessionWebService.addReadingSession(
      bookId: bookId,
      startedAt: startedAt,
      endedAt: endedAt,
      durationSeconds: durationSeconds,
      pagesRead: pagesRead,
    );
  }

  Future<List<ReadingSession>> fetchReadingSessionsForBook(
    String bookId,
  ) async {
    return await readingSessionWebService.fetchReadingSessionsForBook(
      bookId,
    );
  }
}