import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/UI/BeforeMain/AddFacilities.dart';
import 'package:test_data/provider/UserProvider.dart';
import '../MainSetup/ResidentManagementPage.dart';
import '../Supplementary/CustomWidget.dart';
import '/UI/BeforeMain/ResidentInfoInputPage.dart';
import '/UI/Supplementary/PageRouteWithAnimation.dart';
import 'package:http/http.dart' as http;
import 'package:test_data/Backend.dart';
import '../Supplementary/ThemeColor.dart';

// 사용자의 초대대기 화면
ThemeColor themeColor = ThemeColor();

class InviteWaitPage extends StatefulWidget {
  @override
  _InviteWaitPageState createState() => _InviteWaitPageState();

  const InviteWaitPage({
    Key? key, 
    required this.uid
  }) : super(key: key);

  final int uid;
}

class _InviteWaitPageState extends State<InviteWaitPage> {
  late int _count = 0;
  int _uid = 0;

  List<Map<String, dynamic>> _residentList = [];

  @override
  void initState() {
    this._uid = widget.uid;
    getResidentList();
  }

  Future<void> getResidentList() async {
    debugPrint("@@@@@ 입소자 정보 리스트 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
      Uri.parse(Backend.getUrl() + "users/invitations/" + _uid.toString()),
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
    return WillPopScope(
      child: Scaffold(
      appBar: AppBar(title: Row(
        children: [
          Text('초대 대기 목록'),
          SizedBox(width: 7),
          Container(
            width: 30, height: 30,
            child: CircleAvatar(
              backgroundColor: Color(0xfff3727c),
              child: Text('$_count', style: TextStyle(fontSize: 13, color: Colors.white)),
            ),
          ),
          IconButton(
              onPressed: () { getResidentList(); },
              icon: Icon(Icons.restart_alt_rounded)
          )
        ],
      )),
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
                              child: addList(_residentList[i]['id'], _residentList[i]['facility_id'], _residentList[i]['name'], _residentList[i]['facility_name'], _residentList[i]['userRole'],_residentList[i]['date']),
                            ),
                            Divider(thickness: 0.5),
                          ]
                        ],
                      )
                  ),
                ],
              )
          )
        ],
      ),
      bottomNavigationBar: Row(
        children: [
          SizedBox(width: 5),
          Expanded(
            child: TextButton(
                child: Container(
                    child: Text('시설장이신가요?', textScaleFactor: 1.2, textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)),
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.white10),
                    backgroundColor: MaterialStateProperty.all(themeColor.getColor()),
                    padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
                ),
                onPressed: (){
                  pageAnimation(context, AddFacilities(uid: _uid));
                }
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: TextButton(
                child: Container(child: Text('로그아웃', textScaleFactor: 1.2, textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)),
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.white10),
                    backgroundColor: MaterialStateProperty.all(themeColor.getColor()),
                    padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
                ),
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (context) =>
                        AlertDialog(
                          content: const Text('로그아웃하시겠습니까?'),
                          actions: [
                            TextButton(
                                child: Text('취소', style: TextStyle(color: themeColor.getMaterialColor())),
                                style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            TextButton(
                                child: Text('확인', style: TextStyle(color: themeColor.getMaterialColor())),
                                style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                onPressed: () {
                                  Provider.of<UserProvider>(context, listen:false) //로그아웃
                                      .uid = 0;
                                  Provider.of<UserProvider>(context, listen:false) //Provider에게 값이 바뀌었다고 알려줌 -> 화면 재로딩
                                      .getData();
                                  Navigator.pop(context);
                                })

                          ],
                        ),
                  );
                }
            ),
          ),
          SizedBox(width: 5),
        ],
      ),
    ),
      onWillPop: () async {
        bool result = onWillPop();
        return await Future.value(result);
      },);
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Text(facility_name, style: TextStyle(fontWeight: FontWeight.bold), maxLines: 5, overflow: TextOverflow.ellipsis,),
                ),
                SizedBox(
                  child: Text(userRoleString, maxLines: 2, overflow: TextOverflow.ellipsis,),
                ),
              ],
            ),
          ),


          Container(
            child:  OutlinedButton(
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3)),
                    side: MaterialStateProperty.all(BorderSide(color: themeColor.getColor()))
                ),
                onPressed: () async {
                  if (checkClick.isRedundentClick(DateTime.now())) {
                    return;
                  }
                  await awaitPageAnimation(context, ResidentInfoInputPage(invitationId: id, invitationUserRole: userRole,
                      invitationFacilityId: facilityId, invitationFacilityName : facility_name,
                      userId: _uid));

                },
                child: Text('초대받기',style: TextStyle(color: themeColor.getColor()),)
            )
              
          )
        ],
      ),
    );
  }
}