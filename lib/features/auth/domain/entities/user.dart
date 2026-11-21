import 'package:equatable/equatable.dart';

/// Pengguna yang berhasil masuk.
class User extends Equatable {
  const User({required this.name, required this.identifier});

  final String name;

  /// Email atau nomor WhatsApp yang dipakai untuk masuk.
  final String identifier;

  @override
  List<Object?> get props => [name, identifier];
}
