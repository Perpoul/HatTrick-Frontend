import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hat_trick/pages/profile.dart';
import 'package:hat_trick/pages/store.dart';
import 'package:hat_trick/pages/targets.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGoogle = const CameraPosition(
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

  final pages = [
    Store(),
    Profile(),
    Targets(),
  ];

  @override
  Widget build(BuildContext context) {
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
      floatingActionButton: FloatingActionButton(onPressed: () async {
        getCurrentLocation().then((value) async {
          print(value.latitude.toString() + " " + value.longitude.toString());

          _markers.add(Marker(
            markerId: MarkerId("1"),
            position: LatLng(value.latitude, value.longitude),
            infoWindow: InfoWindow(
              title: "Current Location",
            ),
          ));

          CameraPosition cameraPosition = new CameraPosition(
            target: LatLng(value.latitude, value.longitude),
            zoom: 14,
          );

          final GoogleMapController controller = await _controller.future;
          controller
              .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
          setState(() {});
        });
      }),
      bottomNavigationBar: Container(
          height: 60,
          // ignore: prefer_const_constructors
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
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
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Profile()));
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
            ],
          )),
    );
  }
}
