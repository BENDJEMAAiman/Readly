import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/features/readly/library/library/business_logic/library_cubit.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';
import 'package:readly/features/readly/library/search_book_api/presentation/widgets/add_manually_button.dart';
import 'package:readly/features/readly/library/search_book_api/presentation/widgets/search_header.dart';
import 'package:readly/features/readly/library/search_book_api/presentation/widgets/search_results.dart';
import 'package:readly/features/readly/library/search_book_api/presentation/widgets/search_text_field.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

final titleController = TextEditingController();
final _formKey = GlobalKey<FormState>();

class _SearchScreenState extends State<SearchScreen> {
  LibraryBook? _bookToAdd;

  @override
  Widget build(BuildContext context) {
    return PopScope<LibraryBook?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        debugPrint('========== SEARCH SCREEN POP ==========');
        debugPrint('Book being returned: ${_bookToAdd?.title}');
        debugPrint('Book ID: ${_bookToAdd?.id}');
        debugPrint('=======================================');

        context.pop(_bookToAdd);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchHeader(
                  onBack: () {
                    debugPrint('========== SEARCH BACK ==========');
                    debugPrint('_bookToAdd: ${_bookToAdd?.title}');
                    debugPrint('_bookToAdd ID: ${_bookToAdd?.id}');
                    debugPrint('=================================');
                    context.pop(_bookToAdd);
                  },
                ),
                SizedBox(height: 32.h),
                SearchTextField(controller: titleController, formKey: _formKey),
                SizedBox(height: 24.h),

                AddManuallyButton(
                  onPressed: () async {
                    try {
                      final LibraryBook? book = await context.push<LibraryBook>(
                        Routes.addBookManually,
                      );

                      if (book != null) {
                        debugPrint('Manual book received in SearchScreen');
                        debugPrint(book.title);
                        await context.read<LibraryCubit>().addBook(book);
                      }
                    } catch (e, stackTrace) {
                      debugPrint('Navigation error: $e');
                      debugPrintStack(stackTrace: stackTrace);
                    }
                  },
                ),

                SizedBox(height: 48.h),

                Expanded(
                  child: SearchResults(
                    onBookSelected: (book) {
                      debugPrint('========== BOOK SELECTED ==========');
                      debugPrint('Selected book: ${book.title}');
                      debugPrint('Selected book ID: ${book.id}');

                      _bookToAdd = book;

                      debugPrint(
                        'Book stored in _bookToAdd: ${_bookToAdd?.title}',
                      );
                      debugPrint('====================================');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
