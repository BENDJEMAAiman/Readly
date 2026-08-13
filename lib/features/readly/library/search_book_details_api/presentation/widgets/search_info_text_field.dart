import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readly/core/theme/app_colors.dart';
import 'package:readly/core/theme/app_text_styles.dart';

class SearchInfoTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool requiredField;

  const SearchInfoTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.requiredField = false,
  });

  @override
  State<SearchInfoTextField> createState() => _SearchInfoTextFieldState();
}

class _SearchInfoTextFieldState extends State<SearchInfoTextField> {
  late FocusNode _focusNode;

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.labelSemiBold),

        SizedBox(height: 8.h),

        AnimatedContainer(
          duration: const Duration(milliseconds: 180),

          decoration: BoxDecoration(
            color: AppColors.white,

            borderRadius: BorderRadius.circular(12.r),

            border: Border.all(
              color: _isFocused ? AppColors.secondary : AppColors.grey400,
              width: 1.2,
            ),
          ),

          child: TextFormField(
            validator: widget.validator,
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,

            style: AppTextStyles.inputText,

            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.hintText,

              border: InputBorder.none,

              isDense: true,

              contentPadding: EdgeInsets.symmetric(
                horizontal: 18.w,
                vertical: 17.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
