import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';

class SessionControlButton extends StatelessWidget {
  const SessionControlButton({
    super.key,
    required this.isActive,
    required this.onPressed,
  });

  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          width: 112.w,
          height: 112.w,
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? Colors.white.withValues(alpha: 0.35)
                : const Color(0xFFA4C3E4).withValues(alpha: 0.99),
            border: Border.all(
              color: isActive
                  ? Colors.transparent
                  : const Color(0xFFA4C3E4),
              width: 1,
            ),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                
                ? AppColors.background
                : Color(0xFF7FAEDB),
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  );
                },
                child: Icon(
                  isActive ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  key: ValueKey(isActive),
                  size: 48.sp,
                  color: isActive
                    ? Color(0xFF7FAEDB)
                    :Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
