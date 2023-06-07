import 'package:flutter/material.dart';
import 'package:test_data/UI/MainSetup/InvitePage.dart';
import '../Supplementary/ThemeColor.dart';
import '/UI/MainSetup/FacilityBasicInfoPage.dart';
import 'InviteListPage.dart';
import 'EmployeeManagementPage.dart';
import '/UI/Supplementary/PageRouteWithAnimation.dart';
import 'ResidentManagementPage.dart';

ThemeColor themeColor = ThemeColor();

class MainFacilitySettingsPage extends StatefulWidget {
  const MainFacilitySettingsPage({Key? key, required this.facilityId}) : super(key: key);

  final int facilityId;

  @override
  State<MainFacilitySettingsPage> createState() => _MainFacilitySettingsPageState();
}

class _MainFacilitySettingsPageState extends State<MainFacilitySettingsPage> {
  final fontSize = 0.95;
  late int _facilityId;

    @override
  void initState() {
    super.initState();
    _facilityId = widget.facilityId;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('시설 설정')),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              groupText('직원 및 입소자 관리'),
              appEmployeeManagement(),
              appResidentManagement(),
              SizedBox(height: 15,),
              groupText('초대'),
              appInvite(),
              appInviteList(),
              groupText('시설'),
              appFacilityBasicSetting(),
            ],
          )
        ],
      ),
    );
  }

  Widget groupText(String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20,10,20,10),
      child: Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: themeColor.getColor()
        ),
        textScaleFactor: 1,
      ),
    );
  }

  Widget appResidentManagement() {
    return ListTile(
        title: Text('입소자 관리', textScaleFactor: fontSize,),
        leading: Icon(Icons.supervisor_account_rounded, color: Colors.grey),
        onTap: () {
          pageAnimation(context, UserPeopleManagementPage());
        });
  }

  Widget appEmployeeManagement() {
    return ListTile(
        title: Text('직원 관리', textScaleFactor: fontSize,),
        leading: Icon(Icons.supervisor_account_rounded, color: Colors.grey),
        onTap: () {
          pageAnimation(context, PeopleManagementPage());
        });
  }

  Widget appInvite() {
    return ListTile(
        title: Text('초대하기', textScaleFactor: fontSize),
        leading: Icon(Icons.send_rounded, color: Colors.grey),
        onTap: () {
          pageAnimation(context, InvitePage());
        });
  }

  Widget appInviteList() {
    return ListTile(
        title: Text('초대 목록', textScaleFactor: fontSize),
        leading: Icon(Icons.favorite_rounded, color: Colors.grey),
        onTap: () {
          pageAnimation(context, InviteListPage());
        });
  }

  Widget appFacilityBasicSetting() {
    return ListTile(
      title: Text('시설 기본 정보', textScaleFactor: fontSize),
      leading: Icon(Icons.home_rounded, color: Colors.grey),
      onTap: () {
        pageAnimation(context, FacilityBasicInfoPage(facilityId: _facilityId));
      });
  }
}