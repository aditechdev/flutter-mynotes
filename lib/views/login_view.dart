import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/router.dart';

import 'package:mynotes/utilities/show_error_dialogue.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _userName;
  late final TextEditingController _pwd;

  @override
  void initState() {
    super.initState();
    _userName = TextEditingController();
    _pwd = TextEditingController();
  }

  @override
  void dispose() {
    _userName.dispose();
    _pwd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _userName,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Email",
            ),
          ),
          TextField(
            controller: _pwd,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "Password",
            ),
          ),
          TextButton(
            child: const Text(
              "Sign In",
            ),
            onPressed: () async {
              final email = _userName.text;
              final password = _pwd.text;

              try {
                var user = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password);
                if (!mounted) return;
                if (user.user!.emailVerified == true) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(NotesRoute, (route) => false);
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      EmailViewRoute, (route) => false);
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == "user-not-found") {
                  await showErrorDialogue(context, "User not found");
                } else if (e.code == "wrong-password") {
                  await showErrorDialogue(context, "Wrong password");
                } else {
                  await showErrorDialogue(context, "ERROR: ${e.code}");
                }
              } catch (e) {
                await showErrorDialogue(context, "ERROR: $e");
              }
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(RegisterRoute, (route) => false);
            },
            child: const Text(
              "Not Register? Register Here!",
            ),
          )
        ],
      ),
    );
  }
}
