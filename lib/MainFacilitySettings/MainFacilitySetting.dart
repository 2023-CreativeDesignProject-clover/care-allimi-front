import 'package:flutter/material.dart';
import 'package:test_data/Invite/InviteWaitPage.dart';
import 'package:test_data/LoginPage.dart';
import 'package:test_data/ResidentInfoInputPage.dart';
import '/MainFacilitySettings/FacilityBasicInfoSettingPage.dart';
import '/Invite/InviteListPage.dart';
import 'PeopleManagementPage.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'UserPeopleManagementPage.dart';

class MainFacilitySettingsPage extends StatefulWidget {
  const MainFacilitySettingsPage({Key? key}) : super(key: key);

  @override
  State<MainFacilitySettingsPage> createState() => _MainFacilitySettingsPageState();
}

class _MainFacilitySettingsPageState extends State<MainFacilitySettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('시설 설정')),
      body: ListView(
        children: [
          Column(
            children: [
              appResidentManagement(),
              Divider(thickness: 0.5,),
              appEmployeeManagement(),
              Divider(thickness: 0.5,),
              appInvite(),
              Divider(thickness: 0.5,),
              appFacilityBasicSetting(),
              Divider(thickness: 3,),
              Test(),
              Divider(thickness: 0.5,),
              Test2(),
              Divider(thickness: 0.5,),
              Test3()
            ],
          )
        ],
      ),
    );
  }

  Widget appResidentManagement() {
    return ListTile(
        visualDensity: VisualDensity(horizontal: 0, vertical: -3),
        title: Text('입소자 관리'),
        trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey),
        onTap: () {
          pageAnimation(context, userPeopleManagementPage());
        });
  }

  Widget appEmployeeManagement() {
    return ListTile(
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        title: Text('직원 관리'),
        trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey),
        onTap: () {
          pageAnimation(context, PeopleManagementPage());
        });
  }

  Widget appInvite() {
    return ListTile(
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        title: Text('초대하기'),
        trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey),
        onTap: () {
          pageAnimation(context, InviteListPage());
        });
  }

  Widget appFacilityBasicSetting() {
    return ListTile(
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        title: Text('시설 기본 정보 설정'),
        trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey),
        onTap: () {
          pageAnimation(context, FacilityBasicInfoPage());
        });
  }




  Widget Test() {
    return ListTile(
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        title: Text('로그인 테스트'),
        trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey),
        onTap: () {
          pageAnimation(context, LoginPage());
        });
  }
  Widget Test2() {
    return ListTile(
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        title: Text('초대대기 테스트'),
        trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey),
        onTap: () {
          pageAnimation(context, InviteWaitPage());
        });
  }
  Widget Test3() {
    return ListTile(
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        title: Text('입소자정보입력 테스트'),
        trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey),
        onTap: () {
          pageAnimation(context, ResidentInfoInputPage());
        });
  }

}