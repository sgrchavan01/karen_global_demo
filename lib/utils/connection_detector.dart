import 'dart:io';

import 'package:flutter/material.dart';

class ConnectionDetector {
  static Future<bool> checkInternetConnection() async {
    bool isInternetAvailable = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isInternetAvailable = true;
      }
    } catch (e) {
      print(e.toString());
    }

    return isInternetAvailable;
  }

  internetDailog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('No internet'),
            content: Text('Please connect to internet'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
