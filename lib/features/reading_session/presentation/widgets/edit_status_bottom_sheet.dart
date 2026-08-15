import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';

class EditStatusBottomSheet extends StatelessWidget {
  const EditStatusBottomSheet({super.key, required this.currentStatus});

  final ReadingStatus currentStatus;

  @override
  Widget build(BuildContext context) {
    final statuses = ReadingStatus.values;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
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
              'Reading status',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 6.h),

            Text(
              'Choose the current status of this book.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey500,
              ),
            ),

            SizedBox(height: 20.h),

            ...statuses.map((status) {
              final isSelected = status == currentStatus;

              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _StatusOption(
                  status: status,
                  isSelected: isSelected,
                  onTap: () {
                    Navigator.of(context).pop(status);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _StatusOption extends StatelessWidget {
  const _StatusOption({
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  final ReadingStatus status;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.secondaryLight : AppColors.grey400,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
          child: Row(
            children: [
              _buildIcon(),

              SizedBox(width: 14.w),

              Expanded(
                child: Text(
                  status.displayName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),

              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  size: 22.sp,
                  color: AppColors.buttonBlueDark,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    IconData icon;

    switch (status) {
      case ReadingStatus.wantToRead:
        icon = Icons.bookmark_outline_rounded;
        break;

      case ReadingStatus.reading:
        icon = Icons.menu_book_rounded;
        break;

      case ReadingStatus.completed:
        icon = Icons.check_circle_outline_rounded;
        break;
    }

    return Icon(icon, size: 24.sp, color: AppColors.buttonBlueDark);
  }
}
