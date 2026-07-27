import 'package:readly/features/search_book_api/model/search_model.dart';

sealed class SearchState {
  const SearchState();
}

final class SearchInitial extends SearchState {
  const SearchInitial() : super();
}

final class SearchLoading extends SearchState {
  const SearchLoading();
}

final class SearchEmpty extends SearchState {
  const SearchEmpty();
}

final class SearchSuccess extends SearchState {
  final List<SearchModel> searchResults;
  const SearchSuccess(this.searchResults);
}

final class SearchError extends SearchState {
  final String msg;
  const SearchError(this.msg);
}
