import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/constants/app_assets.dart';

class ReadlyBottomNavigation extends StatelessWidget {
  const ReadlyBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.h,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavigationItem(
              index: 0,
              selectedAsset: AppAssets.homeBlue,
              unselectedAsset: AppAssets.homeGrey,
              label: 'Home',
            ),
            _buildNavigationItem(
              index: 1,
              selectedAsset: AppAssets.libraryBlue,
              unselectedAsset: AppAssets.libraryGrey,
              label: 'Library',
            ),
            _buildNavigationItem(
              index: 2,
              selectedAsset: AppAssets.notesBlue,
              unselectedAsset: AppAssets.notesGrey,
              label: 'Notes',
            ),
            _buildNavigationItem(
              index: 3,
              selectedAsset: AppAssets.profileBlue,
              unselectedAsset: AppAssets.profileGrey,
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required int index,
    required String selectedAsset,
    required String unselectedAsset,
    required String label,
  }) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => onItemTapped(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              isSelected ? selectedAsset : unselectedAsset,
              width: 22.w,
              height: 22.h,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: isSelected
                    ? const Color(0xFF4A9BD1)
                    : const Color(0xFFB8BEC5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}