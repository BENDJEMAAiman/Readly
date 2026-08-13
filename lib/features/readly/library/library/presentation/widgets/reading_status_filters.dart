import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/readly/library/library/model/library_book.dart';

class LibraryStatusFilter extends StatelessWidget {
  const LibraryStatusFilter({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  final ReadingStatus? selectedStatus;
  final ValueChanged<ReadingStatus?> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            _StatusChip(
              label: 'All',
              selected: selectedStatus == null,
              onTap: () => onStatusChanged(null),
            ),

            SizedBox(width: 8.w),

            _StatusChip(
              label: 'Reading',
              selected: selectedStatus == ReadingStatus.reading,
              onTap: () => onStatusChanged(ReadingStatus.reading),
            ),

            SizedBox(width: 8.w),

            _StatusChip(
              label: 'Completed',
              selected: selectedStatus == ReadingStatus.completed,
              onTap: () => onStatusChanged(ReadingStatus.completed),
            ),

            SizedBox(width: 8.w),

            _StatusChip(
              label: 'Want to Read',
              selected: selectedStatus == ReadingStatus.wantToRead,
              onTap: () => onStatusChanged(ReadingStatus.wantToRead),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 38.h,
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.buttonBlueDark
              : AppColors.white,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: selected
                ? AppColors.buttonBlueDark
                : AppColors.border,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            fontSize: 12.sp,
            color: selected
                ? AppColors.white
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}