import 'package:equatable/equatable.dart';

/// Tiket aktif terdekat milik pengguna.
class ActiveTicket extends Equatable {
  const ActiveTicket({
    required this.event,
    required this.schedule,
    required this.number,
    required this.session,
  });

  final String event;
  final String schedule;
  final String number;
  final String session;

  @override
  List<Object?> get props => [event, schedule, number, session];
}
