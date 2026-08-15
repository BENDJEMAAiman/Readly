import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class EditTimerBottomSheet extends StatefulWidget {
  const EditTimerBottomSheet({
    super.key,
    required this.initialDuration,
  });

  final Duration initialDuration;

  @override
  State<EditTimerBottomSheet> createState() => _EditTimerBottomSheetState();
}

class _EditTimerBottomSheetState extends State<EditTimerBottomSheet> {
  late final TextEditingController _hoursController;
  late final TextEditingController _minutesController;
  late final TextEditingController _secondsController;

  @override
  void initState() {
    super.initState();

    _hoursController = TextEditingController(
      text: widget.initialDuration.inHours
          .toString()
          .padLeft(2, '0'),
    );

    _minutesController = TextEditingController(
      text: (widget.initialDuration.inMinutes % 60)
          .toString()
          .padLeft(2, '0'),
    );

    _secondsController = TextEditingController(
      text: (widget.initialDuration.inSeconds % 60)
          .toString()
          .padLeft(2, '0'),
    );
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();

    super.dispose();
  }

  void _save() {
    final hours = int.tryParse(_hoursController.text);
    final minutes = int.tryParse(_minutesController.text);
    final seconds = int.tryParse(_secondsController.text);

    if (hours == null || minutes == null || seconds == null) {
      _showError('Please enter a valid time.');
      return;
    }

    if (hours < 0) {
      _showError('Hours cannot be negative.');
      return;
    }

    if (minutes < 0 || minutes > 59) {
      _showError('Minutes must be between 0 and 59.');
      return;
    }

    if (seconds < 0 || seconds > 59) {
      _showError('Seconds must be between 0 and 59.');
      return;
    }

    final duration = Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );

    if (duration.inSeconds <= 0) {
      _showError('Reading time must be greater than zero.');
      return;
    }

    Navigator.of(context).pop(duration);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20.w,
          12.h,
          20.w,
          20.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 42.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.grey400,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),

            SizedBox(height: 24.h),

            Text(
              'Time of reading',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 6.h),

            Text(
              'Adjust the amount of time you spent reading.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey500,
              ),
            ),

            SizedBox(height: 24.h),

            Row(
              children: [
                Expanded(
                  child: _TimeInput(
                    controller: _hoursController,
                    label: 'Hours',
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    ':',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ),

                Expanded(
                  child: _TimeInput(
                    controller: _minutesController,
                    label: 'Minutes',
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    ':',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ),

                Expanded(
                  child: _TimeInput(
                    controller: _secondsController,
                    label: 'Seconds',
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBlueDark,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  'Save',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeInput extends StatelessWidget {
  const _TimeInput({
    required this.controller,
    required this.label,
  });

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.grey500,
          ),
        ),

        SizedBox(height: 6.h),

        TextField(
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.grey400,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 16.h,
            ),
          ),
        ),
      ],
    );
  }
}