import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:staid/views/app_colors.dart';

class UtilityToaster {
  getToast(msg) {
    Fluttertoast.showToast(
      msg: msg.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: AppColors.primaryDarkColor,
      textColor: Colors.white,
      // fontSize: 16.0
    );
  }
}
