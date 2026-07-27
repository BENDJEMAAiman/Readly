import 'dart:convert';

import 'package:readly/features/bottom%20navigation/library/search_book_api/model/search_model.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/data/search_details_web_service.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/model/search_details_model.dart';


class SearchDetailsRepository {
  final SearchDetailsWebService searchDetailsWebService;
  SearchDetailsRepository(this.searchDetailsWebService);

  Future<SearchDetailsModel> getBookDetails(SearchModel basicInfo) async {
    final work = await searchDetailsWebService.getWork(basicInfo.workKey);
    print("printing the work");
    print(jsonEncode(work));

    final edition = await searchDetailsWebService.getEdition(basicInfo.editionKey);
     print("printing the edition");
    print(jsonEncode(edition));

    return SearchDetailsModel.fromResponses(basicInfo, work, edition);
  }

  
}
