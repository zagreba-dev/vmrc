import 'package:flutter/material.dart';
import 'package:vmrc/entity/email.dart';
import 'package:vmrc/entity/password.dart';
import 'package:vmrc/repositories/auth_repository.dart';
import 'package:formz/formz.dart';
import 'package:vmrc/utils/utils.dart';

enum FormzStatus {
  submissionInitial,
  submissionInProgress,
  submissionSuccess,
  submissionFailure
}

class SignInState {
  SignInState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.submissionInitial,
    this.validateStatus = false,
    this.errorMessage,
  });

  Email email;
  Password password;
  FormzStatus status;
  bool validateStatus;
  String? errorMessage;
}

class SignInPageModel extends ChangeNotifier {
  SignInPageModel(this._authenticationRepository);

  final AuthenticationRepository _authenticationRepository;
  final _state = SignInState();

  SignInState get state => _state;
  String? get passwordValidationError => passwordValidationErrorToString(_state.password.displayError);
  String? get emailValidationError => emailValidationErrorToString(_state.email.displayError);

  void emailChanged(String value) {
    final email = Email.dirty(value);
    _state.email = email;
    _state.validateStatus = Formz.validate([
      email,
      _state.password,
    ]);
    notifyListeners();
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    _state.password = password;
    _state.validateStatus = Formz.validate([
      _state.email,
      password,
    ]);
    notifyListeners();
  }

  Future<void> signInFormSubmitted() async {
    if (!_state.validateStatus) return;
    _state.errorMessage = null;
    _state.status = FormzStatus.submissionInProgress;
    notifyListeners();
    try {
      await _authenticationRepository.logInWithEmailAndPassword(
        email: _state.email.value,
        password: _state.password.value,
      );
      _state.status = FormzStatus.submissionSuccess;
      notifyListeners();
    } on LogInWithEmailAndPasswordFailure catch (e) {
      _state.errorMessage = e.message;
      _state.status = FormzStatus.submissionFailure;
      notifyListeners();
    } catch (_) {
      _state.status = FormzStatus.submissionFailure;
      notifyListeners();
    }
  }
}
