import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_text_styles.dart';
import 'package:readly/features/bottom%20navigation/library/library/presentation/book_view/widgets/genre_chip.dart';

class GenresSection extends StatelessWidget {
  final List<String> genres;

  const GenresSection({
    super.key,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    if (genres.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Genres",
          style: AppTextStyles.bodyPrimary.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: 16.h),

        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: genres
              .map(
                (genre) => GenreChip(
                  genre: genre,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}