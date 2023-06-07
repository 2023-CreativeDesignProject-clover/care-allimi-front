import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String text) {
  return Fluttertoast.showToast(
    msg: text,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: const Color(0xff6E6E6E),
    fontSize: 12,
    toastLength: Toast.LENGTH_SHORT,
  );
}

DateTime? currentBackPressTime;

onWillPop() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
    currentBackPressTime = now;
    showToast("'뒤로' 버튼을 한번 더 누르시면 종료됩니다");
    return false;
  }
  return true;
}