import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int uid = 0;
  String urole =''; //초기값 ''
  String loginid ='';
  String phone_num = '';
  String name = '';

  void setInfo(int uid, String urole, String loginid, String phone_num, String name) {
    this.uid = uid;
    this.urole = urole;
    this.loginid = loginid;
    this.phone_num = phone_num;
    this.name = name;
  }

  void getData() {
    notifyListeners();
  }

  void setRole(String urole) {
    this.urole = urole;
  }

  void changeRoleData() {
    this.urole = 'asdf';
  }

  void logout() {
    this.uid = 0;
    this.urole = '';
    this.loginid = '';
    this.phone_num = '';
    this.name = '';
  }

//TODO 로그아웃
}