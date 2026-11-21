import 'package:flutter/material.dart';

import '../../../core/widgets/app_text_field.dart';

/// Teks statis halaman masuk dan daftar.
///
/// Klaim marketing ("500+ Gantangan Aktif", "Terverifikasi EO ...") masih data
/// dummy dari desain — wajib divalidasi sebelum rilis.
abstract final class AuthStrings {
  static const String help = 'Butuh Bantuan?';

  static const String loginEyebrow = 'SELAMAT DATANG KICAU MANIA';
  static const String loginTitle = 'Masuk ke Akun KicauGo';
  static const String loginDescription =
      'Kelola tiket gantangan, pantau jadwal lomba, dan nomor pesananmu '
      'dalam satu genggaman.';
  static const String chipActiveContests = '500+ Gantangan Aktif';
  static const String chipInstantTicket = 'E-Tiket Instan';
  static const String rememberMe = 'Ingat Saya';
  static const String forgotPassword = 'Lupa Kata Sandi?';
  static const String loginSubmit = 'Masuk Sekarang';
  static const String loginSocialDivider = 'atau masuk lebih cepat dengan';
  static const String loginGoogle = 'Masuk dengan Google';
  static const String noAccount = 'Belum punya akun KicauGo?';
  static const String toRegister = 'Daftar Akun Baru';

  static const String registerEyebrow = 'GABUNG KOMUNITAS KICAU MANIA';
  static const String registerTitle = 'Buat Akun KicauGo';
  static const String registerDescription =
      'Daftar sekali untuk pesan tiket gantangan, simpan riwayat lomba, '
      'dan terima e-tiket langsung di ponselmu.';
  static const String chipFreeSignUp = 'Gratis Daftar';
  static const String chipQrTicket = 'Tiket QR';
  static const String acceptTerms =
      'Saya menyetujui Syarat & Ketentuan serta Kebijakan Privasi KicauGo';
  static const String registerSubmit = 'Daftar Sekarang';
  static const String registerSocialDivider = 'atau daftar lebih cepat dengan';
  static const String registerGoogle = 'Daftar dengan Google';
  static const String haveAccount = 'Sudah punya akun?';
  static const String toLogin = 'Masuk';

  static const String trustTitle = 'JAMINAN KEAMANAN';
  static const String trustBody =
      'Tiket Resmi & Terverifikasi EO Gantangan se-Nusantara';

  static const String identifierRequired =
      'Email atau nomor WhatsApp wajib diisi';
  static const String identifierInvalid =
      'Format email atau nomor WhatsApp tidak valid';
  static const String passwordRequired = 'Kata sandi wajib diisi';
  static const String passwordTooShort = 'Kata sandi minimal 8 karakter';
  static const String nameRequired = 'Nama lengkap minimal 3 huruf';
  static const String confirmRequired = 'Ulangi kata sandi';
  static const String confirmMismatch = 'Kata sandi tidak sama';
  static const String termsRequired =
      'Setujui Syarat & Ketentuan untuk melanjutkan';
}

/// Spesifikasi field formulir masuk/daftar.
abstract final class AuthFields {
  static const AppFieldSpec name = AppFieldSpec(
    label: 'Nama Lengkap',
    hint: 'Nama sesuai identitas',
    icon: Icons.person_outline_rounded,
  );

  static const AppFieldSpec identifier = AppFieldSpec(
    label: 'Email atau Nomor WhatsApp',
    labelTrailing: 'Contoh: 0812...',
    hint: '08123456789 atau user@kicaugo.id',
    icon: Icons.contact_phone_outlined,
  );

  static const AppFieldSpec password = AppFieldSpec(
    label: 'Kata Sandi',
    hint: '••••••••',
    icon: Icons.lock_outline_rounded,
  );

  static const AppFieldSpec newPassword = AppFieldSpec(
    label: 'Kata Sandi',
    labelTrailing: 'Minimal 8 karakter',
    hint: '••••••••',
    icon: Icons.lock_outline_rounded,
  );

  static const AppFieldSpec confirmPassword = AppFieldSpec(
    label: 'Konfirmasi Kata Sandi',
    hint: 'Ketik ulang kata sandi',
    icon: Icons.lock_reset_rounded,
  );
}
