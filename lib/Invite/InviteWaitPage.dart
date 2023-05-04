import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/provider/UserProvider.dart';
import '/LoginPage.dart';
import '/ResidentInfoInputPage.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'package:http/http.dart' as http;

String backendUrl = "http://13.125.155.244:8080/v2/";


//사용자의 초대대기 화면

class InviteWaitPage extends StatefulWidget {
  @override
  _InviteWaitPageState createState() => _InviteWaitPageState();
}

class _InviteWaitPageState extends State<InviteWaitPage> {
  int _count = 3;

  List<Map<String, dynamic>> _residentList = [];

  Future<void> getResidentList(int userId) async {
    http.Response response = await http.get(
        Uri.parse(backendUrl + "users/invitations/" + userId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      _residentList =  parsedJson;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton (
                    child: Text(
                      '시설 추가하기',
                      style: TextStyle(fontSize: 18.0,),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: themeColor.getColor(),
                      padding: EdgeInsets.all(7),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    onPressed: (){
                      //pageAnimation(context, 시설추가);
                    }
                ),
              ),
              SizedBox(width: 5,),
              Expanded(
                child: ElevatedButton (
                    child: Text(
                      '로그아웃',
                      style: TextStyle(fontSize: 18.0, ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: themeColor.getColor(),
                      padding: EdgeInsets.all(7),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    onPressed: (){
                      pageAnimation(context, LoginPage());
                    }
                ),
              ),
            ],
          )
      ),
      body: Scrollbar(
          child: ListView(
            children: [
              Container(
                  padding: EdgeInsets.all(15),
                  child: Consumer<UserProvider>(
                      builder: (context, userProvider, child) {
                        return FutureBuilder(
                            future: getResidentList(userProvider.uid),
                            builder: (context, snap) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '초대 대기목록',
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        width: 37, height: 37,
                                        child: CircleAvatar(
                                          backgroundColor: Color(0xffF3959D),
                                          child: Text(
                                            '$_count',
                                            style: TextStyle(fontSize: 13, color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                      padding: EdgeInsets.all(4),
                                      child: Column(
                                        children:[
                                          for (var i=0; i< _residentList.length; i++)... [
                                            addList(_residentList[i]['id'], _residentList[i]['facility_id'], _residentList[i]['name'], _residentList[i]['facliity_name'], _residentList[i]['userRole'],_residentList[i]['date'])
                                          ]
                                        ],
                                      )
                                  ),
                                ],
                              );
                            }
                        );
                      }
                  )
              ),
            ],
          )
      ),
    );
  }


  Card addList(int id, int facilityId, String name, String facility_name, String userRole, String date){

    String userRoleString = '';

    if (userRole == 'PROTECTOR')
      userRoleString = '보호자';
    else if (userRole == 'MANAGER')
      userRoleString = '매니저';
    else if (userRole == 'WORKER')
      userRoleString = '요양보호사';
    else
      userRoleString = '누구세요';

    return Card(
        child: Container(
          padding: EdgeInsets.only(right: 7, left: 7),
          child: Row(
            children: [
              Text(
                  '금오요양원: 보호자'
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(2),
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(color: themeColor.getColor(),)
                    ),
                    onPressed: (){
                      pageAnimation(context, ResidentInfoInputPage(invitationId: id, invitationUserRole: userRole,
                          invitationFacilityId: facilityId, invitationFacilityName : facility_name));
                    },
                    child: Text('초대받기',style: TextStyle(color: themeColor.getColor(),),)
                ),
              ),
            ],
          ),
        )
    );
  }
}