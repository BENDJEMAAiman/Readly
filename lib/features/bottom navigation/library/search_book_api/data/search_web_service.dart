import 'package:dio/dio.dart';

class SearchWebService {
  
  final Dio dio;
  SearchWebService(this.dio);

  Future<List<dynamic>> getSearchResults(String title) async {
    print(title);
    try {
  final response = await dio.get(
    "/search.json",
    queryParameters: {
      'q': title,
      'fields':
          'key,title,author_name,cover_i,edition_key, number_of_pages_median',
      'limit': 20,
    },
  );
  
  return response.data["docs"];
} on DioException catch (e) {
      print(e.response?.statusCode);
      print(e.response?.data);
      throw Exception("Failed to fetch search api: ${e.message}");

    }
  }
}