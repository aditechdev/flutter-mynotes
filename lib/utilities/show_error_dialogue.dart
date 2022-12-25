import 'package:flutter/material.dart';

Future<void> showErrorDialogue(BuildContext context, String title) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Ok")),
        ],
      );
    },
  );
}
