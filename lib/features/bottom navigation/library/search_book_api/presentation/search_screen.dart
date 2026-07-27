import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readly/core/dependency_injection.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/business_logic/search_cubit.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/business_logic/search_state.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/business%20logic/search_details_cubit.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/presentation/search_details_screen.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.search,
                controller: titleController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "must enter a book title to search";
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    context.read<SearchCubit>().searchBooks(
                      titleController.text.trim(),
                    );
                    if (context.read<SearchCubit>().state is SearchLoading) {
                      return;
                    }
                  }
                },
                decoration: InputDecoration(hintText: "Search Books"),
              ),
            ),

            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: ((context, state) {
                  switch (state) {
                    case SearchInitial():
                      return Center(child: Text("type to search a book"));
                    case SearchLoading():
                      return const Center(child: CircularProgressIndicator());
                    case SearchEmpty():
                      return Center(child: Text("no matching book"));
                    case SearchError(:final msg):
                      return Text(msg);
                    case SearchSuccess(:final searchResults):
                      return ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: ((context, index) {
                          final searchResult = searchResults[index];
                          return ListTile(
                            leading: Image.network(
                              'https://covers.openlibrary.org/b/id/${searchResult.coverId}-M.jpg',
                              width: 60,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;

                                return const SizedBox(
                                  width: 60,
                                  height: 90,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox(
                                  width: 60,
                                  height: 90,
                                  child: Icon(Icons.book),
                                );
                              },
                            ),
                            title: Text(searchResult.title),
                            subtitle: Text("author: ${searchResult.author}"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (_) => SearchDetailsCubit(
                                      searchDetailsRepository,
                                    ),
                                    child: SearchDetailsScreen(
                                      basicInfo: searchResult,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      );
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
