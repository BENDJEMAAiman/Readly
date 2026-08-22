import 'package:equatable/equatable.dart';

sealed class HomeProgressState extends Equatable {
  const HomeProgressState();

  @override
  List<Object?> get props => [];
}

class HomeProgressInitial extends HomeProgressState {
  const HomeProgressInitial();
}

class HomeProgressLoading extends HomeProgressState {
  const HomeProgressLoading();
}

class HomeProgressLoaded extends HomeProgressState {
  final int libraryBooksCount;
  final int finishedBooksCount;
  final int notesCount;
  final int readingMinutes;

  const HomeProgressLoaded({
    required this.libraryBooksCount,
    required this.finishedBooksCount,
    required this.notesCount,
    required this.readingMinutes,
  });

  @override
  List<Object?> get props => [
        libraryBooksCount,
        finishedBooksCount,
        notesCount,
        readingMinutes,
      ];
}

class HomeProgressError extends HomeProgressState {
  final String message;

  const HomeProgressError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}