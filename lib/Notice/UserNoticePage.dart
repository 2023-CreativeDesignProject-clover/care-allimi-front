import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import '../Supplementary/PageRouteWithAnimation.dart';
import '/Supplementary/ThemeColor.dart';
import 'package:http/http.dart' as http; //http 사용

ThemeColor themeColor = ThemeColor();

List<String> temp = ['5월 방역 일정', '면회 시 주의 사항'];
List<String> dateList =['2022.12.23','2022.12.24','2022.12.25'];
List<String> titleList =['요양원 공원 공사 안내', '필요 물품 안내', '방역 실시 안내'];
List<String> imgList = [
  'assets/images/tree.jpg',
  'assets/images/tree.jpg',
  ''
];

String backendUrl = "http://13.125.155.244:8080/v2/";


class UserNoticePage extends StatefulWidget {
  const UserNoticePage({Key? key}) : super(key: key);

  @override
  State<UserNoticePage> createState() => _UserNoticePageState();
}

class _UserNoticePageState extends State<UserNoticePage> {

  List<Map<String, dynamic>> _notices = []; // 수정된 부분

  Future<void> _getNotice(int residentId) async {
    http.Response response = await http.get(
      Uri.parse(backendUrl + "notices/" + residentId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      }
    );

    // "user_name": "string", "phone_num": "string", "login_id": "string"
    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      _notices = parsedJson;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('공지사항')),
      body: Consumer<ResidentProvider>(
        builder: (context, residentProvider, child) {
          return FutureBuilder(
            future: _getNotice(residentProvider.resident_id),
            builder: (context, snap) {
              if (snap.hasData) {
                return ListView(
                  children: [
                    noticeList(),
                  ],
                );
               }
              return Container();
            }
          );
        }
      ),
      //floatingActionButton: ,
    );
  }


  //중요 공지 글자 오버플로우 처리
  Widget textNotice(String title) {
    return Container(
      child: Container(child: Text(title, overflow: TextOverflow.ellipsis), width: MediaQuery.of(context).size.width * 0.65),
    );
  }

  // //중요 공지 출력
  // Widget importantNotice() {
  //   return ListView.builder(
  //     itemCount: temp.length, //중요 공지 출력 개수
  //     shrinkWrap: true,
  //     physics: NeverScrollableScrollPhysics(),
  //     itemBuilder: (context, index) {
  //       return Container(
  //         height: 50,
  //         //padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
  //         color: Colors.white,
  //         child: ListTile(
  //           leading: Text('중요', style: TextStyle(color: themeColor.getColor(), fontWeight: FontWeight.bold)),
  //           title: textNotice(temp[index]),
  //           onTap: () {
  //             print('${temp[index]} Tap');
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  //공지사항 목록
  Widget noticeList() {
    return ListView.separated(
      itemCount: _notices.length, //공지 목록 출력 개수
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {

        return Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          color: Colors.white,
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        child: Text(_notices[index][''], overflow: TextOverflow.ellipsis), //공지사항 제목
                        width: MediaQuery.of(context).size.width * 0.5),
                    Text(dateList[index]), //공지사항 날짜
                  ],
                ),
                Container(
                  width: 100,
                  height: 100,
                  child: Container( //공지사항 목록에서 이미지 출력
                    child: imgList[index].isNotEmpty ? Container(child: Image.asset(imgList[index], fit: BoxFit.fill)) : Container(),
                  ),
                )
              ],
            ),
            onTap: () {
              print('공지 목록: ${titleList[index]} Tap');
              pageAnimation(context, noticeUserPage(index)); //공지사항 내용으로 이동
            },
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
    );
  }

  //보호자 버전 - 공지 상세 내용
  Widget noticeUserPage(int index) {
    return Scaffold(
      appBar: AppBar(title: Text('공지사항 내용')),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(titleList[index]), //공지 제목
                        Text(dateList[index]), //공지 게시한 날짜
                      ],
                    ),
                  ],
                ),
              ),

              //공지사항 사진
              Container(
                  margin: EdgeInsets.fromLTRB(0,10,0,0),
                  width: double.infinity,
                  color: Colors.white,
                  height: imgList[index].isNotEmpty ? 300 : null,
                  child: Container(
                      child: imgList[index].isNotEmpty
                          ? Container(
                        child: Image.asset(imgList[index], fit: BoxFit.fill,),
                      )
                          : null
                  )
              ),

              //공지사항 세부 내용
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(7,7,7,7),

                child: Text('공지사항 내용: ${titleList[index]} ${titleList[index]} ${titleList[index]} ${titleList[index]} ${titleList[index]}'),
              ),
            ],
          )
        ],
      ),
    );
  }




}
