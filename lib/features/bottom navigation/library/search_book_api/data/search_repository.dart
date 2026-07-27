import 'package:readly/features/bottom%20navigation/library/search_book_api/data/search_web_service.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/model/search_model.dart';


class SearchRepository {
  final SearchWebService searchWebService;
  SearchRepository(this.searchWebService);

  Future<List<SearchModel>> searchBooks(String title) async {
    try {
      final List<dynamic> data = await searchWebService.getSearchResults(title);
      

      return data.map((book) => SearchModel.fromJson(book)).toList();
    } on Exception {
      rethrow;
    }
  }
}
