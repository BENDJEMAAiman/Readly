import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/model/search_model.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/business%20logic/search_details_state.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/data/search_details_repository.dart';

class SearchDetailsCubit extends Cubit<SearchDetailsState>{
  SearchDetailsCubit(this.searchDetailsRepository) : super(SearchDetailsInitial());

  final SearchDetailsRepository searchDetailsRepository;

  Future<void> getBookDetails(SearchModel basicInfo) async{
    emit(const SearchDetailsLoading());

    try {
      final book = await searchDetailsRepository.getBookDetails(basicInfo);
      emit(SearchDetailsSuccess(book));
    } catch (e) {
      emit(SearchDetailsError(e.toString()));
    }
  }

}