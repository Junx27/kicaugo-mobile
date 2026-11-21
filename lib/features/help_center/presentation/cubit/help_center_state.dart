import 'package:equatable/equatable.dart';

import '../../domain/entities/help_center_content.dart';

/// Status pemuatan halaman Pusat Bantuan.
enum HelpCenterStatus { initial, loading, success, failure }

/// State yang dibaca halaman Pusat Bantuan.
class HelpCenterState extends Equatable {
  const HelpCenterState({
    this.status = HelpCenterStatus.initial,
    this.content,
    this.message,
    this.query = '',
    this.expandedFaqId,
  });

  final HelpCenterStatus status;
  final HelpCenterContent? content;
  final String? message;

  /// Kata kunci pencarian FAQ.
  final String query;

  /// ID FAQ yang sedang terbuka; `null` berarti semua tertutup.
  final String? expandedFaqId;

  /// FAQ yang lolos filter pencarian saat ini.
  List<HelpFaq> get visibleFaqs {
    final all = content?.faqs ?? const <HelpFaq>[];
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return all;
    }
    return all
        .where(
          (faq) =>
              faq.question.toLowerCase().contains(normalized) ||
              faq.answer.toLowerCase().contains(normalized),
        )
        .toList(growable: false);
  }

  HelpCenterState copyWith({
    HelpCenterStatus? status,
    HelpCenterContent? content,
    String? message,
    String? query,
    String? expandedFaqId,
    bool clearExpandedFaq = false,
  }) {
    return HelpCenterState(
      status: status ?? this.status,
      content: content ?? this.content,
      message: message ?? this.message,
      query: query ?? this.query,
      expandedFaqId: clearExpandedFaq
          ? null
          : (expandedFaqId ?? this.expandedFaqId),
    );
  }

  @override
  List<Object?> get props => [status, content, message, query, expandedFaqId];
}
