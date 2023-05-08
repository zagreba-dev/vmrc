import 'package:formz/formz.dart';

enum PriceValidationError {
  required,
}

class Price extends FormzInput<String, PriceValidationError> {
  const Price.pure() : super.pure('');

  const Price.dirty([super.value = '']) : super.dirty();

  @override
  PriceValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return PriceValidationError.required;
    return null;
  }
}
