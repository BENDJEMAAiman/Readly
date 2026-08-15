import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        child: Container(
          width: 112.w,
          height: 112.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.35),
          ),
          padding: EdgeInsets.all(10.w),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF7FAEDB),
            ),
            child: Center(
              child: Icon(
                isActive
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                size: 48.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}