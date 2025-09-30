// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp/reusable/colors_util.dart';
import 'package:fyp/reusable/reusable_widgets.dart';
import 'package:fyp/screens/login/signup/authpage.dart';
import 'package:fyp/screens/login/signup/resetpassword.dart';
import 'package:fyp/screens/login/signup/signup.dart';
import 'package:permission_handler/permission_handler.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

final user = FirebaseAuth.instance.currentUser!;

class _SignInScreenState extends State<SignInScreen> {
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor("99d578"),
            hexStringToColor("71cc49"),
            hexStringToColor("207b25"),
            hexStringToColor("043b05"),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.13, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("asset/image/RecycleMate Logo.png"),
                const Text(
                  "Welcome back! You've been missed!",
                  style: TextStyle(color: Colors.black87, fontSize: 18),
                ),
                const SizedBox(
                  height: 40,
                ),
                reusableTextField("Enter Email", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 2,
                ),
                forgetPassword(
                  context,
                ),
                firebaseButton(
                  context,
                  "Sign in",
                  () {
                    signinUser();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.white70,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "or continue with:",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    signInWithGoogle();
                  },
                  icon: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "asset/image/google.png",
                          height: 60,
                          width: 60,
                        ),
                      ],
                    ),
                  ),
                ),
                signUpOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ResetPasswordScreen()));
          },
          child: const Text(
            "Forgot password?",
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.right,
          )),
    );
  }

  signinUser() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailTextController.text.trim(),
          password: _passwordTextController.text.trim());
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'No user found for that email!');
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'You have entered wrong password!');
      }
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }
}

void _checkPermissions() async {
  PermissionStatus status = await Permission.location.status;
  if (status != PermissionStatus.granted) {
    await Permission.location.request();
  }
}
