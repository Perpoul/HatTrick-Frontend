import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hat_trick/pages/profile.dart';
import 'package:hat_trick/pages/store.dart';
import 'package:hat_trick/pages/targets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../firebase/fire_auth.dart';
import 'package:http/http.dart' as http;

class UpdateData {
  final Player myPlayer;
  final List<OtherPlayer> otherPlayers;

  const UpdateData({required this.myPlayer, required this.otherPlayers});

  factory UpdateData.fromJson(Position myPosition, Map<String, dynamic> json) {
    List<OtherPlayer> otherPlayers = [];
    Map<String, dynamic> otherPlayersJson =
        Map<String, dynamic>.from(json['otherPlayers'] as Map);
    for (MapEntry<String, dynamic> otherPlayerEntry
        in otherPlayersJson.entries) {
      otherPlayers.add(OtherPlayer(
          id: otherPlayerEntry.key,
          location: LatLng(otherPlayerEntry.value['loc']['lat'],
              otherPlayerEntry.value['loc']['lon']),
          team: Team.from(otherPlayerEntry.value['color']),
          distance: otherPlayerEntry.value['distance']));
    }

    return UpdateData(
      myPlayer: Player(
          id: json['myPlayer']['id'],
          location: LatLng(myPosition.latitude, myPosition.longitude),
          team: Team.from(json['myPlayer']['color']),
          isDead: json['myPlayer']['killed'] ?? false),
      otherPlayers: otherPlayers,
    );
  }
}

class Player {
  final String id;
  final LatLng location;
  final Team team;
  final bool isDead;
  const Player(
      {required this.id,
      required this.location,
      required this.team,
      required this.isDead});
}

class OtherPlayer extends Player {
  final double distance;

  const OtherPlayer(
      {required this.distance,
      required super.id,
      required super.location,
      required super.team,
      super.isDead = false});
}

enum Team {
  red(BitmapDescriptor.hueRed, 'Red', Colors.red),
  green(BitmapDescriptor.hueGreen, 'Green', Colors.green),
  blue(BitmapDescriptor.hueBlue, 'Blue', Colors.blue),
  notYetAssigned(BitmapDescriptor.hueYellow, 'Green', Colors.yellow);

  final double color;
  final String shortName;
  final Color teamColor;
  const Team(this.color, this.shortName, this.teamColor);

  static Team from(String team) {
    if (team == 'green') return green;
    if (team == 'red') return red;
    if (team == 'blue') return blue;
    return Team.notYetAssigned;
  }

  String pathToAvatar() {
    return "assets/BasicProfilePic_$shortName.png";
  }

