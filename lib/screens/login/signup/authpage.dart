import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp/reusable/bottomnavibar.dart';
import 'package:fyp/screens/login/signup/login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            welcomeToast();

            return const NavigationMenu();
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }

  void welcomeToast() {
    if (user.displayName != null) {
      Fluttertoast.showToast(msg: 'Welcome ${user.displayName}!');
    } else {
      Fluttertoast.showToast(msg: 'Welcome!');
    }

    Fluttertoast.cancel;
  }
}

signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn().signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);
      await FirebaseAuth.instance.signInWithCredential(authCredential);
    }
  } on FirebaseAuthException catch (e) {
    String msg = e.message.toString();
    Fluttertoast.showToast(msg: msg);
  } on PlatformException catch (e) {
    String msg = e.message.toString();
    Fluttertoast.showToast(msg: msg);
  }
}
