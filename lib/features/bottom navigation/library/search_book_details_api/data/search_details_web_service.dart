import 'dart:convert';

import 'package:dio/dio.dart';

class SearchDetailsWebService {
  final Dio dio;
  SearchDetailsWebService(this.dio);

  Future<Map<String, dynamic>> getWork(String workKey) async {
    try {
      final response = await dio.get("$workKey.json");
      print("print the work response");
      print(jsonEncode(response.data));
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw Exception("Failed to fetch work details: ${e.message}");
    }
  }

  Future<Map<String, dynamic>> getEdition(String editionKey) async {
    print("Edition key: $editionKey");
    try {
      final response = await dio.get("/books/$editionKey.json");
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw Exception("Failed to fetch edition details: ${e.message}");
    }
  }
}
