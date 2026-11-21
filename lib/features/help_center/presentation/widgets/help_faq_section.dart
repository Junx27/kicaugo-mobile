import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/help_center_content.dart';
import '../help_center_strings.dart';

/// Daftar FAQ accordion dengan state buka/tutup dari Cubit.
class HelpFaqSection extends StatelessWidget {
  const HelpFaqSection({
    super.key,
    required this.faqs,
    required this.expandedFaqId,
    required this.onToggle,
  });

  final List<HelpFaq> faqs;
  final String? expandedFaqId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        Row(
          spacing: 8,
          children: [
            const Icon(Icons.help_rounded, size: 20, color: AppColors.primary),
            Expanded(
              child: Text(
                HelpCenterStrings.faqTitle,
                style: AppTextStyles.title,
              ),
            ),
            Text(
              HelpCenterStrings.faqTopicCount(faqs.length),
              style: AppTextStyles.caption,
            ),
          ],
        ),
        if (faqs.isEmpty)
          Container(
            key: const Key('help_faq_empty'),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            ),
            child: Text(
              HelpCenterStrings.noResult,
              style: AppTextStyles.caption,
            ),
          )
        else
          for (var index = 0; index < faqs.length; index++)
            _FaqTile(
              faq: faqs[index],
              number: index + 1,
              isExpanded: faqs[index].id == expandedFaqId,
              onTap: () => onToggle(faqs[index].id),
            ),
      ],
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({
    required this.faq,
    required this.number,
    required this.isExpanded,
    required this.onTap,
  });

  final HelpFaq faq;
  final int number;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        boxShadow: AppTheme.softShadow,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          key: Key('help_faq_${faq.id}'),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.lavender,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$number',
                        style: AppTextStyles.eyebrow.copyWith(
                          color: AppColors.primary,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        faq.question,
                        style: AppTextStyles.label.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.expand_more_rounded,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (isExpanded)
                  Container(
                    key: Key('help_faq_answer_${faq.id}'),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLavender,
                      borderRadius: BorderRadius.circular(
                        AppTheme.iconBoxRadius,
                      ),
                    ),
                    child: Text(
                      faq.answer,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
