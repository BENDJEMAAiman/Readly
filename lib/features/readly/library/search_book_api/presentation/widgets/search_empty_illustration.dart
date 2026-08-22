import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/constants/app_assets.dart';

class SearchEmptyIllustration extends StatelessWidget {
  const SearchEmptyIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 0.5,
        child: Image.asset(
          AppAssets.congratulation,
          width: 137.w,
          height: 158.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
