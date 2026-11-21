import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Kotak centang dengan label yang ikut bisa diketuk, plus pesan galat opsional.
class CheckLabel extends StatelessWidget {
  const CheckLabel({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
    this.errorText,
  });

  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;
  final String? errorText;

  static const double _boxSize = 20;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        InkWell(
          onTap: () => onChanged(!value),
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              SizedBox.square(
                dimension: _boxSize,
                child: Checkbox(
                  value: value,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  onChanged: (checked) => onChanged(checked ?? false),
                ),
              ),
              Flexible(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: value
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null)
          Text(
            errorText!,
            style: AppTextStyles.caption.copyWith(color: AppColors.error),
          ),
      ],
    );
  }
}
