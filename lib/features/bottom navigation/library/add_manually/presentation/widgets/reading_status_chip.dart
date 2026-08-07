import 'package:flutter/material.dart';
import 'package:readly/core/theme/app_colors.dart';

class ReadingStatusChip extends StatelessWidget {
  const ReadingStatusChip({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      avatar: Icon(
        icon,
        size: 18,
        color: selected
            ? Colors.white
            : AppColors.secondary,
      ),
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: AppColors.buttonBlueDark,
      labelStyle: TextStyle(
        color: selected
            ? Colors.white
            : AppColors.secondary,
      ),
      shape: StadiumBorder(
        side: BorderSide(
          color: selected
              ? AppColors.buttonBlueDark
              : AppColors.border,
        ),
      ),
    );
  }
}