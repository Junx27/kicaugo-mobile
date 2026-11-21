import 'package:flutter/material.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/check_label.dart';
import '../auth_strings.dart';
import '../auth_validators.dart';

/// Callback kirim formulir daftar.
typedef RegisterCallback =
    void Function(String name, String identifier, String password);

/// Formulir daftar: nama, email/WA, sandi, konfirmasi, persetujuan S&K.
class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.isLoading,
    required this.onSubmit,
  });

  final bool isLoading;
  final RegisterCallback onSubmit;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _identifier.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    widget.onSubmit(_name.text.trim(), _identifier.text.trim(), _password.text);
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
            key: const Key('register_name'),
            controller: _name,
            spec: AuthFields.name,
            keyboardType: TextInputType.name,
            validator: AuthValidators.name,
          ),
          AppTextField(
            key: const Key('register_identifier'),
            controller: _identifier,
            spec: AuthFields.identifier,
            keyboardType: TextInputType.emailAddress,
            validator: AuthValidators.identifier,
          ),
          AppTextField(
            key: const Key('register_password'),
            controller: _password,
            spec: AuthFields.newPassword,
            obscureText: true,
            validator: AuthValidators.newPassword,
          ),
          AppTextField(
            key: const Key('register_confirm'),
            controller: _confirm,
            spec: AuthFields.confirmPassword,
            obscureText: true,
            textInputAction: TextInputAction.done,
            validator: (value) =>
                AuthValidators.confirmPassword(value, _password.text),
          ),
          FormField<bool>(
            initialValue: false,
            validator: AuthValidators.acceptedTerms,
            builder: (field) => CheckLabel(
              key: const Key('register_terms'),
              value: field.value ?? false,
              label: AuthStrings.acceptTerms,
              errorText: field.errorText,
              onChanged: field.didChange,
            ),
          ),
          AppButton(
            key: const Key('register_submit'),
            label: AuthStrings.registerSubmit,
            trailingIcon: Icons.arrow_forward_rounded,
            isLoading: widget.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
