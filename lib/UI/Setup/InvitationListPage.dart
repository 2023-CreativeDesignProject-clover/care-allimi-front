import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/provider/UserProvider.dart';
import '/UI/BeforeMain/ResidentInfoInputPage.dart';
import '/UI/Supplementary/PageRouteWithAnimation.dart';
import 'package:http/http.dart' as http;
import '../Supplementary/CustomClick.dart';
import 'package:test_data/Backend.dart';
import '../Supplementary/ThemeColor.dart';

ThemeColor themeColor = ThemeColor();

//사용자의 초대대기 화면

class InvitationListPage extends StatefulWidget {
  @override
  _InvitationListPageState createState() => _InvitationListPageState();

  const InvitationListPage({
    Key? key, 
    required this.uid
  }) : super(key: key);

  final int uid;
}

class _InvitationListPageState extends State<InvitationListPage> {
  int _count =0 ;
  int uid = 0;
  CheckClick checkClick = new CheckClick();
  List<Map<String, dynamic>> _residentList = [];

  @override
  void initState() {
    this.uid = widget.uid;
    getResidentList(uid);
    
  }

  Future<void> getResidentList(int userId) async {
    debugPrint("@@@@@ 입소자 정보 리스트 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
      Uri.parse(Backend.getUrl() + "users/invitations/" + userId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      _residentList = parsedJson;
      this._count = parsedJson.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Flexible(child: Text("초대받은 요양원 목록")),
              SizedBox(width: 7),
              Container(
                padding: EdgeInsets.all(5),
                width: 37,
                height: 37,
                child: CircleAvatar(
                  backgroundColor: Color(0xfff3727c),
                  child: Text('$_count', style: TextStyle(fontSize: 13, color: Colors.white)),
                ),
              ),
              IconButton(
                onPressed: () { getResidentList(uid); },
                icon: Icon(Icons.restart_alt_rounded),
              ),
            ],
          ),
        ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10)
      ),
      body: ListView(
        children: [
          Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  Container(
                      child: Column(
                        children:[
                          for (var i=0; i< _residentList.length; i++)... [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 0),
                              child: addList(_residentList[i]['id'], _residentList[i]['facility_id'], _residentList[i]['name'], _residentList[i]['facility_name'], _residentList[i]['userRole'],_residentList[i]['date'])
                            ),
                            Divider(thickness: 0.5),
                          ]
                        ],
                      )
                  ),
                ],
              )

          ),
        ],
      )
    );
  }


  Container addList(int id, int facilityId, String name, String facility_name, String userRole, String date){
    String userRoleString = '';

    if (userRole == 'PROTECTOR')
      userRoleString = '보호자';
    else if (userRole == 'MANAGER')
      userRoleString = '매니저';
    else if (userRole == 'WORKER')
      userRoleString = '요양보호사';
    else
      userRoleString = '누구세요';

    return Container(
        child: Container(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Text(facility_name, style: TextStyle(fontWeight: FontWeight.bold), maxLines: 5, overflow: TextOverflow.ellipsis,),
                    ), //요양원 이름
                    SizedBox(
                      child: Text(userRoleString, maxLines: 2, overflow: TextOverflow.ellipsis,),
                    ), // 내 역할
                  ],
                ),
              ),
              Container(
                child: Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      return OutlinedButton(
                          style: ButtonStyle(
                              side: MaterialStateProperty.all(BorderSide(color: themeColor.getColor())),
                              overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))
                          ),
                          onPressed: () async {
                            if (checkClick.isRedundentClick(DateTime.now())) { //연타 막기
                              return ;
                            }

                            await awaitPageAnimation(context, ResidentInfoInputPage(invitationId: id, invitationUserRole: userRole,
                                invitationFacilityId: facilityId, invitationFacilityName : facility_name,
                                userId: userProvider.uid));

                            getResidentList(uid);

                          },
                          child: Text('초대받기',style: TextStyle(color: themeColor.getColor(),),)
                      );
                    }
                ),
              ),
            ],
          ),
        )
    );
  }


}