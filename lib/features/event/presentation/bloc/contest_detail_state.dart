import 'package:equatable/equatable.dart';

import '../../domain/entities/contest_detail.dart';

/// Status state detail lomba.
enum ContestDetailStatus { initial, loading, success, failure }

/// State detail lomba.
class ContestDetailState extends Equatable {
  const ContestDetailState({
    this.status = ContestDetailStatus.initial,
    this.detail,
    this.message,
  });

  final ContestDetailStatus status;
  final ContestDetail? detail;
  final String? message;

  @override
  List<Object?> get props => [status, detail, message];
}
