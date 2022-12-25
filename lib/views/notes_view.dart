import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/router.dart';
import 'dart:developer' as devtool show log;

enum MenuAction { logout }

class MyNotesView extends StatefulWidget {
  const MyNotesView({super.key});

  @override
  State<MyNotesView> createState() => _MyNotesViewState();
}

class _MyNotesViewState extends State<MyNotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                devtool.log(value.toString());
                var shouldLogout = await showLogOutDialogue(context);
                if (shouldLogout) {
                  await FirebaseAuth.instance.signOut();

                  // DON'T use BuildContext across asynchronous gaps.
                  // Storing BuildContext for later usage can easily lead to difficult to diagnose crashes. Asynchronous gaps are implicitly storing BuildContext and are some of the easiest to overlook when writing code.
                  //When a BuildContext is used, its mounted property must be checked after an asynchronous gap.

                  //BAD:

                  //void onButtonTapped(BuildContext context) async {
                  //   await Future.delayed(const Duration(seconds: 1));
                  //   Navigator.of(context).pop();
                  // }

                  // GOOD:

                  // void onButtonTapped(BuildContext context) {
                  //   Navigator.of(context).pop();
                  // }

                  // GOOD:

                  // void onButtonTapped() async {
                  //   await Future.delayed(const Duration(seconds: 1));

                  //   if (!context.mounted) return;
                  //   Navigator.of(context).pop();
                  // }

                  // Helpul Link
                  //
                  // https://dart-lang.github.io/linter/lints/use_build_context_synchronously.html
                  //
                  //https://stackoverflow.com/questions/68871880/do-not-use-buildcontexts-across-async-gaps

                  if (!mounted) return;
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(LoginRoute, (route) => false);
                }

                break;
            }
          }, itemBuilder: (context) {
            return [
              const PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text(
                  "Logout",
                ),
              ),
            ];
          })
        ],
      ),
      body: Column(
        children: const [
          Center(
            child: Text(
              "My Notes",
            ),
          )
        ],
      ),
    );
  }
}

Future<bool> showLogOutDialogue(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure, you want to logout"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Yes")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("No")),
          ],
        );
      }).then((value) => value ?? false);
}
