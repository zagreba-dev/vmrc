import 'package:formz/formz.dart';

enum PasswordValidationError {
  required,
  invalid,
  short
}

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');

  const Password.dirty([super.value = '']) : super.dirty();

  static final _passwordRegExp =
      //RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[.@$!%*#?&])[A-Za-z\d.@$!%*#?&]{8,}$');

  @override
  PasswordValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return PasswordValidationError.required;
    if (value.length < 8) return PasswordValidationError.short;
    if (!_passwordRegExp.hasMatch(value)) return PasswordValidationError.invalid;
    return null;
  }
}
