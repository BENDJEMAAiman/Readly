import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readly/features/readly/library/search_book_api/business_logic/search_state.dart';
import 'package:readly/features/readly/library/search_book_api/data/search_repository.dart';


class SearchCubit extends Cubit<SearchState>{
  SearchCubit(this.searchRepository) : super(SearchInitial());

  final SearchRepository searchRepository;

  Future<void> searchBooks(String title) async{

    if(title.trim().isEmpty) {
      if (isClosed) return;


      emit(SearchInitial());
      return;
    }

    if (isClosed) return;

    emit(SearchLoading());
    try {
      final searchResults = await searchRepository.searchBooks(title);

      if (isClosed) return;



      if (searchResults.isEmpty) {
        emit(SearchEmpty());
      }
      else {
        emit(SearchSuccess(searchResults));
      }
    } catch (e) {
      if (isClosed) return;
      emit(SearchError(e.toString()));
    }

  }

}