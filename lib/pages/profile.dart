import 'package:flutter/material.dart';
import 'package:hat_trick/pages/store.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: Column(children: <Widget>[
          Center(child: Icon(Icons.person, size: 200)),
          Center(child: Text("user", style: TextStyle(fontSize: 30))),
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
                  label: Text("1000")))
        ]));
  }
}
