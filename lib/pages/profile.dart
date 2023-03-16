import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hat_trick/pages/login.dart';
import 'package:hat_trick/pages/settings.dart';
import 'package:hat_trick/pages/store.dart';

class Profile extends StatefulWidget {
  final User user;
  const Profile({required this.user});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late User currentUser;

  @override
  void initState() {
    currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Settings()));
                },
                icon: Icon(Icons.settings))
          ],
        ),
        body: Column(children: <Widget>[
          Center(child: Icon(Icons.person, size: 200)),
          Center(
              child: Text("Welcome, ${currentUser.displayName}",
                  style: TextStyle(fontSize: 30))),
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(
                child: Text("Team: (Red/Blue/Green)",
                    style: TextStyle(fontSize: 20))),
          ),
          Center(
              child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Store()));
                  },
                  icon: Icon(
                    Icons.attach_money,
                    size: 30,
                  ),
                  label: Text("1000" + " Heads"))),
        ]));
  }
}
