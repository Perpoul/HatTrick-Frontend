import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hat_trick/pages/login.dart';
import 'package:hat_trick/pages/settings.dart';
import 'package:hat_trick/pages/store.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'homePage.dart';
import 'leaderboard.dart';

class Profile extends StatefulWidget {
  final User user;
  const Profile({required this.user});

  @override
  _ProfileState createState() => _ProfileState();
}

enum Team {
  red(BitmapDescriptor.hueGreen),
  green(BitmapDescriptor.hueRed),
  blue(BitmapDescriptor.hueBlue),
  notYetAssigned(BitmapDescriptor.hueYellow);

  final double color;

  const Team(this.color);

  static Team from(String team) {
    if (team == 'green') return green;
    if (team == 'red') return red;
    if (team == 'blue') return blue;
    throw Exception("Invalid Team $team");
  }
}

class PlayerModel extends ChangeNotifier {
  late User currentUser;
  HatType equippedHat = HatType.defaultHat;
  Team _myTeam = Team.notYetAssigned;
  Set<HatType> ownedHats = <HatType>{HatType.defaultHat};
  int skulls = -1;
  bool alive = true;

  List<OtherPlayer> nearbyPlayers = [];
  void loadDataFromFirebase() async {
    print("Loading Data");
    final response = await http.get(
      Uri.parse(
          'https://us-central1-hat-trick-1afd3.cloudfunctions.net/api/initial-data'),
      headers: {
        'token': await currentUser.getIdToken(),
        'content-type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      Map<String, dynamic> playerInfo = json["myPlayer"];
      _myTeam = Team.from(playerInfo['color']);
      skulls = playerInfo['totalCurrency'];
      ownedHats = <HatType>{};
      List<String> ownedItems = List<String>.from(playerInfo['myItems']);
      ownedHats.add(HatType.defaultHat);
      for (String hat in ownedItems) {
        ownedHats.add(HatType.from(hat));
      }
      alive = playerInfo['isAlive'];
      equippedHat = HatType.from(playerInfo['equippedItem']);
      _don(equippedHat);
    } else {
      throw Exception("Could not reach firebase, will try again");
    }

    notifyListeners();
  }

  void buyIfNotOwned(HatType hat) async {
    if (ownedHats.contains(hat)) {
      _don(hat);
    } else if (skulls >= hat.cost) {
      final response = await http.post(
          Uri.parse(
              'https://us-central1-hat-trick-1afd3.cloudfunctions.net/api/buy-shop-item?item=${hat.shortName}'),
          headers: {
            'token': await currentUser.getIdToken(),
            'content-type': 'application/json'
          },
          body: jsonEncode(<String, String>{'item': hat.shortName}));
      if (response.statusCode == 200) {
        //ownedHats.add(hat);
        //skulls = skulls - hat.cost;
        loadDataFromFirebase();
        _don(hat);
      }
    } else {
      //do something
    }
    notifyListeners();
    //pushUpdatedPlayerDetailsToFirebase();
  }

  void _don(HatType hatType) async {
    if (ownedHats.contains(hatType)) {
      equippedHat = hatType;
    }
    final response = await http.post(
        Uri.parse(
            'https://us-central1-hat-trick-1afd3.cloudfunctions.net/api/equip-item?item=${equippedHat.shortName}'),
        headers: {
          'token': await currentUser.getIdToken(),
          'content-type': 'application/json'
        },
        body: jsonEncode(<String, String>{'shopItem': equippedHat.shortName}));

    notifyListeners();
  }

  void doff() {
    equippedHat = HatType.defaultHat;

    notifyListeners();
  }

  void updateTeam(Team team) {
    _myTeam = team;

    notifyListeners();
  }

  void addSkulls(int numSkulls) {}

  void removeSkulls(int numSkulls) {}

  void updateNearbyPlayers(UpdateData updateData) {
    nearbyPlayers = updateData.otherPlayers;

    notifyListeners();
  }
}

enum HatType {
  defaultHat('assets/default.png', 'default', 0, -80.0, 100),
  short('assets/short.png', 'short', 300, -70.0, 100),
  bangs('assets/bangs.png', 'bangs', 500, -50.0, 90),
  long('assets/long.png', 'long', 700, -40, 90),
  dimmehat('assets/dimmehat.png', 'dimmehat', 1000, -100.0, 100),
  hat('assets/hat.png', 'hat', 3000, -100.0, 106);

  const HatType(this.path, this.shortName, this.cost, this.offsetY, this.width);
  final String path;
  final String shortName;
  final int cost;
  final double offsetY;
  final double width;

  static HatType from(String hat) {
    switch (hat) {
      case 'short':
        return HatType.short;
      case 'long':
        return HatType.long;
      case 'bangs':
        return HatType.bangs;
      case 'dimmehat':
        return HatType.dimmehat;
      case 'hat':
        return HatType.hat;
      default:
        return HatType.defaultHat;
    }
  }
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
          title: const Text("Profile"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Settings()));
                },
                icon: const Icon(Icons.settings))
          ],
        ),
        body: Column(children: <Widget>[
          Center(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 221, 221, 221),
                    radius: 100,
                    child: Consumer<PlayerModel>(
                      builder: (context, hat, child) => Stack(children: [
                        Image.asset("assets/BasicProfilePic.png"),
                        Transform.translate(
                            offset: Offset(0, hat.equippedHat.offsetY),
                            child: Image.asset(hat.equippedHat.path))
                      ]),
                    ),
                  ))),
          Center(
              child: Text("Welcome, ${currentUser.displayName}",
                  style: const TextStyle(fontSize: 30))),
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
                    TextSpan(
                        text: "Red",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                  ],
                ),
              )),
          Column(children: [
            Consumer<PlayerModel>(
                builder: (context, player, child) => ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Store()));
                    },
                    icon: Icon(
                      Icons.attach_money,
                      size: 30,
                    ),
                    label: Text("${player.skulls} Skulls"))),
            Consumer<PlayerModel>(
                builder: (context, player, child) => ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Leaderboard()));
                    },
                    child: Text("View Leaderboard"))),
          ])
        ]));
  }
}
