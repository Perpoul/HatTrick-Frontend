import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hat_trick/pages/profile.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  //this string should be the actual players -- sorted by number of skulls (?)
  List<String> topPlayers = [];
  Future<void> getLeaderboardData(BuildContext context) async {
    if (!context.mounted) throw Exception("Ignore me pls");
    final response = await http.get(
        Uri.parse(
            "https://us-central1-hat-trick-1afd3.cloudfunctions.net/api/leaderboard"),
        headers: {
          'token': await Provider.of<PlayerModel>(context, listen: false)
              .currentUser
              .getIdToken(),
          'content-type': 'application/json'
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> _topPlayers = json['topPlayers'];
      setState(() {
        topPlayers = [];
        for (Map<String, dynamic> player in _topPlayers) {
          topPlayers.add(
              "Player: ${player['name']} | Kills : ${player['totalKills']}");
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getLeaderboardData(context);
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      await getLeaderboardData(context);
    });
  }

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
              child:
                  Text("${i + 1}. ${players[i]}", textAlign: TextAlign.left))));
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
          getPlayers(topPlayers)
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
