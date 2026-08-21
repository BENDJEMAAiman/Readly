import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/features/readly/library/search_book_api/model/search_model.dart';
import 'package:readly/features/readly/library/search_book_details_api/business%20logic/search_details_cubit.dart';
import 'package:readly/features/readly/library/search_book_details_api/business%20logic/search_details_state.dart';
import 'package:readly/features/readly/library/search_book_details_api/presentation/controllers/book_form_controllers.dart';
import 'package:readly/features/readly/library/search_book_details_api/presentation/validators/book_form_validators.dart';
import 'package:readly/features/readly/library/search_book_details_api/presentation/widgets/book_cover_card.dart';
import 'package:readly/features/readly/library/search_book_details_api/presentation/widgets/form_section.dart';
import 'package:readly/features/readly/library/search_book_details_api/presentation/widgets/search_details_header.dart';
import 'package:readly/features/readly/library/search_book_details_api/presentation/widgets/search_info_text_field.dart';
import 'package:readly/features/readly/library/search_book_details_api/presentation/widgets/search_reading_status_section.dart';

class SearchDetailsScreen extends StatefulWidget {
  final SearchModel basicInfo;

  const SearchDetailsScreen({super.key, required this.basicInfo});

  @override
  State<SearchDetailsScreen> createState() => _SearchDetailsScreenState();
}

class _SearchDetailsScreenState extends State<SearchDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final controllers = BookFormControllers();

  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    context.read<SearchDetailsCubit>().getBookDetails(widget.basicInfo);
  }

  @override
  void dispose() {
    controllers.dispose();
    super.dispose();
  }

  void _fillControllers(SearchDetailsSuccess state) {
    if (_initialized) return;

    controllers.fill(state.book);

    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<SearchDetailsCubit, SearchDetailsState>(
          builder: (context, state) {
            switch (state) {
              case SearchDetailsInitial():
              case SearchDetailsLoading():
                return const Center(child: CircularProgressIndicator());

              case SearchDetailsError(:final msg):
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Text(msg, textAlign: TextAlign.center),
                  ),
                );

              case SearchDetailsSuccess():
                _fillControllers(state);

                final book = state.book;

                return Column(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SearchDetailsHeader(),
                              SizedBox(height: 32.h),

                              Center(
                                child: BookCoverCard(coverId: book.coverId),
                              ),

                              SizedBox(height: 32.h),

                              FormSection(
                                title: 'Basic Information',
                                child: Column(
                                  children: [
                                    SearchInfoTextField(
                                      label: "Book Title",
                                      hint: "Enter title",
                                      controller: controllers.title,
                                      validator: BookFormValidators.title,
                                    ),

                                    SizedBox(height: 18.h),

                                    SearchInfoTextField(
                                      label: 'Author',
                                      hint: 'Enter author',
                                      controller: controllers.author,
                                    ),
                                  ],
                                ),
                              ),

                              FormSection(
                                title: 'Publication Details',
                                child: Column(
                                  children: [
                                    SearchInfoTextField(
                                      label: 'Publisher',
                                      hint: 'Enter publisher',
                                      controller: controllers.publisher,
                                    ),

                                    SizedBox(height: 18.h),

                                    SearchInfoTextField(
                                      label: 'Language',
                                      hint: 'Enter language',
                                      controller: controllers.language,
                                    ),

                                    SizedBox(height: 18.h),

                                    SearchInfoTextField(
                                      label: "Pages",
                                      hint: "Enter number of pages",
                                      controller: controllers.pages,
                                      keyboardType: TextInputType.number,
                                      validator: BookFormValidators.pages,
                                    ),
                                  ],
                                ),
                              ),

                              FormSection(
                                title: 'Description',
                                child: SearchInfoTextField(
                                  label: 'Book Description',
                                  hint: 'Enter description',
                                  controller: controllers.description,
                                  maxLines: 6,
                                ),
                              ),

                              const SearchReadingStatusSection(),

                              if (book.subjects != null &&
                                  book.subjects!.isNotEmpty)
                                FormSection(
                                  title: 'Subjects',
                                  child: Wrap(
                                    spacing: 10.w,
                                    runSpacing: 10.h,
                                    children: book.subjects!
                                        .map(
                                          (subject) => Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 14.w,
                                              vertical: 8.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.secondaryLight2,
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                              border: Border.all(
                                                color: AppColors.secondaryLight,
                                              ),
                                            ),
                                            child: Text(subject),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),

                              SizedBox(height: 12.h),

                              SizedBox(
                                width: double.infinity,
                                height: 54.h,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.buttonBlueDark,
                                    foregroundColor: AppColors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }

                                    final cubit = context
                                        .read<SearchDetailsCubit>();

                                    if (!cubit.isReadingStatusSelected) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Please choose a reading status.',
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    final updatedBook = book.copyWith(
                                      title: controllers.title.text.trim(),
                                      author: controllers.author.text.trim(),
                                      publisher: controllers.publisher.text
                                          .trim(),
                                      language: controllers.language.text
                                          .trim(),
                                      description: controllers.description.text
                                          .trim(),
                                      numberOfPages: int.tryParse(
                                        controllers.pages.text.trim(),
                                      ),
                                    );

                                    debugPrint("ready to save the book");

                                    context.pop(updatedBook.toLibraryBook(
                                      readingStatus: cubit.selectedReadingStatus,
                                    ));

                                    debugPrint("pop out - book");
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.save),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Save Book',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 32.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
