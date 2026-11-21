import 'package:equatable/equatable.dart';

/// Satu pilihan jawaban polling beserta jumlah suara awal.
class PollOption extends Equatable {
  const PollOption({required this.label, required this.votes});

  final String label;
  final int votes;

  @override
  List<Object?> get props => [label, votes];
}

/// Polling singkat komunitas.
class CommunityPoll extends Equatable {
  const CommunityPoll({
    required this.question,
    required this.closesIn,
    required this.options,
  });

  final String question;

  /// Sisa waktu polling (mis. "18 jam lagi").
  final String closesIn;
  final List<PollOption> options;

  @override
  List<Object?> get props => [question, closesIn, options];
}
