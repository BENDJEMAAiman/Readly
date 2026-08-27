import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';
import 'package:readly/features/readly/library/search_book_api/model/search_model.dart';
import 'package:readly/features/readly/library/search_book_details_api/business%20logic/search_details_state.dart';
import 'package:readly/features/readly/library/search_book_details_api/data/search_details_repository.dart';

class SearchDetailsCubit extends Cubit<SearchDetailsState> {
  SearchDetailsCubit(this.searchDetailsRepository)
    : super(SearchDetailsInitial());

  final SearchDetailsRepository searchDetailsRepository;

  Future<void> getBookDetails(SearchModel basicInfo) async {
    if (isClosed) return;

    emit(const SearchDetailsLoading());

    try {
      final book = await searchDetailsRepository.getBookDetails(basicInfo);

      // The screen may have been popped while waiting for the API.
      if (isClosed) return;

      emit(SearchDetailsSuccess(book: book));
    } catch (e) {
      // Same situation can happen if the request fails
      // after the screen has already been popped.
      if (isClosed) return;

      emit(SearchDetailsError(e.toString()));
    }
  }

  void updateReadingStatus(ReadingStatus status) {
    final current = state;

    if (current is SearchDetailsSuccess) {
      emit(current.copyWith(readingStatus: status));
    }
  }

  bool get isReadingStatusSelected {
    final current = state;

    return current is SearchDetailsSuccess && current.readingStatus != null;
  }

  ReadingStatus get selectedReadingStatus {
    final current = state as SearchDetailsSuccess;
    return current.readingStatus!;
  }
}
