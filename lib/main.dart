import 'package:flutter/material.dart';
import 'package:hat_trick/pages/profile.dart';
import 'package:hat_trick/pages/store.dart';
import 'package:hat_trick/pages/targets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hat Trick',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(
      41.50252, -81.6082075); //i just have these set for case right now

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  int pageIndex = 0;

  final pages = [
    Store(),
    Profile(),
    Targets(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.end,
        // children: [
        //   Align(
        //       alignment: Alignment.topRight,
        //       child: ElevatedButton.icon(
        //         onPressed: () {},
        //         style: ElevatedButton.styleFrom(
        //           primary: Colors.transparent,
        //         ),
        //         icon:
        //             Icon(Icons.attach_money, color: Colors.black, size: 35),
        //         label: Text('100000'),
        //       ))
        // ]),
      ),
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

// class Store extends StatelessWidget {
//   const Store({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Store"),
//       ),
//       body: GridView.count(
//           crossAxisCount: 3,
//           children: List.generate(21, (index) {
//             return Center(
//                 child: Text(
//               'Item $index',
//               style: Theme.of(context).textTheme.headlineSmall,
//             ));
//           })),
//     );
//   }
// }

// class Profile extends StatelessWidget {
//   const Profile({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Profile"),
//       ),
//     );
//   }
// }

// class Targets extends StatelessWidget {
//   const Targets({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: const Color(0xffC4DFCB),
//       child: Center(
//         child: Text(
//           "Targets",
//           style: TextStyle(
//             color: Colors.green[900],
//             fontSize: 45,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
// }
