import 'package:flutter/material.dart';

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
