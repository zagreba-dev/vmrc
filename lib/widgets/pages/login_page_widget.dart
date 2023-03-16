import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPageWidget extends StatelessWidget {
  const LoginPageWidget({Key? key}) : super(key: key);

  static const String _title = 'Login Page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_title),
        centerTitle: true,
      ),
      body: LoginWidget(),
    );
  }
}

class LoginWidget extends StatefulWidget {
  LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  String _errorTextFirebaseAuthException = '';
  bool isButtonActionStart = true;

  @override
  void initState() {
    _controllerEmail.addListener(() {
      // delete error text one time after first write email
      if (_controllerEmail.text.isNotEmpty &&
          _controllerEmail.text.length == 1) {
        setState(() {
          _errorTextFirebaseAuthException = '';
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Expanded(child: Container()),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      errorText: _errorTextFirebaseAuthException == ''
                          ? null
                          : _errorTextFirebaseAuthException,
                      hintText: 'Enter your email',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _controllerPassword,
                    textInputAction: TextInputAction.done,
                    //dont show password '*'
                    //obscureText: true,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'Enter your password',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onEditingComplete: singIn,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50)),
                        icon: const Icon(Icons.login_outlined, size: 32),
                        label: isButtonActionStart
                            ? const Text('Sign In',
                                style: TextStyle(fontSize: 22))
                            : const CircularProgressIndicator(
                                color: Colors.red,
                              ),
                        onPressed: singIn,
                      )),
                ],
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  void singIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isButtonActionStart = false;
      });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _controllerEmail.text.trim(),
          password: _controllerPassword.text.trim(),
        );
        setState(() {
          isButtonActionStart = true;
        });
      } on FirebaseAuthException catch (e) {
        _controllerEmail.clear();
        _controllerPassword.clear();
        if (e.code == 'user-not-found') {
          setState(() {
            _errorTextFirebaseAuthException = 'No user found for that email.';
          });
        } else if (e.code == 'invalid-email') {
          setState(() {
            _errorTextFirebaseAuthException = 'Invalid-email provided.';
          });
        } else if (e.code == 'wrong-password') {
          setState(() {
            _errorTextFirebaseAuthException =
                'Wrong password provided for that user.';
          });
        } else if (e.code == 'too-many-requests') {
          setState(() {
            _errorTextFirebaseAuthException = 'Too many requests.';
          });
        }
        setState(() {
          isButtonActionStart = true;
        });
      } catch (e) {
        print(e);
      }
    }
  }
}
