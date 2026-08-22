import 'package:equatable/equatable.dart';

class UserStats extends Equatable {
  final int booksCompleted;
  final int pagesRead;
  final int totalReadingMinutes;

  // Daily goals
  final int dailyGoalMinutes;
  final int dailyGoalPages;

  // Today's progress
  final int todayReadingMinutes;
  final int todayPagesRead;

  const UserStats({
    this.booksCompleted = 0,
    this.pagesRead = 0,
    this.totalReadingMinutes = 0,
    this.dailyGoalMinutes = 0,
    this.dailyGoalPages = 0,
    this.todayReadingMinutes = 0,
    this.todayPagesRead = 0,
  });

  UserStats copyWith({
    int? booksCompleted,
    int? pagesRead,
    int? totalReadingMinutes,
    int? dailyGoalMinutes,
    int? dailyGoalPages,
    int? todayReadingMinutes,
    int? todayPagesRead,
  }) {
    return UserStats(
      booksCompleted: booksCompleted ?? this.booksCompleted,
      pagesRead: pagesRead ?? this.pagesRead,
      totalReadingMinutes:
          totalReadingMinutes ?? this.totalReadingMinutes,
      dailyGoalMinutes:
          dailyGoalMinutes ?? this.dailyGoalMinutes,
      dailyGoalPages:
          dailyGoalPages ?? this.dailyGoalPages,
      todayReadingMinutes:
          todayReadingMinutes ?? this.todayReadingMinutes,
      todayPagesRead:
          todayPagesRead ?? this.todayPagesRead,
    );
  }

  @override
  List<Object?> get props => [
        booksCompleted,
        pagesRead,
        totalReadingMinutes,
        dailyGoalMinutes,
        dailyGoalPages,
        todayReadingMinutes,
        todayPagesRead,
      ];
}