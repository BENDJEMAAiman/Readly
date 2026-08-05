import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/constants/app_assets.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_details_api/presentation/widgets/book_info_tile.dart';

class BookInfoGrid extends StatelessWidget {
  final String pages;
  final String language;
  final String publisher;

  const BookInfoGrid({
    super.key,
    required this.pages,
    required this.language,
    required this.publisher,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: BookInfoTile(
                label: "Pages",
                value: pages,
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: BookInfoTile(
                label: "Language",
                value: language,
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BookInfoTile(
                label: "Publisher",
                value: publisher,
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Container(
                height: 110.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Image.asset(
                    AppAssets.congratulation,
                    width: 64.w,
                    height: 64.h,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}