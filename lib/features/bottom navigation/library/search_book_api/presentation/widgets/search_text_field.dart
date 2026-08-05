import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/business_logic/search_cubit.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    required this.controller,
    required this.formKey,
  });

  final TextEditingController controller;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SizedBox(
        height: 55.h,
        child: TextFormField(
          controller: controller,
          textInputAction: TextInputAction.search,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: AppTextStyles.bodyLarge,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter a book title.";
            }

            if (value.trim().length < 3) {
              return "Search must contain at least 3 characters.";
            }

            return null;
          },
          onFieldSubmitted: (_) {
            if (!formKey.currentState!.validate()) return;

            FocusScope.of(context).unfocus();

            context.read<SearchCubit>().searchBooks(
                  controller.text.trim(),
                );
          },
          decoration: InputDecoration(
            hintText: "Search online...",
            hintStyle: AppTextStyles.hintText,

            prefixIcon: Icon(
              Icons.search,
              color: AppColors.grey500,
              size: 22.sp,
            ),

            filled: true,
            fillColor: AppColors.white,

            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 16.h,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.r),
              borderSide: BorderSide(
                color: AppColors.grey400,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.r),
              borderSide: BorderSide(
                color: AppColors.secondary,
                width: 1.5,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.r),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28.r),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}