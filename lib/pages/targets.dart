import 'package:flutter/material.dart';

class Targets extends StatefulWidget {
  @override
  _TargetsState createState() => _TargetsState();
}

class _TargetsState extends State<Targets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Targets"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Container(
            height: 50,
            color: Colors.green[600],
            child: const Center(child: Text('Target A')),
          ),
          Container(
            height: 50,
            color: Colors.green[500],
            child: const Center(child: Text('Target B')),
          ),
          Container(
            height: 50,
            color: Colors.green[400],
            child: const Center(child: Text('Target C')),
          ),
        ],
      ),
    );
  }
}
