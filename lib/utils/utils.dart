import 'package:vmrc/entity/email.dart';
import 'package:vmrc/entity/password.dart';

String? emailValidationErrorToString(EmailValidationError? type) {
  switch(type) {
    case EmailValidationError.required: return 'field is required';
    case EmailValidationError.invalid: return 'invalid email';
    default: return null;
  }
}

String? passwordValidationErrorToString(PasswordValidationError? type) {
  switch(type) {
    case PasswordValidationError.required: return 'field is required';
    case PasswordValidationError.short: return 'min required characters 8';
    case PasswordValidationError.invalid: return 'invalid password';
    default: return null;
  }
}