import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hat_trick/pages/login.dart';
import 'package:hat_trick/pages/profile.dart';
import 'package:hat_trick/pages/store.dart';
import 'package:hat_trick/pages/targets.dart';
import 'package:geolocator/geolocator.dart';

import '../firebase/fire_auth.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User currentUser;

  @override
  void initState() {
    currentUser = widget.user;
    super.initState();
  }

  Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(41.50252, -81.6082075),
    zoom: 14.4746,
  );

  Future<Position> getCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  final List<Marker> _markers = <Marker>[];

  int pageIndex = 0;

  // final pages = [
  //   Store(),
  //   Profile(user: currentUser),
  //   Targets(),
  // ];

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: GoogleMap(
            initialCameraPosition: _kGoogle,
            mapType: MapType.normal,
            myLocationEnabled: true,
            compassEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
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
          // ignore: prefer_const_constructors
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(1),
              topRight: Radius.circular(1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Store()));
                },
                icon: const Icon(
                  Icons.local_convenience_store_rounded,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Profile(user: currentUser)));
                },
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Targets()));
                },
                icon: const Icon(
                  Icons.view_list,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  onPressed: () async {
                    await FireAuth.signOut(context: context);
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text("Sign Out"))
            ],
          )),
    );
  }
}
