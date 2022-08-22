import 'package:flutter/material.dart';

import 'package:sincop_app/src/utils/theme.dart';




class NotificatiosnService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
       GlobalKey<ScaffoldMessengerState>();
  
  static showSnackBarError(String message) {
    final snackBar =  SnackBar(
      // backgroundColor: Colors.red.withOpacity(0.9),
 backgroundColor: cuaternaryColor,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20
        ),
      ),
    );
    messengerKey.currentState!.showSnackBar(snackBar);
  }
  static showSnackBarSuccsses(String message) {
    final snackBar =  SnackBar(
      // backgroundColor: Colors.green.withOpacity(0.9),
      backgroundColor: secondaryColor,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20
        ),
      ),
    );
    messengerKey.currentState!.showSnackBar(snackBar);
  }
  static showSnackBarDanger(String message) {
    final snackBar =  SnackBar(
      // backgroundColor: Colors.green.withOpacity(0.9),
      backgroundColor: tercearyColor,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20
        ),
      ),
    );
    messengerKey.currentState!.showSnackBar(snackBar);
  }
  static showSnackBarInfo(String message,String result) {
    final snackBar =  SnackBar(
      // backgroundColor: Colors.green.withOpacity(0.9),
      backgroundColor: (result=='success')?secondaryColor:tercearyColor,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20
        ),
      ),
    );
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
