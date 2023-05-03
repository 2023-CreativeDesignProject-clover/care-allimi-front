import 'package:flutter/material.dart';

class AllimTempProvider  with ChangeNotifier {
  String morning='금식';
  String launch='금식';
  String dinner = '금식';
  String medication = '해당 사항 없음';

  //받아온 정보 전역에 저장
  void setMorning(morning) {
    this.morning = morning;
  }
  void setLaunch(launch) {
    this.launch = launch;
  }
  void setDinner(dinner) {
    this.dinner = dinner;
  }
  void setMedication(medication) {
    this.medication = medication;
  }

  void getData() {
    notifyListeners();
  }

}