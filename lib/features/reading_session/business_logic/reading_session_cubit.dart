import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readly/features/reading_session/business_logic/reading_session_state.dart';
import 'package:readly/features/reading_session/data/reading_session_repository.dart';
import 'package:readly/features/reading_session/model/reading_goal_achievement.dart';
import 'package:readly/features/reading_session/model/reading_session.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';

class ReadingSessionCubit extends Cubit<ReadingSessionState> {
  final ReadingSessionRepository readingSessionRepository;

  ReadingSessionCubit(this.readingSessionRepository)
    : super(const SessionIdle());

  Timer? _timer;

  LibraryBook? _book;

  DateTime? _startedAt;

  int _durationSeconds = 0;

  bool _isSaving = false;

  // START SESSION

  void startSession(LibraryBook book) {
    if (_timer != null) {
      return;
    }

    if (book.id == null || book.id!.isEmpty) {
      emit(const SessionError(message: 'This book does not have a valid ID.'));
      return;
    }

    _book = book;
    _startedAt = DateTime.now();
    _durationSeconds = 0;

    _startTimer();

    emit(SessionActive(durationSeconds: _durationSeconds, book: book));
  }

  // PAUSE SESSION

  void pauseSession() {
    if (_timer == null) {
      return;
    }

    _timer?.cancel();
    _timer = null;

    final book = _book;

    if (book == null) {
      return;
    }

    emit(SessionPaused(durationSeconds: _durationSeconds, book: book));
  }

  // RESUME SESSION

  void resumeSession() {
    if (_timer != null) {
      return;
    }

    final book = _book;

    if (book == null) {
      return;
    }

    _startTimer();

    emit(SessionActive(durationSeconds: _durationSeconds, book: book));
  }

  // STOP AND SAVE SESSION

  Future<void> stopAndSaveSession({required int pagesRead}) async {
    if (_isSaving) {
      return;
    }

    final book = _book;
    final startedAt = _startedAt;

    if (book == null || startedAt == null) {
      emit(const SessionError(message: 'There is no active reading session.'));
      return;
    }

    if (pagesRead < 0) {
      emit(const SessionError(message: 'Pages read cannot be negative.'));
      return;
    }

    _isSaving = true;

    _timer?.cancel();
    _timer = null;

    emit(const SessionSaving());

    try {
      // Validate the book

      final totalPages = book.pages;

      if (totalPages == null || totalPages <= 0) {
        emit(
          const SessionError(
            message: 'This book does not have a valid total page count.',
          ),
        );
        return;
      }

      //Calculate the new current page

      final newCurrentPage = book.currentPage + pagesRead;

      final updatedCurrentPage = newCurrentPage >= totalPages
          ? totalPages
          : newCurrentPage;

      final reachedEnd = updatedCurrentPage >= totalPages;

      // Calculate the new reading status

      final newReadingStatus = reachedEnd
          ? ReadingStatus.completed
          : ReadingStatus.reading;

      // Create the updated book

      final updatedBook = book.copyWith(
        currentPage: updatedCurrentPage,
        readingStatus: newReadingStatus,
      );

      // Save book + reading session atomically

      final goalAchievement = await _checkGoalAchievement(
        sessionDurationSeconds: _durationSeconds,
        sessionPagesRead: pagesRead,
      );
      final endedAt = DateTime.now();

      final session = await readingSessionRepository
          .saveCompletedReadingSession(
            updatedBook: updatedBook,
            startedAt: startedAt,
            endedAt: endedAt,
            durationSeconds: _durationSeconds,
            pagesRead: pagesRead,
          );

      // Tell the UI that everything succeeded

      emit(
        SessionCompleted(
          session: session,
          book: updatedBook,
          bookCompleted: reachedEnd,
          goalAchievement: goalAchievement,
        ),
      );

      _clearSession();
    } catch (e) {
      emit(SessionError(message: e.toString()));
    } finally {
      _isSaving = false;
    }
  }

  // DISCARD SESSION

  void discardSession() {
    _timer?.cancel();
    _timer = null;

    _clearSession();

    emit(const SessionIdle());
  }

  // TIMER

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _durationSeconds++;

      final book = _book;

      if (book == null) {
        return;
      }

      emit(SessionActive(durationSeconds: _durationSeconds, book: book));
    });
  }

  // CLEAR SESSION DATA

  void _clearSession() {
    _timer?.cancel();
    _timer = null;

    _book = null;
    _startedAt = null;
    _durationSeconds = 0;
  }

  // CLOSE

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<ReadingGoalAchievement> _checkGoalAchievement({
    required int sessionDurationSeconds,
    required int sessionPagesRead,
  }) async {
    final results = await Future.wait([
      readingSessionRepository.fetchTodayReadingSessions(),
      readingSessionRepository.fetchDailyGoals(),
    ]);

    final todaySessions = results[0] as List<ReadingSession>;

    final goals = results[1] as Map<String, int>;

    // Progress BEFORE the current session.
    final previousReadingSeconds = todaySessions.fold<int>(
      0,
      (total, session) => total + session.durationSeconds,
    );

    final previousPagesRead = todaySessions.fold<int>(
      0,
      (total, session) => total + session.pagesRead,
    );

    // Progress AFTER the current session.
    final currentReadingSeconds =
        previousReadingSeconds + sessionDurationSeconds;

    final currentPagesRead = previousPagesRead + sessionPagesRead;
    final dailyGoalMinutes = goals['dailyGoalMinutes'] ?? 0;
    final dailyGoalPages = goals['dailyGoalPages'] ?? 0;
    final goalSeconds = dailyGoalMinutes * 60;

    final timeGoalAchieved =
        goalSeconds > 0 &&
        previousReadingSeconds < goalSeconds &&
        currentReadingSeconds >= goalSeconds;

    final pagesGoalAchieved =
        dailyGoalPages > 0 &&
        previousPagesRead < dailyGoalPages &&
        currentPagesRead >= dailyGoalPages;

    return ReadingGoalAchievement(
      timeGoalAchieved: timeGoalAchieved,
      pagesGoalAchieved: pagesGoalAchieved,
    );
  }
}