  String pathToMarkerIcon() {
    return 'assets/$shortName.png';
  }
}

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User currentUser;
  final Set<Marker> _markers = {};
  bool dataIsLoaded = false;
  @override
  void initState() {
    currentUser = widget.user;
    Provider.of<PlayerModel>(context, listen: false).currentUser = currentUser;
    super.initState();

    update();
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      await update();
    });
  }

  Future update() async {
    // Send an update request to the backend and wait for it to complete:
    UpdateData updateData = await updateBackend();
    if (!context.mounted) return;
    Provider.of<PlayerModel>(context, listen: false).alive =
        !updateData.myPlayer.isDead;

    // Refresh all the player visuals based off the update response player data:
    _markers.clear();
    Position position = await getCurrentLocation();

    setState(() {
      _markers.add(Marker(
        markerId: const MarkerId('player'),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      ));
    });
    for (OtherPlayer otherPlayer in updateData.otherPlayers) {
      BitmapDescriptor bitmap = BitmapDescriptor.fromBytes(
          (await rootBundle.load(otherPlayer.team.pathToMarkerIcon()))
              .buffer
              .asUint8List(),
          size: Size(128, 128));
      setState(() => _markers.add(Marker(
            markerId: MarkerId(otherPlayer.id),
            position: LatLng(
                otherPlayer.location.latitude, otherPlayer.location.longitude),
            icon: bitmap,
            onTap: () => kill(otherPlayer.id),
          )));
      print("markers updated");
    }
  }

  /// Updates the backend with this player's position and responds with all nearby player data, updating visuals on the map.
  Future<UpdateData> updateBackend() async {
    Position myPosition = await getCurrentLocation();
    final response = await http.post(
      Uri.parse(
          'https://us-central1-hat-trick-1afd3.cloudfunctions.net/api/update'),
      headers: {
        'token': await currentUser.getIdToken(),
        'content-type': 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        'myLocation': <String, double>{
          'lat': myPosition.latitude,
          'lon': myPosition.longitude
        },
      }),
    );

    if (response.statusCode == 200) {
      return UpdateData.fromJson(myPosition, jsonDecode(response.body));
    } else {
      throw Exception('Failed to update with backend');
    }
  }

  Future<String> kill(String targetId) async {
    final response = await http.post(
        Uri.parse(
            'https://us-central1-hat-trick-1afd3.cloudfunctions.net/api/kill-player'),
        headers: {
          'token': await currentUser.getIdToken(),
          'content-type': 'application/json'
        },
        body: jsonEncode(<String, String>{"targetPlayerId": targetId}));
    if (response.statusCode == 200) {
      print(response.body);
      update();
      return "";
    } else {
      throw Exception("Failed to connect to server");
    }
  }

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(41.50252, -81.6082075),
    zoom: 15.4746,
  );

  Future<Position> getCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      //print("ERROR: $error");
    });
    return await Geolocator.getCurrentPosition();
  }

  void onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    Position position = await getCurrentLocation();
    CameraPosition newPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14.0,
    );
    setState(() {
      _markers.add(Marker(
        markerId: const MarkerId('player'),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      ));
    });
    controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  void loadDataIfNotAlreadyLoaded() {
    if (!dataIsLoaded) {
      Provider.of<PlayerModel>(context, listen: false).loadDataFromFirebase();
      dataIsLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    loadDataIfNotAlreadyLoaded();
    Timer.periodic(const Duration(seconds: 5 * 60), (timer) async {
      Provider.of<PlayerModel>(context, listen: false).loadDataFromFirebase();
    });
    final screen = MediaQuery.of(context).size;
    final navBarIconSize = screen.height * .045;
    //final navBarHeight = screen.height * .08;
    return Scaffold(
      body: Container(
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Consumer<PlayerModel>(builder: ((context, value, child) {
              if (value.alive) {
                return Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: _kGoogle,
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      compassEnabled: true,
                      onMapCreated: onMapCreated,
                      markers: _markers,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            height: MediaQuery.of(context).padding.top,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                    child: Text(
                  "YOU ARE DEAD LOL",
                  textAlign: TextAlign.center,
                ));
              }
            })),
          ),
        ),
      ),

      // floatingActionButton: FloatingActionButton(onPressed: () async {
      //   getCurrentLocation().then((value) async {
      //     print(value.latitude.toString() + " " + value.longitude.toString());

      //     _markers.add(Marker(
      //       markerId: MarkerId("1"),
      //       position: LatLng(value.latitude, value.longitude),
      //       infoWindow: InfoWindow(
      //         title: "Current Location",
      //       ),
      //     ));

      //     CameraPosition cameraPosition = new CameraPosition(
      //       target: LatLng(value.latitude, value.longitude),
      //       zoom: 14,
      //     );

      //     final GoogleMapController controller = await _controller.future;
      //     controller
      //         .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      //   });
      // }),
      bottomNavigationBar: Container(
          height: screen.height * .08,
          padding: EdgeInsets.only(bottom: screen.height * .02),
          // ignore: prefer_const_constructors
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
          ),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Store()));
                  },
                  icon: Icon(
                    Icons.local_convenience_store_outlined,
                    color: Colors.white,
                    size: navBarIconSize,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Profile(user: currentUser)));
                  },
                  icon: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: navBarIconSize,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Targets()));
                  },
                  icon: Icon(
                    Icons.view_list_outlined,
                    color: Colors.white,
                    size: navBarIconSize,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
