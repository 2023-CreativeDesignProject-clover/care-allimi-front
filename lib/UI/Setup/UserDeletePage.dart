import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/Backend.dart';
import '/UI/BeforeMain/LoginPage.dart';
import '../Supplementary/CustomWidget.dart';
import '/provider/UserProvider.dart';
import '/UI/Supplementary/ThemeColor.dart';
import '/UI/Supplementary/PageRouteWithAnimation.dart';
import 'package:http/http.dart' as http;
import '../Supplementary/CustomClick.dart';

ThemeColor themeColor = ThemeColor();

class UserDeletePage extends StatefulWidget {
  const UserDeletePage({Key? key}) : super(key: key);

  @override
  State<UserDeletePage> createState() => _UserDeletePageState();
}

class _UserDeletePageState extends State<UserDeletePage> {
  CheckClick checkClick = new CheckClick();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('계정 탈퇴')),
      body: userDelete(),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(right: 5, left: 5),
        child: TextButton(
            child: Container(
                child: Text('계정 탈퇴', textScaleFactor: 1.2, textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)),
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.white10),
                backgroundColor: MaterialStateProperty.all(themeColor.getColor()),
                padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
            ),
            onPressed: () {
              //탈퇴 창
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Text('그동안 이용해주셔서 감사합니다'),
                  actions: [
                    TextButton(
                        child: Text('취소',
                            style: TextStyle(color: themeColor.getMaterialColor())),
                        style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    Consumer<UserProvider>(
                      builder: (context, userProvider, child) {
                        return TextButton(
                          child: Text('확인',
                          style: TextStyle(color: themeColor.getMaterialColor())),
                          style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                          onPressed: () async {
                            try {
                              if (checkClick.isRedundentClick(DateTime.now())) { // 연타 막기
                                return;
                              }

                              await deleteUser(userProvider.uid); // 탈퇴
                              
                              Navigator.pop(context);
                              Navigator.pop(context);

                              userProvider.init();
                            } catch (e) {
                              showToast('탈퇴 처리 중 오류가 발생하였습니다');
                              Navigator.pop(context);
                              print("탈퇴 처리 오류: $e");
                            }
                          }
                        );
                      }
                    ),
                  ],
                ),
              );
            }
        ),
      )
    );
  }

  Widget userDelete() {
    return ListView(
      children: [
        
        Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Text('🖐️', style: GoogleFonts.notoColorEmoji(fontSize: 55)),
              SizedBox(height: 7),
              Text('잠깐만요!', textScaleFactor: 1.3, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 7),
              Text('요양원 알리미를 탈퇴하기 전에', textScaleFactor: 1.1),
              Text('아래 내용을 확인해주세요', textScaleFactor: 1.1),
              SizedBox(height: 30),
            ],
          ),
        ),


        myDeleteBox('탈퇴 시 복구할 수 없어요', '바로 계정 삭제가 이루지므로 정보를 복구할 수 없어요'),
        SizedBox(height: 7,),
        myDeleteBox('요양원 측에서 다시 초대받아야 해요', '이전에 초대받은 목록이 전부 사라지므로 재이용하려면 초대장이 필요해요'),

      ],
    );
  }

  Widget myDeleteBox(String title, String subText) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
          color: Color(0xfff2f3f6),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(11.5, 20, 11.5, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, textScaleFactor: 1.1, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 3),
                Text(subText, textScaleFactor: 0.95,)
              ],
            )
        )
    );
  }



  void redirectToLoginPage(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    pageAnimation(context, LoginPage());
  }


  // 탈퇴 요청
  Future<void> deleteUser(int user_id) async {
    debugPrint("@@@탈퇴요청하는 백엔드");
    var url = Uri.parse(Backend.getUrl() + 'users');
    var headers = {'Content-type': 'application/json'};
    var body = json.encode({
      "user_id": user_id
    });

    final response = await http.delete(url, headers: headers, body: body);

    debugPrint("@@@" + response.statusCode.toString());

    if (response.statusCode == 200) {
      print("성공");
    } else {
      print(response.statusCode);
      throw Exception();
    }
  }
}
