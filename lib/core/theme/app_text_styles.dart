import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Skala tipografi KicauKu.
///
/// Heading memakai Plus Jakarta Sans, body memakai Inter. Ukuran dan berat
/// font hanya didefinisikan di sini agar widget tidak menulis angka sendiri.
abstract final class AppTextStyles {
  static const String headingFontFamily = 'PlusJakartaSans';
  static const String bodyFontFamily = 'Inter';

  /// Judul halaman: 24 / Bold.
  static final TextStyle pageTitle = GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Judul section: 18 / SemiBold.
  static final TextStyle sectionTitle = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Judul kartu: 16 / SemiBold.
  static final TextStyle cardTitle = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Teks isi: 14 / Regular.
  static final TextStyle body = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// Teks bantuan: 12 / Regular.
  static final TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  /// Label tombol: Plus Jakarta Sans 14 / Bold.
  ///
  /// Warna sengaja tidak diatur di sini karena ditentukan oleh
  /// `foregroundColor` masing-masing varian tombol.
  static final TextStyle button = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.14,
    height: 1.3,
  );

  /// Judul display (nama aplikasi): 32 / ExtraBold, tracking -0.03em.
  static final TextStyle display = GoogleFonts.plusJakartaSans(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.96,
    height: 1.25,
  );

  /// Judul besar halaman mobile: 26 / ExtraBold, tracking -0.02em.
  static final TextStyle headline = GoogleFonts.plusJakartaSans(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.52,
    height: 1.23,
  );

  /// Judul sedang: 22 / ExtraBold, tracking -0.015em.
  static final TextStyle headlineSmall = GoogleFonts.plusJakartaSans(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.33,
    height: 1.3,
  );

  /// Judul tebal: 18 / Bold, tracking -0.01em.
  static final TextStyle title = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.18,
    height: 1.33,
  );

  /// Label kecil: 12 / Bold, tracking 0.02em.
  static final TextStyle label = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
    letterSpacing: 0.24,
    height: 1.33,
  );

  /// Eyebrow/huruf kapital mini: 10 / Bold, tracking lebar.
  static final TextStyle eyebrow = GoogleFonts.plusJakartaSans(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
    height: 1.4,
  );

  /// Label chip kategori: 10 / Regular.
  static final TextStyle chipLabel = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );
}
