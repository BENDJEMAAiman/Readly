import 'package:equatable/equatable.dart';

class SearchModel extends Equatable {
  final String workKey;
  final String editionKey;
  final String title;
  final String author;
  final int? coverId;
  final int? pagesApprox;

  const SearchModel({
    required this.workKey,
    required this.editionKey,
    required this.title,
    required this.author,
    required this.pagesApprox,
    this.coverId,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      workKey: json["key"] as String,

      editionKey: (json["edition_key"] as List?)?.isNotEmpty == true
          ? json["edition_key"][0] as String
          : "",

      title: json["title"] as String? ?? "Unknown title",

      author: (json["author_name"] as List?)?.isNotEmpty == true
          ? json["author_name"][0] as String
          : "Unknown author",

      coverId: json["cover_i"] as int?,
      pagesApprox: json["number_of_pages_median"] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "key": workKey,
      "edition_key": editionKey,
      "title": title,
      "author_name": author,
      "cover_i": coverId,
      "number_of_pages_median": pagesApprox,
    };
  }

  @override
  List<Object?> get props => [workKey, editionKey, title, author, coverId, pagesApprox];
}
