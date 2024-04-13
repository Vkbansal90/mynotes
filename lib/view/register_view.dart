import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
          'Register',
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
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final user = FirebaseAuth.instance.currentUser;
                user?.sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  await showErrorDiaglog(
                    // ignore: use_build_context_synchronously
                    context,
                    'weak password',
                  );
                } else if (e.code == 'email-already-in-use') {
                  await showErrorDiaglog(
                    context,
                    'email is already in use',
                  );
                } else if (e.code == 'invalid-email') {
                  await showErrorDiaglog(
                    context,
                    'this is a invalid email address',
                  );
                } else {
                  await showErrorDiaglog(
                    context,
                    'Error ${e.code}',
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
              'Register',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue)),
            child: const Text(
              'Already registered ! Login here',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
