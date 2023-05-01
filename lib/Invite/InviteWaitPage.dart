import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart';
import '/ResidentInfoInputPage.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'package:http/http.dart' as http; //http 사용

String backendUrl = "http://13.125.155.244:8080/v2/";

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
        child: ElevatedButton (
          child: Text(
            '시설 추가하기',
            style: TextStyle(fontSize: 18.0),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(7),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
          ),
          onPressed: () async {
          }
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
                                      _residentList.length.toString(),
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
                                ]
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
                  facility_name + ': ' + userRoleString
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(2),
                child: OutlinedButton(
                    onPressed: (){
                      //id를 이용하여 수락과정 진행!
                      // Provider.of<ResidentProvider>(context, listen: false)
                      // .setInviteId(id);

                      pageAnimation(context, ResidentInfoInputPage(invitationId: id, invitationUserRole: userRole, 
                                  invitationFacilityId: facilityId, invitationFacilityName : facility_name));

                    },
                    child: Text('초대받기')
                ),
              ),
            ],
          ),
        )
    );
  }
}