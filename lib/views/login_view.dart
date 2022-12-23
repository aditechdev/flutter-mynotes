import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

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
      body: Center(
        child: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
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
                        "Sign In",
                      ),
                      onPressed: () async {
                        final email = _userName.text;
                        final password = _pwd.text;
                        print("Register: $email and $password");

                        try {
                          var user = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);

                          print(user);
                        } on FirebaseAuthException catch (e) {
                          print(e.code);
                          if (e.code == "user-not-found") {
                            print("User not found");
                          } else if (e.code == "wrong-password") {
                            print("Something else happer");
                            print(e.code);
                          }
                        } catch (e) {
                          print("something went wrong");
                          print(e);
                          print(e.runtimeType);
                        }
                      },
                    ),
                  ],
                );
              default:
                return const Text("Loading");
            }
          },
        ),
      ),
    );
  }
}
