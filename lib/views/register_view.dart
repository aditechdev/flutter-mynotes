import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/router.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text("Register"),
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
            // autofillHints: "Email",
          ),
          TextButton(
            child: const Text(
              "Register",
            ),
            onPressed: () async {
              final email = _userName.text;
              final password = _pwd.text;
              print("Register: $email and $password");
              var user = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: email, password: password);

              print(user);
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(LoginRoute, (route) => false);
            },
            child: const Text(
              "Already register? Login Here!",
            ),
          )
        ],
      ),
    );
  }
}
