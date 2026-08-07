import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readly/features/bottom%20navigation/library/book_management/model/library_book.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/model/search_model.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/business%20logic/search_details_state.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/data/search_details_repository.dart';

class SearchDetailsCubit extends Cubit<SearchDetailsState> {
  SearchDetailsCubit(this.searchDetailsRepository)
    : super(SearchDetailsInitial());

  final SearchDetailsRepository searchDetailsRepository;

  Future<void> getBookDetails(SearchModel basicInfo) async {
    emit(const SearchDetailsLoading());

    try {
      final book = await searchDetailsRepository.getBookDetails(basicInfo);

      emit(SearchDetailsSuccess(book: book));
    } catch (e) {
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
