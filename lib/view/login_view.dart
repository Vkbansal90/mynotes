import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter the email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
                hintText: 'Enter the new password to register'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute,
                  (route) => false,
                );
                devtools.log(userCredential.toString());
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  await showErrorDiaglog(
                    context,
                    'User Not Found',
                  );
                } else if (e.code == 'wrong-password') {
                  await showErrorDiaglog(
                    context,
                    'Wrong credentials',
                  );
                } else {
                  await showErrorDiaglog(
                    context,
                    'Error: ${e.code}',
                  );
                }
              } catch (e) {
                await showErrorDiaglog(
                  context,
                  e.toString(),
                );
              }
            },
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue)),
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue)),
            child: const Text(
              'Not registered yet? Register here!',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

Future<void> showErrorDiaglog(
  BuildContext context,
  String text,
) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('An error occurred'),
      content: Text(text),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('ok'),
        )
      ],
    ),
  );
}
