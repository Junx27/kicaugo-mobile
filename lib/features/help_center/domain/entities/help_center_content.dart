import 'package:equatable/equatable.dart';

/// Jenis aksi cepat; presentasi memetakan ke ikon dan warna.
enum HelpActionKind { chat, refund, appeal, payment }

/// Jenis kontak panitia; presentasi memetakan ke ikon.
enum HelpContactKind { coordinator, medical, secretariat }

/// Aksi cepat di bagian "Bantuan Instan Kicaumania".
class HelpQuickAction extends Equatable {
  const HelpQuickAction({
    required this.id,
    required this.kind,
    required this.title,
    required this.description,
    required this.badge,
    required this.ctaLabel,
  });

  final String id;
  final HelpActionKind kind;
  final String title;
  final String description;
  final String badge;
  final String ctaLabel;

  @override
  List<Object?> get props => [id, kind, title, description, badge, ctaLabel];
}

/// Kontak panitia lapangan.
class HelpContact extends Equatable {
  const HelpContact({
    required this.id,
    required this.kind,
    required this.name,
    required this.role,
    required this.actionLabel,
  });

  final String id;
  final HelpContactKind kind;
  final String name;
  final String role;
  final String actionLabel;

  @override
  List<Object?> get props => [id, kind, name, role, actionLabel];
}

/// Informasi event yang sedang/akan berlangsung.
class HelpEventInfo extends Equatable {
  const HelpEventInfo({
    required this.title,
    required this.venue,
    required this.fieldHours,
    required this.registrationLabel,
  });

  final String title;
  final String venue;
  final String fieldHours;
  final String registrationLabel;

  @override
  List<Object?> get props => [title, venue, fieldHours, registrationLabel];
}

/// Satu pertanyaan pada accordion FAQ.
class HelpFaq extends Equatable {
  const HelpFaq({
    required this.id,
    required this.question,
    required this.answer,
  });

  final String id;
  final String question;
  final String answer;

  @override
  List<Object?> get props => [id, question, answer];
}

/// Seluruh data halaman Pusat Bantuan.
class HelpCenterContent extends Equatable {
  const HelpCenterContent({
    required this.event,
    required this.quickActions,
    required this.contacts,
    required this.faqs,
  });

  final HelpEventInfo event;
  final List<HelpQuickAction> quickActions;
  final List<HelpContact> contacts;
  final List<HelpFaq> faqs;

  @override
  List<Object?> get props => [event, quickActions, contacts, faqs];
}
