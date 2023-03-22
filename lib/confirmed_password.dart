import 'package:formz/formz.dart';

/// Validation errors for the [Password] [FormzInput].
enum ConfirmedPasswordValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template password}
/// Form input for an password input.
/// {@endtemplate}
class ConfirmedPassword
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  /// {@macro password}
  const ConfirmedPassword.pure() : super.pure('');

  /// {@macro password}
  const ConfirmedPassword.dirty([super.value = '']) : super.dirty();

  static final _passwordRegExp =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  ConfirmedPasswordValidationError? validator(String? value) {
    return _passwordRegExp.hasMatch(value ?? '')
        ? null
        : ConfirmedPasswordValidationError.invalid;
  }

  ConfirmedPasswordValidationError? validatorMatches(String? value) {
    return this.value == value
        ? null
        : ConfirmedPasswordValidationError.invalid;
  }
}
