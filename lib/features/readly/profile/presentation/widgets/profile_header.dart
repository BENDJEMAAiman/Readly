import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    this.photoUrl,
    required this.onImagePressed,
    required this.onDeletePressed,
  });

  final String name;
  final String? photoUrl;

  final VoidCallback onImagePressed;
  final VoidCallback onDeletePressed;

  bool get hasProfilePicture {
    return photoUrl != null && photoUrl!.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildProfilePicture(),

        SizedBox(height: 14.h),

        Text(
          name,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.primary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: 4.h),
      ],
    );
  }

  Widget _buildProfilePicture() {
    return SizedBox(
      width: 150.w,
      height: 150.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Profile picture
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 150.w,
              height: 150.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryLight,
                border: Border.all(color: AppColors.buttonBlue, width: 3.w),
              ),
              child: ClipOval(
                child: hasProfilePicture
                    ? Image.network(
                        photoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) {
                          return _placeholder();
                        },
                      )
                    : _placeholder(),
              ),
            ),
          ),

          // Add / Change picture button
          Positioned(
            right: 20.w,
            bottom: 3.h,
            child: _ProfileActionButton(
              icon: hasProfilePicture
                  ? Icons.edit_rounded
                  : Icons.add_a_photo_rounded,
              onTap: onImagePressed,
            ),
          ),

          // Delete button
          if (hasProfilePicture)
            Positioned(
              left: 124.w,
              top: 102.h,
              child: _DeleteButton(onTap: onDeletePressed),
            ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Icon(
      Icons.person_rounded,
      size: 60.sp,
      color: AppColors.buttonBlueDark,
    );
  }
}

class _ProfileActionButton extends StatelessWidget {
  const _ProfileActionButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.buttonBlue,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 36.w,
          height: 36.w,
          alignment: Alignment.center,
          child: Icon(icon, size: 18.sp, color: Colors.white),
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 35.w,
          height: 35.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.red.shade100),
          ),
          child: Icon(
            Icons.delete_outline_rounded,
            size: 20.sp,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}
