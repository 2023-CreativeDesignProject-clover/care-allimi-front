import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int uid = 0;
  String urole ='';
  String loginid ='';
  String phone_num = '';
  String name = '';

  void setInfo(int uid, String urole, String loginid, String phone_num, String name) {
    this.uid = uid;
    this.urole = urole;
    this.loginid = loginid;
    this.phone_num = phone_num;
    this.name = name;

    notifyListeners();
  }

  void getData() {
    notifyListeners();
  }

  void setRole(String urole) {
    this.urole = urole;
    notifyListeners();
  }

  void changeRoleData() {
    this.urole = 'asdf';
    notifyListeners();
  }

  void logout() {
    this.uid = 0;
    this.urole = '';
    this.loginid = '';
    this.phone_num = '';
    this.name = '';

    notifyListeners();
  }

//TODO 로그아웃
}