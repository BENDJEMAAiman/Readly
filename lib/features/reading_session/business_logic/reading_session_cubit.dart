import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readly/features/reading_session/business_logic/reading_session_state.dart';
import 'package:readly/features/reading_session/data/reading_session_repository.dart';
import 'package:readly/features/readly/library/library/data/library_repository.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';

class ReadingSessionCubit extends Cubit<ReadingSessionState> {
  final ReadingSessionRepository readingSessionRepository;
  final LibraryRepository libraryRepository;

  ReadingSessionCubit(this.readingSessionRepository, this.libraryRepository)
    : super(const SessionIdle());

  Timer? _timer;

  LibraryBook? _book;

  DateTime? _startedAt;

  int _durationSeconds = 0;

  bool _isSaving = false;

  // ------------------------------------------------------------
  // START SESSION
  // ------------------------------------------------------------

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

  // ------------------------------------------------------------
  // PAUSE SESSION
  // ------------------------------------------------------------

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

  // ------------------------------------------------------------
  // RESUME SESSION
  // ------------------------------------------------------------

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

  // ------------------------------------------------------------
  // STOP AND SAVE SESSION
  // ------------------------------------------------------------

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
      // ----------------------------------------------------------
      // 1. Calculate the new current page
      // ----------------------------------------------------------

      final totalPages = book.pages;

      if (totalPages == null || totalPages <= 0) {
        emit(
          const SessionError(
            message: 'This book does not have a valid total page count.',
          ),
        );
        return;
      }

      final newCurrentPage = book.currentPage + pagesRead;

      final updatedCurrentPage = newCurrentPage >= totalPages
          ? totalPages
          : newCurrentPage;

      final reachedEnd = updatedCurrentPage >= totalPages;

      // ----------------------------------------------------------
      // 4. Update the book
      // ----------------------------------------------------------

      final newReadingStatus = reachedEnd
          ? ReadingStatus.completed
          : ReadingStatus.reading;

      final updatedBook = book.copyWith(
        currentPage: updatedCurrentPage,
        readingStatus: newReadingStatus,
      );

      await libraryRepository.updateBook(updatedBook);

      // ----------------------------------------------------------
      // 5. Save the reading session
      // ----------------------------------------------------------

      final session = await readingSessionRepository.addReadingSession(
        bookId: book.id!,
        startedAt: startedAt,
        endedAt: DateTime.now(),
        durationSeconds: _durationSeconds,
        pagesRead: pagesRead,
      );

      // ----------------------------------------------------------
      // 6. Tell the UI that everything succeeded
      // ----------------------------------------------------------

      emit(
        SessionCompleted(
          session: session,
          book: updatedBook,
          bookCompleted: reachedEnd,
        ),
      );

      _clearSession();
    } catch (e) {
      emit(SessionError(message: e.toString()));
    } finally {
      _isSaving = false;
    }
  }

  // ------------------------------------------------------------
  // DISCARD SESSION
  // ------------------------------------------------------------

  void discardSession() {
    _timer?.cancel();
    _timer = null;

    _clearSession();

    emit(const SessionIdle());
  }

  // ------------------------------------------------------------
  // TIMER
  // ------------------------------------------------------------

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

  // ------------------------------------------------------------
  // CLEAR SESSION DATA
  // ------------------------------------------------------------

  void _clearSession() {
    _timer?.cancel();
    _timer = null;

    _book = null;
    _startedAt = null;
    _durationSeconds = 0;
  }

  // ------------------------------------------------------------
  // CLOSE
  // ------------------------------------------------------------

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
