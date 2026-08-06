import 'package:flutter/material.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/model/search_details_model.dart';

class BookFormControllers {
  final title = TextEditingController();
  final author = TextEditingController();
  final language = TextEditingController();
  final publisher = TextEditingController();
  final pages = TextEditingController();
  final description = TextEditingController();

  bool _initialized = false;

  void fill(SearchDetailsModel book) {
    if (_initialized) return;

    title.text = book.title;
    author.text = book.author;
    language.text = book.language ?? "";
    publisher.text = book.publisher ?? "";
    pages.text = book.numberOfPages?.toString() ?? "";
    description.text = book.description ?? "";

    _initialized = true;
  }

  void dispose() {
    title.dispose();
    author.dispose();
    language.dispose();
    publisher.dispose();
    pages.dispose();
    description.dispose();
  }
}