import 'package:flutter/material.dart';
import 'package:vmrc/confirmed_password.dart';
import 'package:vmrc/email.dart';
import 'package:vmrc/password.dart';
import 'package:vmrc/repositories/auth_repository.dart';
import 'package:formz/formz.dart';

enum FormzStatus {
  submissionInitial,
  submissionInProgress,
  submissionSuccess,
  submissionFailure
}

class SignUpState {
  SignUpState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.status = FormzStatus.submissionInitial,
    this.validateStatus = false,
    this.errorMessage,
  });

  Email email;
  Password password;
  ConfirmedPassword confirmedPassword;
  FormzStatus status;
  bool validateStatus;
  String? errorMessage;
}

class SignUpPageModel extends ChangeNotifier {
  SignUpPageModel(this._authenticationRepository);

  final AuthenticationRepository _authenticationRepository;
  final _state = SignUpState();

  SignUpState get state => _state;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    _state.email = email;
    _state.validateStatus = Formz.validate([
      email,
      _state.password,
      _state.confirmedPassword,
    ]);
    notifyListeners();
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    _state.password = password;
    _state.validateStatus = Formz.validate([
      _state.email,
      password,
      _state.confirmedPassword,
    ]);
    notifyListeners();
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(value);
    _state.confirmedPassword = confirmedPassword;
    _state.validateStatus = Formz.validate([
      _state.email,
      _state.password,
      confirmedPassword,
    ]);
    notifyListeners();
  }

  Future<void> signUpFormSubmitted() async {
    if (!_state.validateStatus) return;
    _state.errorMessage = null;
    _state.status = FormzStatus.submissionInProgress;
    notifyListeners();
    try {
      await _authenticationRepository.signUpWithEmailAndPassword(
        email: _state.email.value,
        password: _state.password.value,
      );
      _state.status = FormzStatus.submissionSuccess;
      notifyListeners();
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      _state.errorMessage = e.message;
      _state.status = FormzStatus.submissionFailure;
      notifyListeners();
    } catch (_) {
      _state.status = FormzStatus.submissionFailure;
      notifyListeners();
    }
  }
}
