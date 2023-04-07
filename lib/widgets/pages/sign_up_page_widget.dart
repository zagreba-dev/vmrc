import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:vmrc/email.dart';
import 'package:vmrc/models/sign_up_page_model.dart';
import 'package:vmrc/password.dart';
import 'package:vmrc/repositories/auth_repository.dart';

class SignUpPageWidget extends StatelessWidget {
  const SignUpPageWidget({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPageWidget());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ChangeNotifierProvider<SignUpPageModel>(
          create: (_) => SignUpPageModel(AuthenticationRepository()),
          child: const SignUpForm(),
        ),
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EmailInput(),
            //const SizedBox(height: 8),
            _PasswordInput(),
            //const SizedBox(height: 8),
            _ConfirmPasswordInput(),
            //const SizedBox(height: 8),
            _SignUpButton(),
            Selector<SignUpPageModel, bool>(
                selector: (_, model) =>
                    model.state.status == FormzStatus.submissionFailure,
                builder: (_, data, __) {
                  return SnackBarLauncher(
                    error: context.read<SignUpPageModel>().state.errorMessage,
                    toShow: data,
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<SignUpPageModel, String>(
        selector: (_, model) => model.state.email.value,
        builder: (_, data, __) {
          print('build email $data');
          return TextField(
            onChanged: (email) =>
                context.read<SignUpPageModel>().emailChanged(email),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Enter your email',
              helperText: '',
              errorText:
                  context.read<SignUpPageModel>().state.email.displayError ==
                          EmailValidationError.invalid
                      ? 'invalid email'
                      : null,
            ),
          );
        });
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<SignUpPageModel, String>(
        selector: (_, model) => model.state.password.value,
        builder: (_, data, __) {
          print('build password $data');
          return TextField(
            onChanged: (password) =>
                context.read<SignUpPageModel>().passwordChanged(password),
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Enter your password',
              helperText: '',
              errorText:
                  context.read<SignUpPageModel>().state.password.displayError ==
                          PasswordValidationError.invalid
                      ? 'invalid password'
                      : null,
            ),
          );
        });
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<SignUpPageModel, String>(
        selector: (_, model) => model.state.confirmedPassword.value,
        builder: (_, data, __) {
          print('build confirmedPassword $data');
          return TextField(
            key: const Key('signUpForm_confirmedPasswordInput_textField'),
            onChanged: (confirmPassword) => context
                .read<SignUpPageModel>()
                .confirmedPasswordChanged(confirmPassword),
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Confirm your password',
              helperText: '',
            ),
          );
        });
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<SignUpPageModel, Tuple2<FormzStatus, bool>>(
        selector: (_, model) =>
            Tuple2(model.state.status, model.state.validateStatus),
        builder: (_, data, __) {
          print('build button $data');
          return data.item1 == FormzStatus.submissionInProgress
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  key: const Key('signUpForm_continue_raisedButton'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: data.item2
                      ? () =>
                          context.read<SignUpPageModel>().signUpFormSubmitted()
                      : null,
                  child: const Text(
                    'SIGN UP',
                    style: TextStyle(fontSize: 22),
                  ),
                );
        });
  }
}

class SnackBarLauncher extends StatelessWidget {
  final String? error;
  final bool toShow;

  const SnackBarLauncher({required this.error, this.toShow = false, super.key});

  @override
  Widget build(BuildContext context) {
    if (toShow) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _displaySnackBar(context));
    }
    // Placeholder container widget
    return Container();
  }

  void _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text(error ?? 'Sign Up Failure'));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
