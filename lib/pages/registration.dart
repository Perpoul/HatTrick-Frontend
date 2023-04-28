import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hat_trick/misc/utils.dart';
import 'package:hat_trick/pages/profile.dart';

import '../firebase/fire_auth.dart';
import '../firebase/validator.dart';
import 'homePage.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _registrationFormKey = GlobalKey<FormState>();
  final usernameTextController = TextEditingController();
  final emailTextContoller = TextEditingController();
  final passwordTextController = TextEditingController();

  final usernameFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          usernameFocus.unfocus();
          emailFocus.unfocus();
          passwordFocus.unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text("Register"),
            ),
            body: Padding(
                padding: EdgeInsets.only(
                  left: screen.width * .08,
                  right: screen.width * .08,
                  bottom: screen.height * .05,
                  top: screen.height * .05,
                ),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Form(
                          key: _registrationFormKey,
                          child: Column(children: <Widget>[
                            TextFormField(
                              controller: usernameTextController,
                              focusNode: usernameFocus,
                              validator: (value) =>
                                  Validator.validateUsername(username: value),
                              decoration: InputDecoration(
                                hintText: "Username",
                                errorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screen.height * .02),
                            TextFormField(
                                controller: emailTextContoller,
                                focusNode: emailFocus,
                                validator: (value) =>
                                    Validator.validateEmail(email: value),
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(color: Colors.red),
                                    ))),
                            SizedBox(height: screen.height * .02),
                            TextFormField(
                                controller: passwordTextController,
                                focusNode: passwordFocus,
                                obscureText: true,
                                validator: (value) =>
                                    Validator.validatePassword(password: value),
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    errorBorder: UnderlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                        )))),
                            SizedBox(height: screen.height * .02),
                            _isProcessing
                                ? CircularProgressIndicator()
                                : Row(children: [
                                    Expanded(
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              setState(() {
                                                _isProcessing = true;
                                              });
                                              if (_registrationFormKey
                                                  .currentState!
                                                  .validate()) {
                                                User? user = await FireAuth
                                                    .registerUsingEmailPassword(
                                                  context: context,
                                                  username:
                                                      usernameTextController
                                                          .text,
                                                  email:
                                                      emailTextContoller.text,
                                                  password:
                                                      passwordTextController
                                                          .text,
                                                );

                                                setState(() {
                                                  _isProcessing = false;
                                                });

                                                if (user != null) {
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage(user: user),
                                                    ),
                                                    ModalRoute.withName('/'),
                                                  );
                                                }
                                              }
                                            },
                                            child: Text(
                                              "Sign Up",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )))
                                  ])
                          ]))
                    ])))));
  }
}
