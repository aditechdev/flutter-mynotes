import 'package:flutter/material.dart';
import 'package:mynotes/constants/router.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        LoginRoute: (context) => const LoginView(),
        RegisterRoute: (context) => const RegisterView(),
        EmailViewRoute: (context) => const EmailVerifiedView(),
        NotesRoute: (context) => const MyNotesView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            print("user $user");

            if (user != null) {
              final emailVerified = user.isEmailVerified;
              if (emailVerified) {
                print("You are verified User");
                return const MyNotesView();
              } else {
                return const EmailVerifiedView();
              }
            } else {
              return const LoginView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
