import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

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
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
