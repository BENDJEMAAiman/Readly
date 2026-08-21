import 'package:equatable/equatable.dart';

class UserStats extends Equatable {
  final int booksCompleted;
  final int pagesRead;
  final int totalReadingMinutes;
  final int dailyGoalMinutes;
  final int todayReadingMinutes;

  const UserStats({
    this.booksCompleted = 0,
    this.pagesRead = 0,
    this.totalReadingMinutes = 0,
    this.dailyGoalMinutes = 0,
    this.todayReadingMinutes = 0,
  });

  UserStats copyWith({
    int? booksCompleted,
    int? pagesRead,
    int? totalReadingMinutes,
    int? dailyGoalMinutes,
    int? todayReadingMinutes,
  }) {
    return UserStats(
      booksCompleted: booksCompleted ?? this.booksCompleted,
      pagesRead: pagesRead ?? this.pagesRead,
      totalReadingMinutes:
          totalReadingMinutes ?? this.totalReadingMinutes,
      dailyGoalMinutes:
          dailyGoalMinutes ?? this.dailyGoalMinutes,
      todayReadingMinutes:
          todayReadingMinutes ?? this.todayReadingMinutes,
    );
  }

  @override
  List<Object?> get props => [
        booksCompleted,
        pagesRead,
        totalReadingMinutes,
        dailyGoalMinutes,
        todayReadingMinutes,
      ];
}