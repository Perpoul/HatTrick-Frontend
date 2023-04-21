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
          const Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 221, 221, 221),
                radius: 100,
                backgroundImage: AssetImage("assets/BasicProfilePic.png")
              )
            )
          ),
          Center(
              child: Text("Welcome, ${currentUser.displayName}",
                  style: TextStyle(fontSize: 30))),
          Padding(
            padding: EdgeInsets.all(10),
            child: RichText(
              text: const TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(text: "Today's Team: "),
                  TextSpan(text: "Red", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red
                  )),
                ],
              ),
            )
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
