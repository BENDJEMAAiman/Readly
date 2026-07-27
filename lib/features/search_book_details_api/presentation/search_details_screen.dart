import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readly/features/search_book_api/model/search_model.dart';
import 'package:readly/features/search_book_details_api/business%20logic/search_details_cubit.dart';
import 'package:readly/features/search_book_details_api/business%20logic/search_details_state.dart';

class SearchDetailsScreen extends StatefulWidget {
  final SearchModel basicInfo;
  const SearchDetailsScreen({super.key, required this.basicInfo});

  @override
  State<SearchDetailsScreen> createState() => _SearchDetailsScreenState();
}

class _SearchDetailsScreenState extends State<SearchDetailsScreen> {
  @override
  initState() {
    context.read<SearchDetailsCubit>().getBookDetails(widget.basicInfo);
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SearchDetailsCubit, SearchDetailsState>(
        builder: (context, state) {
          switch (state) {
            case SearchDetailsInitial():
              return const SizedBox();

            case SearchDetailsLoading():
              return const Center(child: CircularProgressIndicator());

            case SearchDetailsError(:final msg):
              return Center(child: Text(msg));

            case SearchDetailsSuccess(:final book):
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        'https://covers.openlibrary.org/b/id/${widget.basicInfo.coverId}-L.jpg',
                        height: 220,
                        errorBuilder: (_, __, ___) {
                          return const Icon(Icons.book, size: 120);
                        },
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;

                          return const SizedBox(
                            height: 220,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(book.title),

                    const SizedBox(height: 8),

                    Text(book.author),

                    const SizedBox(height: 20),

                    Text("Publisher: ${book.publisher ?? "Unknown"}"),

                    Text("Language: ${book.language ?? "Unknown"}"),

                    Text(
                      "Pages: ${book.numberOfPages?.toString() ?? "Unknown"}",
                    ),

                    const SizedBox(height: 20),

                    Text(book.description ?? "No description available."),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
