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
  const SearchDetailsSuccess(this.book);
}

final class SearchDetailsError extends SearchDetailsState {
  final String msg;

  const SearchDetailsError(this.msg);
}