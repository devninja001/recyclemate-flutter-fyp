// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screens/login/signup/login.dart';

class LogOutPrompt extends StatelessWidget {
  const LogOutPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(
            Icons.logout_rounded,
            color: Colors.black,
            size: 40,
          ),
          iconColor: Colors.black,
          alignment: Alignment.center,
          content: const Text("Do you want to log out?"),
          contentTextStyle: const TextStyle(fontSize: 18, color: Colors.black),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "No",
                  style: TextStyle(color: Colors.black),
                )),
            TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()));
                  });
                },
                child: const Text("Yes", style: TextStyle(color: Colors.red)))
          ],
        ),
      ),
      icon: const Icon(
        Icons.logout_outlined,
        color: Colors.black,
      ),
    );
  }
}
