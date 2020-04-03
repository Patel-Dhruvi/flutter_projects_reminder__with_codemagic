
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String toastMsg) {
  Fluttertoast.showToast(
      msg: toastMsg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.black,
      fontSize: 16.0);
}