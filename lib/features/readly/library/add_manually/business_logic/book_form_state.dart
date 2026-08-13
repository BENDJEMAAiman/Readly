import 'dart:io';

import 'package:readly/features/readly/library/library/model/library_book.dart';

class BookFormState {
  final String title;
  final String author;
  final String description;
  final String category;
  final File? coverImage;

  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  final ReadingStatus? readingStatus;

  const BookFormState({
    this.title = '',
    this.author = '',
    this.description = '',
    this.category = '',
    this.coverImage,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
    this.readingStatus,
  });

  BookFormState copyWith({
    String? title,
    String? author,
    String? description,
    String? category,
    File? coverImage,
    bool removeCoverImage = false,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    bool clearError = false,
    ReadingStatus? readingStatus,
  }) {
    return BookFormState(
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      category: category ?? this.category,
      coverImage: removeCoverImage
          ? null
          : coverImage ?? this.coverImage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
      readingStatus: readingStatus ?? this.readingStatus,
    );
  }
}