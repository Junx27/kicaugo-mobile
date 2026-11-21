import 'package:equatable/equatable.dart';

/// Pengguna yang berhasil masuk.
class User extends Equatable {
  const User({required this.name, required this.identifier, this.token = ''});

  final String name;

  /// Email atau nomor WhatsApp yang dipakai untuk masuk.
  final String identifier;

  /// Token Bearer dari backend. Kosong bila masih memakai data dummy.
  final String token;

  @override
  List<Object?> get props => [name, identifier, token];
}
