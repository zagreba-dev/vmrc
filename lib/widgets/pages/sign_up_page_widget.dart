import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.all(8),
        child: Container(),
      ),
    );
  }
}
