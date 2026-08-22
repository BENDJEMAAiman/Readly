import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class ReadingGoalBottomSheet extends StatefulWidget {
  const ReadingGoalBottomSheet({
    super.key,
    required this.initialPages,
    required this.initialMinutes,
    required this.isLoading,
    required this.onSave,
  });

  final int initialPages;
  final int initialMinutes;
  final bool isLoading;

  final void Function({required int pages, required int minutes}) onSave;

  @override
  State<ReadingGoalBottomSheet> createState() => _ReadingGoalBottomSheetState();
}

class _ReadingGoalBottomSheetState extends State<ReadingGoalBottomSheet> {
  late int pages;
  late int hours;
  late int minutes;

  @override
  void initState() {
    super.initState();

    pages = widget.initialPages;

    hours = widget.initialMinutes ~/ 60;

    minutes = widget.initialMinutes % 60;
  }

  int get totalMinutes {
    return (hours * 60) + minutes;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Set your daily goal',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 5.h),

            Text(
              'Pick a daily target to stay on track',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryLight,
                height: 1.5,
              ),
            ),

            SizedBox(height: 24.h),

            Row(
              children: [
                Expanded(
                  child: _FigmaGoalPicker(
                    label: 'Pages',
                    value: pages,
                    values: List.generate(101, (index) => index),
                    displayValue: (value) => value.toString(),
                    onChanged: (value) {
                      setState(() {
                        pages = value;
                      });
                    },
                  ),
                ),

                SizedBox(width: 16.w),

                Expanded(
                  child: _FigmaGoalPicker(
                    label: 'Hours',
                    value: hours,
                    values: List.generate(24, (index) => index),
                    displayValue: (value) => value.toString().padLeft(2, '0'),
                    onChanged: (value) {
                      setState(() {
                        hours = value;
                      });
                    },
                  ),
                ),

                SizedBox(width: 16.w),

                Expanded(
                  child: _FigmaGoalPicker(
                    label: 'Minutes',
                    value: minutes,
                    values: List.generate(60, (index) => index),
                    displayValue: (value) => value.toString().padLeft(2, '0'),
                    onChanged: (value) {
                      setState(() {
                        minutes = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 30.h),

            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: widget.isLoading
                    ? null
                    : () {
                        if (pages == 0 && totalMinutes == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please set at least one reading goal.',
                              ),
                            ),
                          );

                          return;
                        }

                        widget.onSave(pages: pages, minutes: totalMinutes);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBlueDark,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: widget.isLoading
                    ? SizedBox(
                        width: 22.w,
                        height: 22.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : Text(
                        'Save Changes',
                        style: AppTextStyles.bodyMedium.copyWith(
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

class _FigmaGoalPicker extends StatelessWidget {
  const _FigmaGoalPicker({
    required this.label,
    required this.value,
    required this.values,
    required this.displayValue,
    required this.onChanged,
  });

  final String label;
  final int value;
  final List<int> values;
  final String Function(int value) displayValue;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primaryLight,
            fontSize: 12.sp,
          ),
        ),

        SizedBox(height: 6.h),

        SizedBox(
          height: 44.h,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              isExpanded: true,
              alignment: Alignment.center,
              icon: const SizedBox.shrink(),

              items: values.map((item) {
                return DropdownMenuItem<int>(
                  value: item,
                  alignment: Alignment.center,
                  child: Text(
                    displayValue(item),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontSize: 13.sp,
                    ),
                  ),
                );
              }).toList(),

              onChanged: (newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),

        Container(
          width: 30.w,
          height: 3.h,
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ],
    );
  }
}
