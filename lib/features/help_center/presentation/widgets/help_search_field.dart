import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../help_center_strings.dart';

/// Kolom pencarian FAQ dengan aksi filter.
class HelpSearchField extends StatefulWidget {
  const HelpSearchField({
    super.key,
    required this.onChanged,
    this.initialQuery = '',
  });

  final ValueChanged<String> onChanged;
  final String initialQuery;

  @override
  State<HelpSearchField> createState() => _HelpSearchFieldState();
}

class _HelpSearchFieldState extends State<HelpSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        spacing: 8,
        children: [
          const Icon(Icons.search_rounded, size: 22, color: AppColors.primary),
          Expanded(
            child: TextField(
              key: const Key('help_search_input'),
              controller: _controller,
              onChanged: widget.onChanged,
              textInputAction: TextInputAction.search,
              style: AppTextStyles.body,
              decoration: InputDecoration(
                isDense: true,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: HelpCenterStrings.searchHint,
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          IconButton(
            key: const Key('help_filter'),
            tooltip: HelpCenterStrings.searchFilterTooltip,
            onPressed: () => showComingSoon(context),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surfaceLavender,
              foregroundColor: AppColors.textSecondary,
              minimumSize: const Size(36, 36),
              padding: EdgeInsets.zero,
            ),
            icon: const Icon(Icons.tune_rounded, size: 18),
          ),
        ],
      ),
    );
  }
}
