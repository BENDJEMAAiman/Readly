import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:readly/features/reading_session/data/reading_session_repository.dart';
import 'package:readly/features/reading_session/model/reading_session.dart';
import 'package:readly/features/readly/home/business_logic/home_progress_state.dart';
import 'package:readly/features/readly/library/library/data/library_repository.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';
import 'package:readly/features/readly/notes/data/notes_repository.dart';

class HomeProgressCubit extends Cubit<HomeProgressState> {
  final LibraryRepository libraryRepository;
  final NotesRepository notesRepository;
  final ReadingSessionRepository readingSessionRepository;

  HomeProgressCubit({
    required this.libraryRepository,
    required this.notesRepository,
    required this.readingSessionRepository,
  }) : super(const HomeProgressInitial());

  Future<void> fetchHomeProgress() async {
    emit(const HomeProgressLoading());

    try {
      final results = await Future.wait([
        libraryRepository.getBooks(),
        notesRepository.fetchAllNotes(),
        readingSessionRepository.fetchTodayReadingSessions(),
      ]);

      final books = results[0] as List<LibraryBook>;
      final notes = results[1] as List;
      final readingSessions = results[2] as List<ReadingSession>;

      final libraryBooksCount = books.length;

      final finishedBooksCount = books
          .where((book) => book.readingStatus == ReadingStatus.completed)
          .length;

      final notesCount = notes.length;

      final totalReadingSeconds = readingSessions.fold<int>(
        0,
        (total, session) => total + session.durationSeconds,
      );

      final readingMinutes = (totalReadingSeconds / 60).floor();

      emit(
        HomeProgressLoaded(
          libraryBooksCount: libraryBooksCount,
          finishedBooksCount: finishedBooksCount,
          notesCount: notesCount,
          readingMinutes: readingMinutes,
        ),
      );
    } catch (e) {
      emit(HomeProgressError(message: e.toString()));
    }
  }
}
