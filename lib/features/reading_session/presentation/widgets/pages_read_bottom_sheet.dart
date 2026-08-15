import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class PagesReadBottomSheet extends StatefulWidget {
  const PagesReadBottomSheet({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  final int currentPage;
  final int totalPages;

  @override
  State<PagesReadBottomSheet> createState() => _PagesReadBottomSheetState();
}

class _PagesReadBottomSheetState extends State<PagesReadBottomSheet> {
  late final TextEditingController _pagesController;

  @override
  void initState() {
    super.initState();
    _pagesController = TextEditingController();
  }

  @override
  void dispose() {
    _pagesController.dispose();
    super.dispose();
  }

  void _save() {
    final value = int.tryParse(
      _pagesController.text.trim(),
    );

    if (value == null) {
      _showError('Please enter the number of pages you read.');
      return;
    }

    if (value < 0) {
      _showError('Pages read cannot be negative.');
      return;
    }

    if (widget.currentPage + value > widget.totalPages) {
      _showError(
        'You cannot read more than ${widget.totalPages - widget.currentPage} '
        'remaining pages.',
      );
      return;
    }

    Navigator.of(context).pop(value);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  final remainingPages = widget.totalPages - widget.currentPage;
  final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

  return SafeArea(
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        20.w,
        12.h,
        20.w,
        20.h + keyboardHeight,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.grey400,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),

          SizedBox(height: 24.h),

          Text(
            'Pages read',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 6.h),

          Text(
            '$remainingPages pages remaining',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey500,
            ),
          ),

          SizedBox(height: 20.h),

          TextField(
            controller: _pagesController,
            autofocus: true,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'How many pages did you read?',
              filled: true,
              fillColor: AppColors.grey500,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
            onSubmitted: (_) => _save(),
          ),

          SizedBox(height: 16.h),

          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonBlueDark,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Text(
                'Save',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}