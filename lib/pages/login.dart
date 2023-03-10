import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hat_trick/pages/profile.dart';
import 'package:hat_trick/pages/registration.dart';

import '../firebase/validator.dart';
import '../firebase/fire_auth.dart';
import '../widgets/googleSignInButton.dart';
import 'homePage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final passwordFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordTextController = TextEditingController();
  final emailTextController = TextEditingController();

  bool _isProcessing = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          emailFocus.unfocus();
          passwordFocus.unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Login"),
            ),
            body: FutureBuilder(
                future: FireAuth.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Padding(
                        padding: EdgeInsets.only(
                            left: screen.width * .10,
                            right: screen.width * .10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: screen.height * .025),
                                child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "Login",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge,
                                    )),
                              ),
                              Form(
                                  key: _formKey,
                                  child: Column(children: <Widget>[
                                    TextFormField(
                                      controller: emailTextController,
                                      focusNode: emailFocus,
                                      validator: (value) =>
                                          Validator.validateEmail(
                                        email: value,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Email",
                                        errorBorder: UnderlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: screen.height * .01),
                                    TextFormField(
                                      controller: passwordTextController,
                                      focusNode: passwordFocus,
                                      obscureText: true,
                                      validator: (value) =>
                                          Validator.validatePassword(
                                              password: value),
                                      decoration: InputDecoration(
                                        hintText: "Password",
                                        errorBorder: UnderlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: screen.height * .025),
                                    _isProcessing
                                        ? CircularProgressIndicator()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      emailFocus.unfocus();
                                                      passwordFocus.unfocus();

                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        setState(() {
                                                          _isProcessing = true;
                                                        });

                                                        User? user = await FireAuth
                                                            .signInUsingEmailPassword(
                                                                email:
                                                                    emailTextController
                                                                        .text,
                                                                password:
                                                                    passwordTextController
                                                                        .text);

                                                        setState(() {
                                                          _isProcessing = false;
                                                        });

                                                        if (user != null) {
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    HomePage(
                                                                        user:
                                                                            user)),
                                                          );
                                                        }
                                                      }
                                                    },
                                                    child: const Text(
                                                      "Sign In",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: screen.width * .06),
                                                Expanded(
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Registration(),
                                                            ),
                                                          );
                                                        },
                                                        child: Text(
                                                          "Register",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )))
                                              ]),
                                    //google sign in:
                                    SizedBox(height: screen.height * .02),
                                    FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: GoogleSignInButton()),

                                    //                   Card(
                                    //                       child: Column(
                                    //                           mainAxisAlignment:
                                    //                               MainAxisAlignment.spaceEvenly,
                                    //                           children: [
                                    //                         Padding(
                                    //                             padding: const EdgeInsets.only(
                                    //                                 left: 20, right: 20),
                                    //                             child: MaterialButton(
                                    //                               color: Colors.white,
                                    //                               elevation: 10,
                                    //                               child: Row(
                                    //                                 mainAxisAlignment:
                                    //                                     MainAxisAlignment.start,
                                    //                                 children: [
                                    //                                   Container(
                                    //                                     height: 30.0,
                                    //                                     width: 30.0,
                                    //                                     decoration: BoxDecoration(
                                    //                                       image: DecorationImage(
                                    //                                           image: AssetImage(
                                    //                                               'assets/images/googleimage.png'),
                                    //                                           fit: BoxFit.cover),
                                    //                                       shape: BoxShape.circle,
                                    //                                     ),
                                    //                                   ),
                                    //                                   SizedBox(
                                    //                                     width: 20,
                                    //                                   ),
                                    //                                   Text("Sign In with Google")
                                    //                                 ],
                                    //                               ),
                                    //                               onPressed: () {
                                    //                                 googleSignUp(context);
                                    //                               },
                                    //                             ))
                                    //                       ]))
                                  ]))
                            ]));
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                })));
  }
}

// @override
// Widget build(BuildContext context) {
//   Form(
//     key: _formKey,
//     child: Column(
//       children: <Widget>[
//         TextFormField(
//             controller: emailTextController,
//             focusNode: emailFocus,
//             validator: (value) => Validator.validateEmail(email: value)),
//         const SizedBox(height: 8.0),
//         TextFormField(
//           controller: passwordTextController,
//           focusNode: passwordFocus,
//           obscureText: true,
//           validator: (value) => Validator.validatePassword(password: value),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     User? user = await FireAuth.signInUsingEmailPassword(
//                       email: emailTextController.text,
//                       password: passwordTextController.text,
//                     );
//                     if (user != null) {
//                       Navigator.of(context).pushReplacement(
//                           MaterialPageRoute(builder: (context) => Profile()));
//                     }
//                   }
//                 },
//                 child: Text(
//                   "Sign In",
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(builder: (context) => Registration()),
//                   );
//                 },
//                 child: Text(
//                   "Register",
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );

//   return Scaffold(
//     appBar: AppBar(
//       title: Text('Login'),
//     ),
//     body: FutureBuilder(
//         future: _initializeFirebase(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Column(
//               children: [
//                 Text('Login'),
//               ],
//             );
//           }
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }),
//   );
// }