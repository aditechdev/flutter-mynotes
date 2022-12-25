import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/router.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        LoginRoute: (context) => const LoginView(),
        NotesRoute: (context) => const MyNotesView(),
        RegisterRoute: (context) => const RegisterView(),
        EmailViewRoute: (context) => const EmailVerifiedView()
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            // final user = FirebaseAuth.instance.currentUser;
            // print(user);

            // // if (user != null) {
            // final emailVerified = user?.emailVerified ?? false;
            // if (emailVerified) {
            //   print("You are verified User");
            //   return const Text("done");
            //   // return const MyNotesView();
            // } else {
            //   print("You are not Verified");
            //   return const EmailVerifiedView();
            //   // Navigator.of(context).pushNamed(EmailViewRoute);
            //   // return const EmailVerifiedView();
            // }
            return const LoginView();

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
