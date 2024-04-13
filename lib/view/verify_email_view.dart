import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Verify Email',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          const Text(
              "we've send you an verification email. please open it to verify your email"),
          const Text(
              "if you haven't recived the email click on the button below to resend it"),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue)),
            child: const Text('send email verification'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue)),
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}
