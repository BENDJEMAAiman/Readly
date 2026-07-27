import 'package:dio/dio.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(baseUrl: "https://openlibrary.org")
  );
}