import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NoteEntity extends Equatable {
  final String noteId;
  final String bookId;
  final String title;
  final String content;
  final int pageNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NoteEntity({
    required this.noteId,
    required this.bookId,
    required this.title,
    required this.content,
    required this.pageNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NoteEntity.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};

    return NoteEntity(
      noteId: document.id,
      bookId: data['bookId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      content: data['content'] as String? ?? '',
      pageNumber: data['pageNumber'] as int? ?? 0,
      createdAt: _dateTimeFromFirestore(data['createdAt']),
      updatedAt: _dateTimeFromFirestore(data['updatedAt']),
    );
  }

  NoteEntity copyWith({
    String? noteId,
    String? bookId,
    String? title,
    String? content,
    int? pageNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteEntity(
      noteId: noteId ?? this.noteId,
      bookId: bookId ?? this.bookId,
      title: title ?? this.title,
      content: content ?? this.content,
      pageNumber: pageNumber ?? this.pageNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
        noteId,
        bookId,
        title,
        content,
        pageNumber,
        createdAt,
        updatedAt,
      ];
}