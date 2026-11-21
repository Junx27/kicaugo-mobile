import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Design token dan [ThemeData] utama KicauKu (Material 3).
///
/// Semua radius, tinggi komponen, padding halaman, dan gaya komponen
/// didefinisikan di sini agar widget hanya memakai nilai dari tema.
abstract final class AppTheme {
  /// Input berisi lavender dengan sudut lembut.
  static const double inputRadius = 16;

  /// Tombol berbentuk pill penuh.
  static const double buttonRadius = pillRadius;
  static const double cardRadius = 16;
  static const double buttonHeight = 52;
  static const double pagePadding = 24;
  static const double fieldBorderWidth = 1;
  static const double focusedBorderWidth = 2;
  static const double cardBorderWidth = 1;

  /// Jarak vertikal antar section di halaman.
  static const double sectionSpacing = 24;

  /// Jarak antar item dalam satu daftar.
  static const double itemSpacing = 12;

  /// Tinggi gambar pada kartu lomba horizontal.
  static const double contestImageHeight = 120;

  /// Tinggi area daftar kontes horizontal (gambar + judul + info).
  static const double contestListHeight = 240;

  /// Tinggi gambar pada kartu penitipan vertikal.
  static const double boardingImageHeight = 88;

  /// Ukuran ikon pada placeholder dan header.
  static const double iconSize = 20;

  /// Ukuran avatar/logo kecil di halaman login.
  static const double logoSize = 56;

  /// Ukuran ikon besar pada placeholder halaman.
  static const double splashLogoSize = 96;

  /// Sisi kartu maskot di splash.
  static const double mascotCardSize = 128;

  /// Radius kartu maskot di splash.
  static const double mascotCardRadius = 32;

  /// Sisi gambar maskot di dalam kartu.
  static const double mascotSize = 80;

  /// Lebar maksimum blok konten tengah splash.
  static const double splashContentMaxWidth = 320;

  /// Radius pill penuh (chip, badge, indikator, tombol).
  static const double pillRadius = 999;

  /// Radius kartu panel besar (hero dan form auth).
  static const double panelRadius = 24;

  /// Radius kotak centang.
  static const double checkboxRadius = 6;

  /// Radius kartu showcase besar (onboarding).
  static const double showcaseRadius = 28;

  /// Rasio lebar:tinggi kartu showcase onboarding.
  static const double showcaseAspectRatio = 4 / 3.8;

  /// Lingkaran dalam di belakang maskot.
  static const double mascotInnerSize = 96;

  /// Logo kecil di header.
  static const double brandLogoSize = 28;

  /// Kotak ikon pada tile statistik.
  static const double iconBoxSize = 40;

  /// Radius kotak ikon pada tile statistik.
  static const double iconBoxRadius = 12;

  /// Radius badge kecil di atas gambar.
  static const double badgeRadius = 8;

  /// Tinggi search bar read-only di Beranda.
  static const double searchBarHeight = 52;

  /// Ukuran ikon kecil di dalam baris informasi kartu.
  static const double smallIconSize = 16;

