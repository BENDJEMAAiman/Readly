class BookFormValidators {

  static String? title(String? value) {

    if (value == null || value.trim().isEmpty) {
      return "Book title is required";
    }

    return null;
  }

  static String? pages(String? value) {

    if (value == null || value.trim().isEmpty) {
      return "Number of pages is required";
    }

    final pages = int.tryParse(value);

    if (pages == null) {
      return "Enter a valid number";
    }

    if (pages <= 0) {
      return "Pages must be greater than zero";
    }

    return null;
  }
}