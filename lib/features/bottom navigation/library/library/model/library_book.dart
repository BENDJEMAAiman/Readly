import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class LibraryBook {
  final String? id;

  final String title;
  final String author;

  final String? description;
  final String? publisher;
  final String? language;

  final int? pages;

  final List<String> subjects;

  //OpenLibrary cover id.
  final int? coverId;

  // Local image selected manually. it will not be stored in Firestore.
  final File? coverFile;

  // Firebase Storage download URL.
  final String? coverImageUrl;

  final DateTime? createdAt;

  final ReadingStatus readingStatus;

  final int currentPage;

  const LibraryBook({
    this.id,
    required this.title,
    required this.author,
    this.description,
    this.publisher,
    this.language,
    this.pages,
    this.subjects = const [],
    this.coverId,
    this.coverFile,
    this.coverImageUrl,
    this.createdAt,
    this.readingStatus = ReadingStatus.wantToRead,
    this.currentPage = 0,
  });

  LibraryBook copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? publisher,
    String? language,
    int? pages,
    List<String>? subjects,
    int? coverId,
    File? coverFile,
    String? coverImageUrl,
    DateTime? createdAt,
    ReadingStatus? readingStatus,
    int? currentPage,

    bool clearId = false,
    bool clearDescription = false,
    bool clearPublisher = false,
    bool clearLanguage = false,
    bool clearPages = false,
    bool clearCoverId = false,
    bool removeCoverFile = false,
    bool removeCoverImageUrl = false,
    bool clearCreatedAt = false,
  }) {
    return LibraryBook(
      id: clearId ? null : id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: clearDescription ? null : description ?? this.description,
      publisher: clearPublisher ? null : publisher ?? this.publisher,
      language: clearLanguage ? null : language ?? this.language,
      pages: clearPages ? null : pages ?? this.pages,
      subjects: subjects ?? this.subjects,
      coverId: clearCoverId ? null : coverId ?? this.coverId,
      coverFile: removeCoverFile ? null : coverFile ?? this.coverFile,
      coverImageUrl: removeCoverImageUrl
          ? null
          : coverImageUrl ?? this.coverImageUrl,
      createdAt: clearCreatedAt ? null : createdAt ?? this.createdAt,
      readingStatus: readingStatus ?? this.readingStatus,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  // coverFile is intentionally excluded:
  //coverFile is a local File and must first be uploaded to Firebase Storage.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'publisher': publisher,
      'language': language,
      'pages': pages,
      'subjects': subjects,
      'coverId': coverId,
      'coverImageUrl': coverImageUrl,
      'createdAt': createdAt,
      'readingStatus': readingStatus.name,
      'currentPage': currentPage,
    };
  }

  factory LibraryBook.fromMap(Map<String, dynamic> map, {String? id}) {
    return LibraryBook(
      id: id,
      title: map['title'] as String? ?? '',
      author: map['author'] as String? ?? '',
      description: map['description'] as String?,
      publisher: map['publisher'] as String?,
      language: map['language'] as String?,
      pages: map['pages'] as int?,
      subjects: List<String>.from(map['subjects'] ?? const []),
      coverId: map['coverId'] as int?,
      coverImageUrl: map['coverImageUrl'] as String?,
      createdAt: _dateTimeFromFirestore(map['createdAt']),
      readingStatus: _readingStatusFromString(map['readingStatus'] as String?),
      currentPage: map['currentPage'] as int? ?? 0,
    );
  }

  static DateTime? _dateTimeFromFirestore(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is Timestamp) {
    return value.toDate();
  }

  if (value is DateTime) {
    return value;
  }

  return null;
}

  static ReadingStatus _readingStatusFromString(String? value) {
    return ReadingStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => ReadingStatus.wantToRead,
    );
  }
}

enum ReadingStatus { wantToRead, reading, completed }
