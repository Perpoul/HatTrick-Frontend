import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hat_trick/pages/login.dart';
import 'package:hat_trick/misc/utils.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(children: [
        ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Sign out"),
            subtitle: const Text("Log out of your account"),
            onTap: () {
              Utils.showConfirmationDialog(
                  context, 'Are you sure you want to sign out?', () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                  (route) => false,
                );
              });
            }),
      ]),
    );
  }
}
