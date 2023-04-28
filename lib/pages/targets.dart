import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hat_trick/pages/homePage.dart';
import 'package:hat_trick/pages/profile.dart';
import 'package:provider/provider.dart';

import '../widgets/target_types.dart';
import 'dart:math';

class Targets extends StatefulWidget {
  @override
  _TargetsState createState() => _TargetsState();
}

TargetType getTargets(Team team) {
  switch (team) {
    case Team.blue:
      return TargetType(
          title: "Red Hats",
          color: Colors.red,
          currentNumberKilled: 0,
          content: "Kill as many players with red hats as possible.");
    case Team.green:
      return TargetType(
          title: "Blue Team",
          color: Colors.blue.shade800,
          currentNumberKilled: 0,
          content: "Kill as many players with blue hats as possible.");
    case Team.red:
    default:
      return TargetType(
          title: "Green Hats",
          color: Colors.green,
          currentNumberKilled: 0,
          content: "Kill as many players with green hats as possible.");
  }
}

Container makeBody(TargetType target) => Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (BuildContext, int index) {
          return makeCard(target);
        },
      ),
    );

Card makeCard(TargetType target) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: target.color),
        child: makeListTile(target),
      ),
    );

class _TargetPageState extends State<Targets> {
  //List targets = getTargets();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

ListTile makeListTile(TargetType target) => ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Icon(Icons.autorenew, color: Colors.white),
      ),
      title: Text(
        target.title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );

class _TargetsState extends State<Targets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Targets"),
      ),
      body: makeBody(getTargets(Provider.of<PlayerModel>(context).myTeam)),
      // body: ListView(
      //   padding: const EdgeInsets.all(8),
      //   children: <Widget>[
      //     Container(
      //       height: 50,
      //       color: Colors.green[600],
      //       child: const Center(child: Text('Target A')),
      //     ),
      //     Container(
      //       height: 50,
      //       color: Colors.green[500],
      //       child: const Center(child: Text('Target B')),
      //     ),
      //     Container(
      //       height: 50,
      //       color: Colors.green[400],
      //       child: const Center(child: Text('Target C')),
      //     ),
      //   ],
      // ),
    );
  }
}
