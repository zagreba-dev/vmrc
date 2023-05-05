import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:vmrc/models/sign_in_screen_model.dart';
import 'package:vmrc/repositories/auth_repository.dart';
import 'package:vmrc/ui/sign_up_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SignInScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ChangeNotifierProvider<SignInPageModel>(
          create: (_) => SignInPageModel(AuthenticationRepository()),
          child: const SignInForm(),
        ),
      ),
    );
  }
}

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            _EmailInput(),
            const SizedBox(height: 8),
            _PasswordInput(),
            const SizedBox(height: 8),
            _SignInButton(),
            const SizedBox(height: 8),
            _SignUpButton(),
            Selector<SignInPageModel, bool>(
                selector: (_, model) =>
                    model.state.status == FormzStatus.submissionFailure,
                builder: (_, data, __) {
                  return SnackBarLauncher(
                    error: context.read<SignInPageModel>().state.errorMessage,
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
    return Selector<SignInPageModel, String>(
        selector: (_, model) => model.state.email.value,
        builder: (_, data, __) {
          print('build email $data');
          return TextField(
            onChanged: (email) =>
                context.read<SignInPageModel>().emailChanged(email),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'Enter your email',
              helperText: '',
              errorText:  
                context.read<SignInPageModel>().state.email.isValid
                ? null
                : context.read<SignInPageModel>().emailValidationError,
            ),
          );
        });
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<SignInPageModel, String>(
        selector: (_, model) => model.state.password.value,
        builder: (_, data, __) {
          print(context.read<SignInPageModel>().state.password.isValid);
          print('build password $data');
          return TextField(
            onChanged: (password) =>
                context.read<SignInPageModel>().passwordChanged(password),
            //obscureText: true,
            decoration: InputDecoration(
              hintText: 'Enter your password',
              helperText: '',
              errorText: 
                context.read<SignInPageModel>().state.password.isValid
                ? null
                : context.read<SignInPageModel>().passwordValidationError,
            ),
          );
        });
  }
}

class _SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<SignInPageModel, Tuple2<FormzStatus, bool>>(
        selector: (_, model) =>
            Tuple2(model.state.status, model.state.validateStatus),
        builder: (_, data, __) {
          print('build button $data');
          return data.item1 == FormzStatus.submissionInProgress
              ? SizedBox(width: 50, height: 50, child: const CircularProgressIndicator())
              : ElevatedButton(
                  key: const Key('signIpForm_continue_raisedButton'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: data.item2
                      ? () =>
                          context.read<SignInPageModel>().signInFormSubmitted()
                      : null,
                  child: const Text(
                    'SIGN IN',
                    style: TextStyle(fontSize: 22),
                  ),
                );
        });
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<SignInPageModel, FormzStatus>(
        selector: (_, model) => model.state.status,
        builder: (_, data, __) {
        return ElevatedButton(
          key: const Key('signUpForm_continue_raisedButton'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            minimumSize: const Size.fromHeight(50),
          ),
          onPressed: data != FormzStatus.submissionInProgress 
          ? () => Navigator.of(context).push<void>(SignUpScreen.route()) 
          : null ,
          child: const Text(
            'SIGN UP',
            style: TextStyle(fontSize: 22),
          ),
        );
      }
    );
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
