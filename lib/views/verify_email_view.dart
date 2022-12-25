import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/router.dart';

class EmailVerifiedView extends StatefulWidget {
  const EmailVerifiedView({super.key});

  @override
  State<EmailVerifiedView> createState() => _EmailVerifiedViewState();
}

class _EmailVerifiedViewState extends State<EmailVerifiedView> {
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Column(
        children: [
          const Text(
              "We already send you email verification, if you haven't received, Please click Verify"),
          const Text("Please Verify Your Email Address"),
          // TextField(
          //   controller: _emailController,
          //   enableSuggestions: false,
          //   autocorrect: false,
          //   obscureText: true,
          //   decoration: const InputDecoration(
          //     hintText: "Verify Email",
          //   ),
          //   // autofillHints: "Email",
          // ),
          ElevatedButton(
            onPressed: () async {
              // final user = FirebaseAuth.instance.currentUser;
              var user = FirebaseAuth.instance.currentUser;

              await user!.sendEmailVerification();

              print(FirebaseAuth.instance.currentUser);

              if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(NotesRoute, (route) => false);
              }
            },
            child: const Text(
              "VERIFY EMAIL",
            ),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(RegisterRoute, (route) => false);
            },
            child: const Text(
              "Restart",
            ),
          ),
        ],
      ),
    );
  }
}
