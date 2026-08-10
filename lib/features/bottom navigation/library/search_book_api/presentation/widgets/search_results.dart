import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/bottom%20navigation/library/library/model/library_book.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/business_logic/search_cubit.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/business_logic/search_state.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/presentation/widgets/recent_activity.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/presentation/widgets/search_result_tile.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key, required this.onBookSelected});

  final ValueChanged<LibraryBook> onBookSelected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        switch (state) {
          case SearchInitial():
            return const RecentActivity();

          case SearchLoading():
            return const Center(child: CircularProgressIndicator());

          case SearchEmpty():
            return Center(
              child: Text("No books found.", style: AppTextStyles.bodyLarge),
            );

          case SearchError(:final msg):
            return Center(
              child: Text(
                msg,
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
            );

          case SearchSuccess(:final searchResults):
            return ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: searchResults.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final result = searchResults[index];

                return SearchResultTile(
                  workKey: result.workKey,
                  editionKey: result.editionKey,
                  title: result.title,
                  author: result.author,
                  coverId: result.coverId,
                  onTap: () async {
                    try {
                      final bookToAdd = await context.push<LibraryBook>(
                        Routes.searchDetails,
                        extra: result,
                      );

                      if (bookToAdd != null) {
                        onBookSelected(bookToAdd);
                        debugPrint('Online book received in SearchResults');
                        debugPrint(bookToAdd.title);
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  },
                );
              },
            );
        }
      },
    );
  }
}