  /// Bayangan tipis untuk pill dan chip.
  static const List<BoxShadow> softShadow = <BoxShadow>[
    BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: Offset(0, 1)),
  ];

  /// Bayangan tegas untuk kartu yang menonjol (mis. kartu maskot).
  static const List<BoxShadow> raisedShadow = <BoxShadow>[
    BoxShadow(color: AppColors.shadow, blurRadius: 24, offset: Offset(0, 12)),
  ];

  /// Tombol teks berbentuk pill dengan latar lavender (Lewati, Bantuan).
  static ButtonStyle softPillButton({
    required Color foreground,
    required TextStyle textStyle,
  }) {
    return TextButton.styleFrom(
      backgroundColor: AppColors.lavender,
      foregroundColor: foreground,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: const StadiumBorder(),
      textStyle: textStyle,
    );
  }

  static ThemeData get light {
    final colorScheme = _colorScheme();
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _textTheme(),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      filledButtonTheme: FilledButtonThemeData(
        style: _filledButtonStyle(colorScheme),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _outlinedButtonStyle(colorScheme),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(cardRadius)),
          side: BorderSide(
            color: colorScheme.outlineVariant,
            width: cardBorderWidth,
          ),
        ),
      ),
      navigationBarTheme: _navigationBarTheme(colorScheme),
      checkboxTheme: _checkboxTheme(),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: fieldBorderWidth,
        space: 0,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.sectionTitle,
      ),
    );
  }

  /// Color scheme dibangun dari seed primary lalu nilai brand dipatok persis
  /// pada peran yang sesuai (termasuk teks sekunder agar tidak diturunkan
  /// otomatis dari seed).
  static ColorScheme _colorScheme() {
    return ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      onPrimary: AppColors.surface,
      secondary: AppColors.limeStrong,
      onSecondary: AppColors.onLime,
      tertiary: AppColors.yellowStrong,
      onTertiary: AppColors.textPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      error: AppColors.error,
      onError: AppColors.surface,
      outline: AppColors.border,
      outlineVariant: AppColors.border,
    );
  }

  static TextTheme _textTheme() {
    return TextTheme(
      headlineSmall: AppTextStyles.pageTitle,
      titleLarge: AppTextStyles.sectionTitle,
      titleMedium: AppTextStyles.cardTitle,
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.body,
      bodySmall: AppTextStyles.caption,
      labelLarge: AppTextStyles.button,
      labelMedium: AppTextStyles.caption,
      labelSmall: AppTextStyles.caption,
    );
  }

  static InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.focused)
            ? AppColors.surface
            : AppColors.inputFill,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
      errorStyle: AppTextStyles.caption.copyWith(color: AppColors.error),
      prefixIconColor: AppColors.textSecondary,
      suffixIconColor: AppColors.textSecondary,
      border: _inputBorder(BorderSide.none),
      enabledBorder: _inputBorder(BorderSide.none),
      disabledBorder: _inputBorder(BorderSide.none),
      focusedBorder: _inputBorder(
        const BorderSide(
          color: AppColors.primaryFocus,
          width: focusedBorderWidth,
        ),
      ),
      errorBorder: _inputBorder(BorderSide(color: colorScheme.error)),
      focusedErrorBorder: _inputBorder(
        BorderSide(color: colorScheme.error, width: focusedBorderWidth),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(BorderSide side) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(inputRadius)),
      borderSide: side,
    );
  }

  static CheckboxThemeData _checkboxTheme() {
    return CheckboxThemeData(
      side: BorderSide.none,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(checkboxRadius)),
      ),
      checkColor: const WidgetStatePropertyAll(AppColors.surface),
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.primary
            : AppColors.lavender,
      ),
    );
  }

  static ButtonStyle _filledButtonStyle(ColorScheme colorScheme) {
    return FilledButton.styleFrom(
      foregroundColor: colorScheme.onPrimary,
      disabledForegroundColor: colorScheme.onPrimary,
      elevation: 0,
      minimumSize: const Size.fromHeight(buttonHeight),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(buttonRadius)),
      ),
      textStyle: AppTextStyles.button,
    ).copyWith(
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => _filledBackground(colorScheme, states),
      ),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }

  /// Latar tombol utama: indigo, lebih gelap saat ditekan, pudar saat nonaktif.
  static Color _filledBackground(
    ColorScheme colorScheme,
    Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.disabled)) {
      return colorScheme.primary.withValues(alpha: 0.4);
    }
    if (states.contains(WidgetState.pressed)) {
      return AppColors.primaryPressed;
    }
    return colorScheme.primary;
  }

  static ButtonStyle _outlinedButtonStyle(ColorScheme colorScheme) {
    return OutlinedButton.styleFrom(
      foregroundColor: colorScheme.primary,
      elevation: 0,
      minimumSize: const Size.fromHeight(buttonHeight),
      side: BorderSide(color: colorScheme.outlineVariant),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(buttonRadius)),
      ),
      textStyle: AppTextStyles.button,
    );
  }

  static NavigationBarThemeData _navigationBarTheme(ColorScheme colorScheme) {
    return NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      height: 72,
      indicatorColor: AppColors.primaryIndicator,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final color = states.contains(WidgetState.selected)
            ? colorScheme.primary
            : AppColors.textSecondary;
        return IconThemeData(color: color);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final color = states.contains(WidgetState.selected)
            ? colorScheme.primary
            : AppColors.textSecondary;
        return AppTextStyles.caption.copyWith(
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w600
              : FontWeight.w400,
          color: color,
        );
      }),
    );
  }
}
