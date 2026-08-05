import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/features/bottom%20navigation/library/add_manually/presentation/pages/add_book_manually_screen.dart';
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
              SearchHeader(),
              SizedBox(height: 32.h),
              SearchTextField(controller: titleController, formKey: _formKey),
              SizedBox(height: 24.h),

              AddManuallyButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddBookManuallyScreen(),
                    ),
                  );
                },
              ),

              SizedBox(height: 48.h),

              const Expanded(child: SearchResults()),
            ],
          ),
        ),
      ),
    );
  }
}
