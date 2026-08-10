import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/routing/routes.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/features/bottom%20navigation/library/library/model/library_book.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/presentation/widgets/add_manually_button.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/presentation/widgets/search_header.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/presentation/widgets/search_results.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/presentation/widgets/search_text_field.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchHeader(
                onBack: () {
                  debugPrint('Returning to Library: ${_bookToAdd?.title}');
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
                    _bookToAdd = book;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
