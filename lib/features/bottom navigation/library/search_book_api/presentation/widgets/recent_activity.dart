import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/bottom%20navigation/library/search_book_api/presentation/widgets/recent_book_tile.dart';

class RecentActivity extends StatelessWidget {
  final VoidCallback? onSeeAll;

  const RecentActivity({
    super.key,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    // Temporary dummy data.
    // Later this will come from Firestore or local storage.
    final recentBooks = [
      (
        title: 'Atomic Habits',
        author: 'James Clear',
        cover: 'https://covers.openlibrary.org/b/id/10521270-M.jpg',
      ),
      (
        title: 'Deep Work',
        author: 'Cal Newport',
        cover: 'https://covers.openlibrary.org/b/id/8370221-M.jpg',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: AppTextStyles.bodyPrimary,
        ),

        SizedBox(height: 12.h),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentBooks.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final book = recentBooks[index];

            return RecentBookTile(
              title: book.title,
              author: book.author,
              imageUrl: book.cover,
              onTap: () {},
            );
          },
        ),
      ],
    );
  }
}