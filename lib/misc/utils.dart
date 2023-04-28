import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';

class Utils {
  static void showConfirmationDialog(
      BuildContext context, String message, Function onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }

  static void showPopUp(
      BuildContext context, String title, String message, Color color) {
    Flushbar(
      duration: Duration(seconds: 3),
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: color,
    ).show(context);
  }
}
