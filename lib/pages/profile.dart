import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hat_trick/pages/login.dart';
import 'package:hat_trick/pages/settings.dart';
import 'package:hat_trick/pages/store.dart';
import 'package:provider/provider.dart';

import 'homePage.dart';

class Profile extends StatefulWidget {
  final User user;
  const Profile({required this.user});


  @override
  _ProfileState createState() => _ProfileState();
}
enum Team{
  NOT_YET_ASSIGNED,
  RED,
  BLUE,
  GREEN;
}
class PlayerModel extends ChangeNotifier {
  HatType equippedHat = HatType.defaultHat;
  Team _myTeam = Team.NOT_YET_ASSIGNED;
  Set<HatType> ownedHats = <HatType>{
    HatType.defaultHat
  };
  int skulls = 1000;

  List<OtherPlayer> nearbyPlayers = [];

  void buyIfNotOwned(HatType hat) {
    if (ownedHats.contains(hat)) {
      _don(hat);
    }
    else if (skulls >= hat.cost) {
      ownedHats.add(hat);
      skulls = skulls - hat.cost;
      _don(hat);
    } else {
      //do something
    }
  }

  void _don(HatType hatType) {
    if (ownedHats.contains(hatType)) {
      equippedHat = hatType;
    }

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

  void addSkulls(int numSkulls) {

  }

  void removeSkulls(int numSkulls) {

  }

  void updateNearbyPlayers(UpdateData updateData){
    nearbyPlayers = updateData.otherPlayers;

    notifyListeners();
  }
}


enum HatType{
  defaultHat('assets/default.png', 0, -80.0, 100),
  shortHair('assets/short.png', 300, -70.0, 100),
  bangsHair('assets/bangs.png', 500, -50.0, 90),
  longHair('assets/long.png', 700, -40, 90),
  dimmehat('assets/dimmehat.png', 1000, -100.0, 100),
  topHat('assets/hat.png', 3000, -100.0, 106);

  const HatType(this.path, this.cost, this.offsetY, this.width);
  final String path;
  final int cost;
  final double offsetY;
  final double width;

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
          Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child:
                  CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 221, 221, 221),
                    radius: 100,
                    child: Consumer<PlayerModel> (
                        builder: (context, hat, child) => Stack(
                            children:[
                              Image.asset("assets/BasicProfilePic.png"),
                              Transform.translate(
                                offset: Offset(0, hat.equippedHat.offsetY),
                                child: Image.asset(hat.equippedHat.path)
                              )
                            ]
                        ),
                    ),
                )
              )
            ),
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
                  TextSpan(text: "Red", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red
                  )),
                ],
              ),
            )
          ),
          Center(
              child: Consumer<PlayerModel> (
                builder: (context, player, child) =>
                  ElevatedButton.icon(
                    onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Store()));
                    },
                    icon: Icon(
                      Icons.attach_money,
                      size: 30,
                    ),
                    label: Text("${player.skulls} Skulls")
                  )
                ),
          )
        ]
        )
    );
  }
}
