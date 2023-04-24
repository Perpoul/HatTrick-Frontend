import 'package:flutter/material.dart';
import 'package:hat_trick/pages/login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:hat_trick/pages/profile.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
        ChangeNotifierProvider(
          create: (context) => PlayerModel(),
          child: const MyApp()
        )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hat Trick',
      home: LoginPage(),
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
