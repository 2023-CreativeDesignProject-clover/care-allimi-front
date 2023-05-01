import 'package:flutter/material.dart';

class ResidentProvider  with ChangeNotifier {
  int resident_id=0;
  int facility_id=0;
  String facility_name='';
  String resident_name='';
  String birth = '';
  String health_info ='';
  int inviteId = 0;

  //받아온 정보 전역에 저장
  void setInfo(resident_id, facility_id, facility_name, resident_name, userRole, birth, health_info) {
    this.resident_id = resident_id;
    this.facility_id = facility_id;
    this.facility_name = facility_name;
    this.resident_name = resident_name;
    this.birth = birth;
    this.health_info = health_info;
  }

  void getData() {
    notifyListeners();
  }

  void setInviteId(int inviteId) {
    this.inviteId = inviteId;
    notifyListeners();
  }



//TODO 로그아웃
}