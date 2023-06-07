import 'package:flutter/material.dart';

class VisitTempProvider with ChangeNotifier {
  String selectedDate = ''; //2023.05.10
  String selectedTime = ''; //04:00
  String text = '';

  void setDate(date) {
    this.selectedDate = date;
  }

  void setTime(time) {
    this.selectedTime = time;
  }

  void setText(text) {
    this.text = text;
  }


  void getData() {
    notifyListeners();
  }
}