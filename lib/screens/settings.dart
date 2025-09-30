// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:fyp/reusable/logoutprompt.dart';
import 'package:fyp/reusable/reusable_widgets.dart';
import 'package:fyp/reusable/accountpage.dart';
import 'package:fyp/screens/login/signup/login.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

final User? user = FirebaseAuth.instance.currentUser;

var keydarkmode = 'key-dark-mode';

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Settings",
        ),
        backgroundColor: const Color(0xFF99d578),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              children: [
                Image.network(
                  "${user?.photoURL}",
                  scale: 2.0,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.displayName ?? ''),
                    Text(user?.email ?? ''),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(color: Colors.black87, height: 1),
            buildDarkMode(),
            SettingsGroup(
              title: "GENERAL",
              children: <Widget>[
                AccountPage(),
                SizedBox(
                  height: 5,
                ),
                buildLogout(),
                SizedBox(
                  height: 5,
                ),
                buildDeleteAccount(),
              ],
            ),
            const SizedBox(
              height: 26,
            ),
            SettingsGroup(title: "FEEDBACK", children: <Widget>[
              const SizedBox(
                height: 8,
              ),
              buildReportBug(context),
              SizedBox(
                height: 5,
              ),
              buildSendFeedback(context),
            ])
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildLogout() => SimpleSettingsTile(
        leading: const IconWidget(
            icon: Icons.logout_outlined, color: Colors.blueAccent),
        title: 'Logout',
        subtitle: "",
        onTap: () {
          showDialog(
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
              contentTextStyle:
                  const TextStyle(fontSize: 18, color: Colors.black),
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
                    child:
                        const Text("Yes", style: TextStyle(color: Colors.red)))
              ],
            ),
          );
        },
      );

  Widget buildDeleteAccount() => SimpleSettingsTile(
        leading:
            const IconWidget(icon: Icons.delete_outline, color: Colors.pink),
        title: 'Delete Account',
        subtitle: "",
        onTap: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.black,
                size: 40,
              ),
              iconColor: Colors.black,
              alignment: Alignment.center,
              content: const Text(
                  "Are you sure you want to delete your account?\nThis action is irreversible!"),
              contentTextStyle:
                  const TextStyle(fontSize: 18, color: Colors.black),
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
                      FirebaseAuth.instance.currentUser?.delete().then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()));
                      });
                    },
                    child:
                        const Text("Yes", style: TextStyle(color: Colors.red)))
              ],
            ),
          );
        },
      );
}

Widget buildDarkMode() {
  return SwitchSettingsTile(
    title: 'Dark Mode',
    settingKey: keydarkmode,
    leading: const IconWidget(icon: Icons.dark_mode, color: Colors.pink),
    onChange: (isDarkMode) {},
  );
}

Widget buildReportBug(BuildContext context) => SimpleSettingsTile(
      leading:
          const IconWidget(icon: Icons.bug_report_outlined, color: Colors.teal),
      title: 'Report A Bug',
      subtitle: "",
      onTap: () {},
    );

Widget buildSendFeedback(BuildContext context) => SimpleSettingsTile(
      leading: const IconWidget(
          icon: Icons.thumb_up_alt_outlined, color: Colors.purple),
      title: 'Send Feedback',
      subtitle: "",
      onTap: () {},
    );
