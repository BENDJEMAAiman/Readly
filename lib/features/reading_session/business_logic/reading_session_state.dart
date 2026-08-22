import 'package:equatable/equatable.dart';
import 'package:readly/features/reading_session/model/reading_goal_achievement.dart';
import 'package:readly/features/reading_session/model/reading_session.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';

abstract class ReadingSessionState extends Equatable {
  const ReadingSessionState();

  @override
  List<Object?> get props => [];
}

class SessionIdle extends ReadingSessionState {
  const SessionIdle();
}

class SessionActive extends ReadingSessionState {
  final int durationSeconds;
  final LibraryBook book;

  const SessionActive({required this.durationSeconds, required this.book});

  @override
  List<Object?> get props => [durationSeconds, book];
}

class SessionPaused extends ReadingSessionState {
  final int durationSeconds;
  final LibraryBook book;

  const SessionPaused({required this.durationSeconds, required this.book});

  @override
  List<Object?> get props => [durationSeconds, book];
}

class SessionSaving extends ReadingSessionState {
  const SessionSaving();
}

class SessionCompleted extends ReadingSessionState {
  final ReadingSession session;
  final LibraryBook book;
  final bool bookCompleted;
  final ReadingGoalAchievement goalAchievement;

  const SessionCompleted({
    required this.session,
    required this.book,
    required this.bookCompleted,
    required this.goalAchievement,
  });

  @override
  List<Object?> get props => [
        session,
        book,
        bookCompleted,
        goalAchievement,
      ];
}

class SessionError extends ReadingSessionState {
  final String message;

  const SessionError({required this.message});

  @override
  List<Object?> get props => [message];
}
