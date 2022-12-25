import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/router.dart';

class MyNotesView extends StatelessWidget {
  const MyNotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(LoginRoute, (route) => false);
                },
                child: const Text("Log Out")),
          )
        ],
      ),
    );
  }
}
