import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/features/readly/library/add_manually/business_logic/book_form_cubit.dart';
import 'package:readly/features/readly/library/add_manually/presentation/widgets/add_image.dart';
import 'package:readly/features/readly/library/add_manually/presentation/widgets/reading_status_section.dart';
import 'package:readly/features/readly/library/search_book_details_api/presentation/controllers/book_form_controllers.dart';
import 'package:readly/features/readly/library/search_book_details_api/presentation/validators/book_form_validators.dart';
import 'package:readly/features/readly/library/search_book_details_api/presentation/widgets/form_section.dart';
import 'package:readly/features/readly/library/search_book_details_api/presentation/widgets/search_details_header.dart';
import 'package:readly/features/readly/library/search_book_details_api/presentation/widgets/search_info_text_field.dart';

class AddBookManuallyScreen extends StatefulWidget {
  const AddBookManuallyScreen({super.key});

  @override
  State<AddBookManuallyScreen> createState() => _AddBookManuallyScreenState();
}

class _AddBookManuallyScreenState extends State<AddBookManuallyScreen> {
  final _formKey = GlobalKey<FormState>();

  final controllers = BookFormControllers();

  @override
  void dispose() {
    controllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookFormCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
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

                            const AddImage(),

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

                            const ReadingStatusSection(),

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

                                  final cubit = context.read<BookFormCubit>();

                                  if (!cubit.isReadingStatusSelected) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Please choose a reading status.",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  final book = cubit.createLibraryBook(
                                    title: controllers.title.text.trim(),
                                    author: controllers.author.text.trim(),
                                    publisher: controllers.publisher.text
                                        .trim(),
                                    language: controllers.language.text.trim(),
                                    description: controllers.description.text
                                        .trim(),
                                    category:
                                        '', // we'll replace this when Subjects are implemented
                                    pages: int.tryParse(
                                      controllers.pages.text.trim(),
                                    ),
                                    coverFile: cubit.state.coverImage,
                                  );

                                  

                                  context.pop(book);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.save),

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
              ),
            ),
          );
        },
      ),
    );
  }
}
