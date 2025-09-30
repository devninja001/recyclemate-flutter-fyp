import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:fyp/reusable/reusable_widgets.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) => SimpleSettingsTile(
        title: "Account Settings",
        subtitle: 'Privacy, Security, Language',
        leading: const IconWidget(icon: Icons.person, color: Colors.green),
        child: SettingsScreen(
          title: 'Account Settings',
          children: [
            buildLanguage(),
            buildLocation(),
            buildPassword(),
            buildPrivacy(context),
            buildSecurity(context),
            buildAccountInfo(context)
          ],
        ),
      );
}

Widget buildPrivacy(BuildContext context) => SimpleSettingsTile(
      leading: const IconWidget(icon: Icons.lock, color: Colors.blue),
      title: 'Privacy',
      subtitle: "",
      onTap: () {},
    );

Widget buildSecurity(BuildContext context) => SimpleSettingsTile(
      leading: const IconWidget(icon: Icons.security, color: Colors.red),
      title: 'Security',
      subtitle: "",
      onTap: () {},
    );

Widget buildAccountInfo(BuildContext context) => SimpleSettingsTile(
      leading: const IconWidget(icon: Icons.text_snippet, color: Colors.purple),
      title: 'Account Info',
      subtitle: "",
      onTap: () {},
    );

Widget buildLanguage() => DropDownSettingsTile(
      title: 'Language',
      settingKey: 'key-language',
      selected: 1,
      values: const <int, String>{
        1: 'English',
        2: 'Bahasa Malaysia',
        3: 'Chinese',
      },
      onChange: (language) {},
    );

Widget buildLocation() => TextInputSettingsTile(
      title: "Location",
      settingKey: "key-location",
      initialValue: "Malaysia",
      onChange: (location) {},
    );

Widget buildPassword() => TextInputSettingsTile(
      title: 'Password',
      settingKey: 'key-user-password',
      obscureText: true,
      validator: (password) => password != null && password.length >= 8
          ? null
          : 'Enter 8 characters',
    );
