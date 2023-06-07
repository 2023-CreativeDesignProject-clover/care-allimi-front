import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:test_data/UI/Setup/InvitationListPage.dart';
import 'package:test_data/UI/Setup/AppRulePage.dart';
import 'package:test_data/UI/Setup/ProtectorInmateProfilePage.dart';
import 'package:test_data/UI/Setup/MyProfilePage.dart';
import 'package:test_data/UI/Setup/WorkerInmateProfilePage.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart';
import '/UI/Supplementary/ThemeColor.dart';
import '/UI/Supplementary/PageRouteWithAnimation.dart';
import 'package:http/http.dart' as http;
import '../Supplementary/CustomClick.dart';
import 'package:test_data/Backend.dart';
import 'UserDeletePage.dart';

ThemeColor themeColor = ThemeColor();

class SetupPage extends StatefulWidget {
  const SetupPage({Key? key, required this.userRole, required this.userId}) : super(key: key);
  final String userRole;
  final int userId;

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  String version = '1.0.0';
  CheckClick checkClick = new CheckClick();
  List<Map<String, dynamic>> _userList = [];
  late String _userRole;
  late int _userId;
  int _count = 0;
  final fontSize = 0.95;

  Future<void> getResidentList() async {
    debugPrint("@@@@@ 입소자 정보 리스트 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
      Uri.parse(Backend.getUrl() + "users/invitations/" + _userId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      this._count = parsedJson.length;
    });
  }

  @override
  void initState() {
    super.initState();
    _userRole = widget.userRole;
    _userId = widget.userId;
    getResidentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('설정')),
      body: ListView(
        children: [
          appProfile(),
          if (_userRole == 'PROTECTOR') //현재 보호 중인 입소자 정보: 보호자 ver
            appProtectorInmateProfile(),

          if (_userRole == 'WORKER') //현재 보호 중인 입소자 정보: 요양보호사 ver
            appWorkerInmateProfile(),

          appInvitation(),
          Divider(thickness: 8, color: Color(0xfff8f8f8)),
          appRule(),
          appVersion(),
          Divider(thickness: 8, color: Color(0xfff8f8f8)),
          appDelete(),
          appLogout(),
        ],
      ),
    );
  }

  Widget appProfile() {
    return ListTile(
        title: Text('내 정보', textScaleFactor: fontSize),
        leading: Icon(Icons.person_rounded, color: Colors.grey),
        onTap: () { pageAnimation(context, MyProfilePage()); });
  }

  //입소자 정보 - 보호자일 때
  Widget appProtectorInmateProfile() {
    return ListTile(
      title: Text('입소자 정보', textScaleFactor: fontSize),
      leading: Icon(Icons.supervisor_account_rounded, color: Colors.grey),
      onTap: () { pageAnimation(context, ProtectorInmateProfilePage(uid: _userId)); }
    );
  }

  //입소자 정보 - 요양보호사일 때
  Widget appWorkerInmateProfile() {
    return Consumer2<UserProvider, ResidentProvider>(
        builder: (context, userProvider, residentProvider, child) {
          return ListTile(
              title: Text('입소자 정보', textScaleFactor: fontSize),
              leading: Icon(Icons.supervisor_account_rounded, color: Colors.grey),
              onTap: () { pageAnimation(context, WorkerInmateProfilePage(uid: userProvider.uid, facilityId: residentProvider.facility_id , residentId: residentProvider.resident_id,)); });
        }
    );
  }

  Widget appInvitation() {
    return ListTile(
        title: Text('초대받기', textScaleFactor: fontSize),
        leading: Icon(Icons.favorite_rounded, color: Colors.grey),
        onTap: () { pageAnimation(context, InvitationListPage(uid:_userId)); },
        trailing: inviteCount()
    );
  }

  Widget inviteCount() {
    if (_count > 0) {
      return Container(
        padding: EdgeInsets.all(5),
        width: 37, height: 37,
        child: CircleAvatar(
          backgroundColor: Color(0xfff3727c),
          child: Text(
            '$_count',
            style: TextStyle(fontSize: 13, color: Colors.white),
          ),
        ),
      );
    } else {
      return Text('');
    }
  }

  Widget appLogout() {
    return ListTile(
      title: Text('로그아웃', textScaleFactor: fontSize),
      leading: Icon(Icons.logout_rounded, color: Colors.grey),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) =>
            AlertDialog(
              content: const Text('로그아웃하시겠습니까?'),
              actions: [
                TextButton(child: Text('아니오',
                  style: TextStyle(color: themeColor.getMaterialColor())),
                  style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                  onPressed: () {
                    Navigator.pop(context);
                }),
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    return TextButton(child: Text('예',
                      style: TextStyle(color: themeColor.getMaterialColor())),
                      style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                      onPressed: () {
                        if (checkClick.isRedundentClick(DateTime.now())) { //연타 막기
                          return ;
                        }
                        userProvider.logout();
                        userProvider.getData();
                        Navigator.pop(context);
                      });
                  }
                ),
              ],
            ),
        );
      });
  }

  Widget appRule() {
    return ListTile(
      title: Text('앱 이용규칙', textScaleFactor: fontSize),
      leading: Icon(Icons.rule_rounded, color: Colors.grey),
      onTap: () {
        pageAnimation(context, AppRulePage());
      }
    );
  }

  Widget appVersion() {
    return ListTile(
      title: Text('버전 정보', textScaleFactor: fontSize),
      leading: Icon(Icons.info_rounded, color: Colors.grey),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('현재 버전은 $version 입니다'), //내용
              duration: const Duration(seconds: 2), //올라와 있는 시간
            )
        );
      }
    );
  }

  Widget appDelete() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return ListTile(
          title: Text('계정 탈퇴', textScaleFactor: fontSize),
          leading: Icon(Icons.person_remove_rounded, color: Colors.grey),
          onTap: () async {
            await awaitPageAnimation(context, UserDeletePage());
            if (userProvider.uid == 0) {
              userProvider.getData();
            }
          }
        );
      }
    );
  }
}




