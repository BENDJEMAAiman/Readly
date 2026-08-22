import 'package:equatable/equatable.dart';

class ReadingGoalAchievement extends Equatable {
  final bool timeGoalAchieved;
  final bool pagesGoalAchieved;

  const ReadingGoalAchievement({
    this.timeGoalAchieved = false,
    this.pagesGoalAchieved = false,
  });

  bool get hasAchievement {
    return timeGoalAchieved || pagesGoalAchieved;
  }

  @override
  List<Object?> get props => [
        timeGoalAchieved,
        pagesGoalAchieved,
      ];
}