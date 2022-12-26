import 'package:flutter/material.dart';
import 'package:mynotes/constants/router.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

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
                await AuthService.firebase()
                    .logIn(email: email, password: password);
                final user = AuthService.firebase().currentUser;
                if (!mounted) return;
                if (user?.isEmailVerified == true) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(NotesRoute, (route) => false);
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      EmailViewRoute, (route) => false);
                }
              } on UserNotFoundAuthExceptions {
                await showErrorDialogue(context, "User not found");
              } on WrongPasswordAuthExceptions {
                await showErrorDialogue(context, "Wrong password");
              } on GenericAuthExceptions {
                await showErrorDialogue(context, "ERROR: Authentication Error");
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
