import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  //this string should be the actual players -- sorted by number of skulls (?)
  List<String> allPlayers = [
    'player 1',
    'player 2',
    'player 3',
    'player 4',
    'player 5'
  ];

  Color? getColor(int ranking) {
    if (ranking == 0) {
      return Colors.amber[300];
    } else if (ranking == 1) {
      return Colors.grey[300];
    } else if (ranking == 2) {
      return Colors.brown[200];
    } else {
      return Colors.white;
    }
  }

  Widget getPlayers(List<String> players) {
    List<Container> ranking = <Container>[];
    for (var i = 0; i < players.length; i++) {
      ranking.add(Container(
          height: 50,
          color: getColor(i),
          child: Center(
              child: Text((i + 1).toString() + ". " + players[i],
                  textAlign: TextAlign.left))));
    }
    return new Column(children: ranking);
  }

  final currentNumberOfPlayers = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Leaderboard"),
        ),
        body: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
          getPlayers(allPlayers)
          // Container(
          //     height: 50,
          //     color: Colors.amber[300],
          //     child: const Center(child: Text('1: player 1 (1000 skulls)'))),
          // Container(
          //     height: 50,
          //     color: Colors.grey[300],
          //     child: const Center(child: Text('2: player 2 (800 skulls)'))),
          // Container(
          //     height: 50,
          //     color: Colors.brown[200],
          //     child: const Center(child: Text('3: player 3 (500 skulls)'))),
          // Container(
          //     height: 50,
          //     color: Colors.white,
          //     child: const Center(child: Text('4: player 4 (100 skulls)'))),
        ]));
  }
}
