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
  final String password;
  const ConfirmedPassword.pure({this.password = ''}) : super.pure('');

  /// {@macro password}
  const ConfirmedPassword.dirty({required this.password, String value = ''})
      : super.dirty(value);

  @override
  ConfirmedPasswordValidationError? validator(String? value) {
    return password == value ? null : ConfirmedPasswordValidationError.invalid;
  }
}
