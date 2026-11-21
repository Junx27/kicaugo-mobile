import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/check_label.dart';
import '../../../../core/widgets/link_button.dart';
import '../auth_strings.dart';
import '../auth_validators.dart';

/// Callback kirim formulir masuk.
typedef LoginCallback = void Function(String identifier, String password);

/// Formulir masuk: email/WA, kata sandi, ingat saya, lupa sandi, kirim.
class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.isLoading, required this.onSubmit});

  final bool isLoading;
  final LoginCallback onSubmit;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _password = TextEditingController();

  /// Hanya state tampilan; sesi belum disimpan permanen.
  bool _rememberMe = false;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    widget.onSubmit(_identifier.text.trim(), _password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          AppTextField(
            key: const Key('login_identifier'),
            controller: _identifier,
            spec: AuthFields.identifier,
            keyboardType: TextInputType.emailAddress,
            validator: AuthValidators.identifier,
          ),
          AppTextField(
            key: const Key('login_password'),
            controller: _password,
            spec: AuthFields.password,
            obscureText: true,
            textInputAction: TextInputAction.done,
            validator: AuthValidators.password,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: CheckLabel(
                  value: _rememberMe,
                  label: AuthStrings.rememberMe,
                  onChanged: (value) => setState(() => _rememberMe = value),
                ),
              ),
              LinkButton(
                label: AuthStrings.forgotPassword,
                style: AppTextStyles.label,
                onPressed: () => showComingSoon(context),
              ),
            ],
          ),
          AppButton(
            key: const Key('login_submit'),
            label: AuthStrings.loginSubmit,
            trailingIcon: Icons.arrow_forward_rounded,
            isLoading: widget.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
