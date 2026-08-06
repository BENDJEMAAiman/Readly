import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readly/features/bottom%20navigation/library/add_manually/business_logic/book_form_state.dart';
import 'package:readly/features/bottom%20navigation/library/book_management/model/library_book.dart';

class BookFormCubit extends Cubit<BookFormState> {
  BookFormCubit() : super(const BookFormState());

  final ImagePicker _picker = ImagePicker();

  void updateTitle(String value) {
    emit(state.copyWith(title: value));
  }

  void updateAuthor(String value) {
    emit(state.copyWith(author: value));
  }

  void updateDescription(String value) {
    emit(state.copyWith(description: value));
  }

  void updateCategory(String value) {
    emit(state.copyWith(category: value));
  }

  Future<void> pickCoverImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    emit(state.copyWith(coverImage: File(image.path)));
  }

  void removeCoverImage() {
    emit(state.copyWith(removeCoverImage: true));
  }

  LibraryBook createLibraryBook({
    required String title,
    required String author,
    required String publisher,
    required String language,
    required String description,
    required String category,
    required int? pages,
  }) {
    return LibraryBook(
      title: title,
      author: author,
      publisher: publisher.isEmpty ? null : publisher,
      language: language.isEmpty ? null : language,
      description: description.isEmpty ? null : description,
      pages: pages,
      subjects: category.isEmpty ? [] : [category],
      coverFile: state.coverImage,
    );
  }
}
