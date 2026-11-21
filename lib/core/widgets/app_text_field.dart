import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Konten statis sebuah field: label, contoh di kanan label, placeholder, ikon.
@immutable
class AppFieldSpec {
  const AppFieldSpec({
    required this.label,
    required this.icon,
    this.hint,
    this.labelTrailing,
  });

  final String label;
  final IconData icon;
  final String? hint;

  /// Teks kecil di kanan label (mis. "Contoh: 0812...").
  final String? labelTrailing;
}

/// Input berlabel di atas field, dengan toggle tampil/sembunyi untuk sandi.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.spec,
    this.validator,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final AppFieldSpec spec;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;

  static const String showPasswordTooltip = 'Tampilkan kata sandi';
  static const String hidePasswordTooltip = 'Sembunyikan kata sandi';

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    final spec = widget.spec;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 6,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                spec.label,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (spec.labelTrailing != null)
              Text(spec.labelTrailing!, style: AppTextStyles.caption),
          ],
        ),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscured,
          validator: widget.validator,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: spec.hint,
            prefixIcon: Icon(spec.icon),
            suffixIcon: widget.obscureText ? _buildVisibilityToggle() : null,
          ),
        ),
      ],
    );
  }

  Widget _buildVisibilityToggle() {
    return IconButton(
      tooltip: _obscured
          ? AppTextField.showPasswordTooltip
          : AppTextField.hidePasswordTooltip,
      icon: Icon(
        _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
      ),
      onPressed: () => setState(() => _obscured = !_obscured),
    );
  }
}
