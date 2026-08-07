import 'package:readly/features/bottom%20navigation/library/book_management/model/library_book.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/model/search_details_model.dart';

sealed class SearchDetailsState {
  const SearchDetailsState();
}

final class SearchDetailsInitial extends SearchDetailsState {
  const SearchDetailsInitial();
}

final class SearchDetailsLoading extends SearchDetailsState {
  const SearchDetailsLoading();
}

final class SearchDetailsSuccess extends SearchDetailsState {
  final SearchDetailsModel book;
  final ReadingStatus? readingStatus;
  const SearchDetailsSuccess({required this.book, this.readingStatus});

  SearchDetailsSuccess copyWith({
    SearchDetailsModel? book,
    ReadingStatus? readingStatus,
  }) {
    return SearchDetailsSuccess(
      book: book ?? this.book,
      readingStatus: readingStatus ?? this.readingStatus,
    );
  }
}

final class SearchDetailsError extends SearchDetailsState {
  final String msg;

  const SearchDetailsError(this.msg);
}
