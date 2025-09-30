import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/reusable/colors_util.dart';
import 'package:fyp/reusable/reusable_widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Reset Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("99d578"),
          hexStringToColor("71cc49"),
          hexStringToColor("207b25"),
          hexStringToColor("043b05"),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.15,
                left: 20,
                right: 20),
            child: Column(
              children: <Widget>[
                logoWidget("asset/image/RecycleMate Logo.png"),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Enter Email Address", Icons.email_outlined,
                    false, _emailTextController),
                const SizedBox(
                  height: 15,
                ),
                firebaseButton(
                  context,
                  "Reset Password",
                  () {
                    FirebaseAuth.instance
                        .sendPasswordResetEmail(
                            email: _emailTextController.text.trim())
                        .then((value) {
                      Navigator.of(context).pop();
                    }).onError(
                      (error, stackTrace) {
                        print("Error ${error.toString()}");
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }
}
