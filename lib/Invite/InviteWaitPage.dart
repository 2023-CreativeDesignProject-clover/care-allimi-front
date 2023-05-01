import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/provider/UserProvider.dart';
import '/ResidentInfoInputPage.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'package:http/http.dart' as http; //http 사용

String backendUrl = "http://3.36.73.115:8080/v2/";

//사용자의 초대대기 화면

Future<String> tempDummy(int uid) async {
  http.Response response = await http.post(
    Uri.parse(backendUrl+ 'nhResident'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Accept-Charset': 'utf-8'
    },
    body: jsonEncode({
      "user_id": uid,
      "facility_id": 1,
      "resident_name": "string",
      "birth": "string",
      "user_role": "MANAGER",
      "health_info": "string"
    })
  );

  return utf8.decode(response.bodyBytes);
}


class InviteWaitPage extends StatefulWidget {
  @override
  _InviteWaitPageState createState() => _InviteWaitPageState();
}

class _InviteWaitPageState extends State<InviteWaitPage> {

  int _count = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return ElevatedButton (
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
                  await tempDummy(userProvider.uid);

                   Provider.of<UserProvider>(context, listen:false)
                          .changeRoleData();
                          
                  //pageAnimation(context, 시설추가);
                }
            );
          }
        ),
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            Container(
                padding: EdgeInsets.all(15),
                child: Column(
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
                        children: [
                          addList(),
                          addList(),
                          addList(),
                        ],
                      )
                    ),
                  ],
                )
            ),
          ],
        )
      ),
    );
  }
  Widget addList(){
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
                    onPressed: (){
                      pageAnimation(context, ResidentInfoInputPage());
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