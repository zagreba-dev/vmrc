import 'package:formz/formz.dart';

enum DepositValidationError {
  required,
}

class Deposit extends FormzInput<String, DepositValidationError> {
  const Deposit.pure() : super.pure('');

  const Deposit.dirty([super.value = '']) : super.dirty();

  @override
  DepositValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return DepositValidationError.required;
    return null;
  }
}
