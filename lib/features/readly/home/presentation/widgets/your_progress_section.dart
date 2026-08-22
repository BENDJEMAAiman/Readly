import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/readly/home/business_logic/home_progress_cubit.dart';
import 'package:readly/features/readly/home/business_logic/home_progress_state.dart';
import 'package:readly/features/readly/home/presentation/widgets/progress_card.dart';

class YourProgressSection extends StatelessWidget {
  const YourProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeProgressCubit, HomeProgressState>(
      builder: (context, state) {
        if (state is HomeProgressLoaded) {
          return _buildProgressContent(
            libraryBooksCount: state.libraryBooksCount,
            finishedBooksCount: state.finishedBooksCount,
            notesCount: state.notesCount,
            readingMinutes: state.readingMinutes,
          );
        }

        if (state is HomeProgressLoading) {
          return _buildProgressContent(
            libraryBooksCount: 0,
            finishedBooksCount: 0,
            notesCount: 0,
            readingMinutes: 0,
          );
        }

        if (state is HomeProgressError) {
          return _buildProgressContent(
            libraryBooksCount: 0,
            finishedBooksCount: 0,
            notesCount: 0,
            readingMinutes: 0,
          );
        }

        return _buildProgressContent(
          libraryBooksCount: 0,
          finishedBooksCount: 0,
          notesCount: 0,
          readingMinutes: 0,
        );
      },
    );
  }

  Widget _buildProgressContent({
    required int libraryBooksCount,
    required int finishedBooksCount,
    required int notesCount,
    required int readingMinutes,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your progress',
          style: AppTextStyles.headingLarge.copyWith(fontSize: 22.sp),
        ),

        SizedBox(height: 16.h),

        Row(
          children: [
            Expanded(
              child: ProgressCard(
                icon: Icons.menu_book_outlined,
                value: libraryBooksCount.toString(),
                label: 'My Library',
              ),
            ),

            SizedBox(width: 10.w),

            Expanded(
              child: ProgressCard(
                icon: Icons.check_rounded,
                value: finishedBooksCount.toString(),
                label: 'Finished books',
              ),
            ),
          ],
        ),

        SizedBox(height: 10.h),

        Row(
          children: [
            Expanded(
              child: ProgressCard(
                icon: Icons.edit_document,
                value: notesCount.toString(),
                label: 'Notes written',
              ),
            ),

            SizedBox(width: 10.w),

            Expanded(
              child: ProgressCard(
                icon: Icons.timer_outlined,
                value: '$readingMinutes min',
                label: 'Read today',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
