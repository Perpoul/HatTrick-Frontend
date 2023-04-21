import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hat_trick/pages/login.dart';
import 'package:hat_trick/pages/profile.dart';
import 'package:hat_trick/pages/store.dart';
import 'package:hat_trick/pages/targets.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui';

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
    zoom: 15.4746,
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

  void onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    Position position = await getCurrentLocation();
    CameraPosition newPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14.0,
    );
    _markers.add( Marker(
      markerId: MarkerId('player'),
      position: LatLng(position.latitude, position.longitude),

      )
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  final Set<Marker> _markers = {};

  int pageIndex = 0;

  // final pages = [
  //   Store(),
  //   Profile(user: currentUser),
  //   Targets(),
  // ];

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final navBarIconSize = screen.height * .045;
    final navBarHeight = screen.height * .08;
    return Scaffold(
      body: Container(
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
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
            ),
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
