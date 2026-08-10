import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class AboutBookSection extends StatefulWidget {
  final String description;

  const AboutBookSection({
    super.key,
    required this.description,
  });

  @override
  State<AboutBookSection> createState() => _AboutBookSectionState();
}

class _AboutBookSectionState extends State<AboutBookSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: widget.description,
          style: AppTextStyles.bodyLarge,
        );

        final textPainter = TextPainter(
          text: textSpan,
          maxLines: _expanded ? null : 4,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout(maxWidth: constraints.maxWidth);

        final overflow = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About this book",
              style: AppTextStyles.bodyPrimary.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 12.h),

            RichText(
              text: TextSpan(
                style: AppTextStyles.bodyLarge,
                children: [
                  TextSpan(
                    text: widget.description,
                  ),
                  if (overflow)
                    TextSpan(
                      text: _expanded
                          ? " Show less"
                          : " Show more",
                      style: AppTextStyles.bodyPrimary.copyWith(
                        color: AppColors.secondary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(() {
                            _expanded = !_expanded;
                          });
                        },
                    ),
                ],
              ),
              maxLines: _expanded ? null : 4,
              overflow:
                  _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }
}