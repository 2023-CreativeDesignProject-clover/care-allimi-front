import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ResidentManagementPage.dart';
import '../Supplementary/CustomWidget.dart';
import '../Supplementary/ThemeColor.dart';
import '/provider/ResidentProvider.dart';
import 'package:http/http.dart' as http; // http 사용
import 'package:test_data/Backend.dart';

// 초대 목록 화면
ThemeColor themeColor = ThemeColor();

class InviteListPage extends StatefulWidget {
  const InviteListPage({Key? key}) : super(key: key);

  @override
  State<InviteListPage> createState() => _InviteListPageState();
}

class _InviteListPageState extends State<InviteListPage> {
  static List<Map<String, dynamic>> _inviteDatalist = [];
  late int _facilityId;

  Future<void> getInvitation(int facilityId) async {
    http.Response response = await http.get(
        Uri.parse(Backend.getUrl() + "invitations/" + facilityId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      _inviteDatalist =  parsedJson;
    });
  }

  //삭제
  Future<void> deleteInvitation(int invitId) async {
    http.Response response = await http.delete(
        Uri.parse(Backend.getUrl()+ 'invitations'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        },
        body: jsonEncode({
          "invit_id": invitId
        })
    );
    print(response.statusCode);
    if (response.statusCode == 200){
      setState(() {
        _inviteDatalist.removeWhere((invite) => invite['invit_id'] == invitId);
      });
    } else {
      throw Exception('Failed to delete invitation');
    }
  }

  @override
  void initState() {
    super.initState();
    final residentProvider = context.read<ResidentProvider>();
    _facilityId = residentProvider.facility_id;
    getInvitation(_facilityId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('초대 목록')),
      body: ListView(
        children: [
          appInviteList(),
        ],
      )
    );
  }

  //전체 구성
  Widget appInviteList(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _inviteDatalist.length,
            itemBuilder: (BuildContext context_, int index) {

              String userRole = '알 수 없음';
              if(_inviteDatalist[index]['userRole'] == 'PROTECTOR') {
                userRole = '보호자';
              } else if(_inviteDatalist[index]['userRole'] == 'WORKER') {
                userRole = '직원';
              }

              return ListTile(
                leading: Icon(Icons.person_rounded, color: Colors.grey),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(_inviteDatalist[index]['name'] + ' 님 (' + userRole +')', textScaleFactor: 0.95,), //초대 리스트
                    ),
                    Container(
                      padding: EdgeInsets.all(2),
                      child: OutlinedButton(
                          style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3))),
                          onPressed: () async {
                            showDialog(
                                context: context,
                                barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                builder: (BuildContext context3) {
                                  return AlertDialog(
                                    content: Text("취소하시겠습니까?"),
                                    insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                                    actions: [
                                      TextButton(
                                        style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                        child: Text('아니오',style: TextStyle(color: themeColor.getColor(),),),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                        child: Text('예',style: TextStyle(color: themeColor.getColor(),),),
                                        onPressed: () async {
                                          try {
                                            if (checkClick.isRedundentClick(DateTime.now())) {
                                              return;
                                            }
                                            await deleteInvitation(_inviteDatalist[index]['id']);
                                            showToast('취소되었습니다');
                                            Navigator.of(context).pop();
                                            getInvitation(_facilityId);
                                          } catch(e) {
                                            showToast('삭제 실패! 다시 시도해주세요');
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                }
                            );
                          },
                          child: Text('취소하기',style: TextStyle(color: Colors.grey))
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 80,)
        ],
      ),
    );
  }
}