import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumahkicau_mobile/core/theme/app_colors.dart';
import 'package:rumahkicau_mobile/core/theme/app_text_styles.dart';
import 'package:rumahkicau_mobile/core/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final theme = AppTheme.light;

  group('palet warna', () {
    test('color scheme memakai warna brand', () {
      final scheme = theme.colorScheme;

      expect(scheme.primary, AppColors.primary);
      expect(scheme.onPrimary, AppColors.surface);
      expect(scheme.secondary, AppColors.limeStrong);
      expect(scheme.onSecondary, AppColors.onLime);
      expect(scheme.tertiary, AppColors.yellowStrong);
      expect(scheme.onTertiary, AppColors.textPrimary);
      expect(scheme.surface, AppColors.surface);
      expect(scheme.onSurface, AppColors.textPrimary);
      expect(scheme.onSurfaceVariant, AppColors.textSecondary);
      expect(scheme.error, AppColors.error);
      expect(scheme.outline, AppColors.border);
      expect(scheme.outlineVariant, AppColors.border);
      expect(theme.scaffoldBackgroundColor, AppColors.background);
    });

    test('primary indigo dan teks gelap sesuai spesifikasi', () {
      expect(AppColors.primary, const Color(0xFF3B30E0));
      expect(AppColors.primaryPressed, const Color(0xFF2E24BD));
      expect(AppColors.textPrimary, const Color(0xFF15122B));
      expect(AppColors.background, const Color(0xFFFFFFFF));
    });

    test('indikator navbar memakai primary 12%', () {
      expect(AppColors.primaryIndicator.a, closeTo(0.12, 0.01));
      expect(
        theme.navigationBarTheme.indicatorColor,
        AppColors.primaryIndicator,
      );
    });
  });

  group('tipografi', () {
    test('heading memakai Plus Jakarta Sans', () {
      expect(AppTextStyles.pageTitle.fontFamily, startsWith('PlusJakartaSans'));
      expect(AppTextStyles.pageTitle.fontSize, 24);
      expect(AppTextStyles.pageTitle.fontWeight, FontWeight.w700);
      expect(AppTextStyles.sectionTitle.fontSize, 18);
      expect(AppTextStyles.sectionTitle.fontWeight, FontWeight.w600);
      expect(AppTextStyles.cardTitle.fontSize, 16);
      expect(AppTextStyles.cardTitle.fontWeight, FontWeight.w600);
    });

    test('body memakai Inter', () {
      expect(AppTextStyles.body.fontFamily, startsWith('Inter'));
      expect(AppTextStyles.body.fontSize, 14);
      expect(AppTextStyles.body.fontWeight, FontWeight.w400);
      expect(AppTextStyles.caption.fontSize, 12);
      expect(AppTextStyles.button.fontFamily, startsWith('PlusJakartaSans'));
      expect(AppTextStyles.button.fontSize, 14);
      expect(AppTextStyles.button.fontWeight, FontWeight.w700);
    });

    test('display, label, dan eyebrow memakai Plus Jakarta Sans', () {
      expect(AppTextStyles.display.fontFamily, startsWith('PlusJakartaSans'));
      expect(AppTextStyles.display.fontSize, 32);
      expect(AppTextStyles.display.fontWeight, FontWeight.w800);
      expect(AppTextStyles.label.fontSize, 12);
      expect(AppTextStyles.label.fontWeight, FontWeight.w700);
      expect(AppTextStyles.eyebrow.fontSize, 10);
      expect(AppTextStyles.eyebrow.fontWeight, FontWeight.w700);
      expect(AppTextStyles.headline.fontSize, 26);
      expect(AppTextStyles.headline.fontWeight, FontWeight.w800);
      expect(AppTextStyles.title.fontSize, 18);
      expect(AppTextStyles.title.fontWeight, FontWeight.w700);
    });

    test('text theme memetakan heading dan body', () {
      expect(
        theme.textTheme.headlineSmall?.fontFamily,
        startsWith('PlusJakartaSans'),
      );
      expect(
        theme.textTheme.titleLarge?.fontFamily,
        startsWith('PlusJakartaSans'),
      );
      expect(
        theme.textTheme.titleMedium?.fontFamily,
        startsWith('PlusJakartaSans'),
      );
      expect(theme.textTheme.bodyMedium?.fontFamily, startsWith('Inter'));
      expect(theme.textTheme.bodySmall?.fontFamily, startsWith('Inter'));
      expect(
        theme.textTheme.labelLarge?.fontFamily,
        startsWith('PlusJakartaSans'),
      );
    });
  });

  group('komponen', () {
    test('input berisi lavender, putih saat fokus, cincin primary 40%', () {
      final input = theme.inputDecorationTheme;
      final fill = input.fillColor! as WidgetStateColor;

      expect(input.filled, isTrue);
      expect(fill.resolve(<WidgetState>{}), AppColors.inputFill);
      expect(
        fill.resolve(<WidgetState>{WidgetState.focused}),
        AppColors.surface,
      );
      expect(input.enabledBorder?.borderSide, BorderSide.none);
      expect(input.focusedBorder?.borderSide.color, AppColors.primaryFocus);
      expect(input.focusedBorder?.borderSide.width, 2);
      expect(input.errorBorder?.borderSide.color, AppColors.error);
      expect(
        (input.enabledBorder! as OutlineInputBorder).borderRadius,
        const BorderRadius.all(Radius.circular(AppTheme.inputRadius)),
      );
      expect(input.hintStyle?.color, AppColors.textSecondary);
    });

    test('checkbox indigo saat dicentang, lavender saat kosong', () {
      final checkbox = theme.checkboxTheme;

      expect(
        checkbox.fillColor?.resolve(<WidgetState>{WidgetState.selected}),
        AppColors.primary,
      );
      expect(checkbox.fillColor?.resolve(<WidgetState>{}), AppColors.lavender);
      expect(checkbox.checkColor?.resolve(<WidgetState>{}), AppColors.surface);
    });

    test('tombol pill lembut memakai latar lavender', () {
      final style = AppTheme.softPillButton(
        foreground: AppColors.primary,
        textStyle: AppTextStyles.label,
      );

      expect(
        style.backgroundColor?.resolve(<WidgetState>{}),
        AppColors.lavender,
      );
      expect(
        style.foregroundColor?.resolve(<WidgetState>{}),
        AppColors.primary,
      );
      expect(style.shape?.resolve(<WidgetState>{}), isA<StadiumBorder>());
    });

    test('tombol utama pill penuh, tinggi 52, elevation 0', () {
      final style = theme.filledButtonTheme.style!;
      final shape =
          style.shape?.resolve(<WidgetState>{}) as RoundedRectangleBorder?;

      expect(
        style.minimumSize?.resolve(<WidgetState>{}),
        const Size.fromHeight(AppTheme.buttonHeight),
      );
      expect(style.elevation?.resolve(<WidgetState>{}), 0);
      expect(
        shape?.borderRadius,
        const BorderRadius.all(Radius.circular(AppTheme.buttonRadius)),
      );
      expect(
        style.backgroundColor?.resolve(<WidgetState>{}),
        AppColors.primary,
      );
      expect(
        style.foregroundColor?.resolve(<WidgetState>{}),
        AppColors.surface,
      );
      expect(
        style.backgroundColor?.resolve(<WidgetState>{WidgetState.pressed}),
        AppColors.primaryPressed,
      );
      expect(
        style.backgroundColor?.resolve(<WidgetState>{WidgetState.disabled}),
        AppColors.primary.withValues(alpha: 0.4),
      );
      expect(
        style.textStyle?.resolve(<WidgetState>{})?.fontWeight,
        FontWeight.w700,
      );
      expect(AppTheme.buttonRadius, AppTheme.pillRadius);
    });

    test('kartu radius 16 dengan border tipis', () {
      final shape = theme.cardTheme.shape as RoundedRectangleBorder?;
      final side = shape?.side;

      expect(theme.cardTheme.elevation, 0);
      expect(theme.cardTheme.color, AppColors.surface);
      expect(
        shape?.borderRadius,
        const BorderRadius.all(Radius.circular(AppTheme.cardRadius)),
      );
      expect(side?.color, AppColors.border);
      expect(side?.width, 1);
    });

    test('navbar memakai surface dan warna state yang benar', () {
      final navbar = theme.navigationBarTheme;

      expect(navbar.backgroundColor, AppColors.surface);
      expect(navbar.elevation, 0);
      expect(
        navbar.iconTheme?.resolve(<WidgetState>{})?.color,
        AppColors.textSecondary,
      );
      expect(
        navbar.iconTheme?.resolve(<WidgetState>{WidgetState.selected})?.color,
        AppColors.primary,
      );
      expect(
        navbar.labelTextStyle?.resolve(<WidgetState>{})?.color,
        AppColors.textSecondary,
      );
      expect(
        navbar.labelTextStyle?.resolve(<WidgetState>{
          WidgetState.selected,
        })?.color,
        AppColors.primary,
      );
    });
  });

  test('aset font dan gambar ter-bundle di aplikasi', () async {
    const fonts = <String>[
      'assets/google_fonts/PlusJakartaSans-SemiBold.ttf',
      'assets/google_fonts/PlusJakartaSans-Bold.ttf',
      'assets/google_fonts/PlusJakartaSans-ExtraBold.ttf',
      'assets/images/mascot.svg',
      'assets/images/mascot_perch.svg',
      'assets/images/google_logo.svg',
      'assets/google_fonts/Inter-Regular.ttf',
      'assets/google_fonts/Inter-SemiBold.ttf',
      'assets/google_fonts/OFL-PlusJakartaSans.txt',
      'assets/google_fonts/OFL-Inter.txt',
    ];

    for (final path in fonts) {
      final data = await rootBundle.load(path);
      expect(data.lengthInBytes, greaterThan(0), reason: path);
    }
  });
}
