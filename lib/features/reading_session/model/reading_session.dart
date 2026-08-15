import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ReadingSession extends Equatable {
  final String sessionId;
  final String bookId;

  final DateTime startedAt;
  final DateTime endedAt;

  /// Actual active reading time measured by the stopwatch.
  final int durationSeconds;

  /// Number of pages the user entered after finishing the session.
  final int pagesRead;

  const ReadingSession({
    required this.sessionId,
    required this.bookId,
    required this.startedAt,
    required this.endedAt,
    required this.durationSeconds,
    required this.pagesRead,
  });

  factory ReadingSession.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};

    return ReadingSession(
      sessionId: document.id,
      bookId: data['bookId'] as String? ?? '',
      startedAt: _dateTimeFromFirestore(data['startedAt']),
      endedAt: _dateTimeFromFirestore(data['endedAt']),
      durationSeconds: data['durationSeconds'] as int? ?? 0,
      pagesRead: data['pagesRead'] as int? ?? 0,
    );
  }

  ReadingSession copyWith({
    String? sessionId,
    String? bookId,
    DateTime? startedAt,
    DateTime? endedAt,
    int? durationSeconds,
    int? pagesRead,
  }) {
    return ReadingSession(
      sessionId: sessionId ?? this.sessionId,
      bookId: bookId ?? this.bookId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      pagesRead: pagesRead ?? this.pagesRead,
    );
  }

  static DateTime _dateTimeFromFirestore(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.now();
  }

  @override
  List<Object?> get props => [
        sessionId,
        bookId,
        startedAt,
        endedAt,
        durationSeconds,
        pagesRead,
      ];
}