import 'dart:io';

class LibraryBook {
  final String title;
  final String author;

  final String? description;
  final String? publisher;
  final String? language;

  final int? pages;

  final List<String> subjects;

  /// OpenLibrary cover id.
  final int? coverId;

  /// Local image selected manually.
  final File? coverFile;

  const LibraryBook({
    required this.title,
    required this.author,
    this.description,
    this.publisher,
    this.language,
    this.pages,
    this.subjects = const [],
    this.coverId,
    this.coverFile,
  });
}