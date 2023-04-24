import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hat_trick/pages/login.dart';
import 'package:hat_trick/pages/settings.dart';
import 'package:hat_trick/pages/store.dart';
import 'package:provider/provider.dart';

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
class PlayerModel extends ChangeNotifier{
  HatType _myHat = HatType.DEFAULT;
  Team _myTeam   = Team.NOT_YET_ASSIGNED;

  void don(HatType hatType){
    var oldHat = _myHat;
    _myHat = hatType;

    notifyListeners();
  }
  void doff(){
    _myHat = HatType.DEFAULT;

    notifyListeners();
  }

  void updateTeam(Team team){
    _myTeam = team;

    notifyListeners();
  }

  void addSkulls(int numSkulls) {

  }

  void removeSkulls(int numSkulls) {

  }
}


enum HatType{
  DEFAULT('assets/default.png', -80.0, 1.0),
  SHORT('assets/short.png', -70.0, 1.0),
  BANGS('assets/bangs.png', -50.0, 0.8),
  LONG('assets/long.png', -40, 1.0),
  DIMMEHAT('assets/dimmehat.png', -100.0, 1.0),
  TOP_HAT('assets/hat.png', -100.0, 1.0);

  const HatType(this.path, this.offsetY, this.scaleFactor);
  final String path;
  final double offsetY;
  final double scaleFactor;
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
                                  offset: Offset(0, hat._myHat.offsetY),
                                  child: Image.asset(hat._myHat.path)
                                )
                        ]),
                    ),
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
                  label: Text("100" + " Skulls"))),
        ])
    );
  }
}
