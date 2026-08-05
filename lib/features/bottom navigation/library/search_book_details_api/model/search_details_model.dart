import 'package:equatable/equatable.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/model/search_model.dart';

class SearchDetailsModel extends Equatable {
  final String workKey;
  final String title;
  final String author;

  final int? coverId;
  final String? description;
  final String? language;
  final String? publisher;
  final int? numberOfPages;
  final List<String>? subjects;

  const SearchDetailsModel({
    required this.workKey,
    required this.title,
    required this.author,
    this.coverId,
    this.description,
    this.language,
    this.numberOfPages,
    this.publisher,
    this.subjects,
  });

  factory SearchDetailsModel.fromResponses(
    SearchModel basicInfo,
    Map<String, dynamic> workJson,
    Map<String, dynamic> editionJson,
  ) {
    final edition = editionJson;

    return SearchDetailsModel(
      workKey: basicInfo.workKey,
      author: basicInfo.author,
      coverId: basicInfo.coverId,

      description: workJson["description"] is String
          ? workJson["description"]
          : (workJson["description"]?["value"] as String?),

      subjects: (workJson["subjects"] as List?)
          ?.map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toSet()
          .take(4)
          .toList(),

      title: edition["title"] as String? ?? basicInfo.title,

      publisher: (edition["publishers"] as List?)?.isNotEmpty == true
          ? edition["publishers"][0].toString()
          : null,

      language: (edition["languages"] as List?)?.isNotEmpty == true
          ? (edition["languages"][0]["key"] as String).split("/").last
          : null,

      numberOfPages:
          edition["number_of_pages"] as int? ?? basicInfo.pagesApprox,
    );
  }

  @override
  List<Object?> get props => [
    workKey,
    title,
    author,
    description,
    language,
    numberOfPages,
    publisher,
    subjects,
    coverId,
  ];
}
