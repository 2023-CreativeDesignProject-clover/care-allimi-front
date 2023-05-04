import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //http 사용

String backendUrl = "http://13.125.155.244:8080/v2/";


class ManagerSecondAllimPage extends StatefulWidget {
  const ManagerSecondAllimPage({
    Key? key,
    required this.noticeId
  }) : super(key: key);

  final int noticeId;

  @override
  State<ManagerSecondAllimPage> createState() => _ManagerSecondAllimPageState();
}

class _ManagerSecondAllimPageState extends State<ManagerSecondAllimPage> {
  late int _noticeId;
  late Map<String, dynamic> _noticeDetail = Map<String, dynamic>();
  late List<String> _imageUrls = [];

  void initState() {
    _noticeId = widget.noticeId;
  }

  Future<void> deleteNotice(int noticeId) async {
    http.Response response = await http.delete(
        Uri.parse(backendUrl+ 'notices'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        },
        body: jsonEncode({
          "notice_id": noticeId
        })
    );

    if (response != 200)
      throw Exception();
  }

  Future<void> getNoticeDetail() async {
    http.Response response = await http.get(
        Uri.parse(backendUrl+ 'notices/detail/' + _noticeId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    debugPrint(backendUrl+ 'notices/detail/' + _noticeId.toString());

    if (response.statusCode != 202) {
      throw Exception('POST request failed');
    }

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);

    Map<String, dynamic> parsedJson = Map<String, dynamic>.from(decodedJson);
    _noticeDetail = parsedJson;

    _imageUrls = List<String>.from(parsedJson['image_url']);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('알림장 내용'),
      ),
      body: eachmanager(),

    );
  }
  //시설장 및 직원 알림장(각 목록)
  Widget eachmanager() {
    return FutureBuilder(
        future: getNoticeDetail(),
        builder: (context, snap) {
          if (_noticeDetail['notice_id'] == null)
            return Text("asdf");

          return SingleChildScrollView(
              child: Column(
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
                            Text(
                              '삼족오 보호자님',
                              style: TextStyle(fontSize: 13),
                            ),
                            Text(
                              _noticeDetail['create_date'].toString().substring(0, 10), //TODO 2023-03-30으로 바꾸기
                              style: TextStyle(fontSize: 10),
                            ),
                          ],

                        ),
                        Spacer(),
                        Container(
                          child: OutlinedButton(
                              onPressed: (){
                                //수정 화면으로 넘어가기
                              },
                              child: Text('수정')
                          ),

                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          //alignment: Alignment.centerRight,
                          child: OutlinedButton(
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text("정말 삭제하시겠습니까>"),
                                        insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                                        actions: [
                                          TextButton(
                                            child: const Text('삭제'),
                                            onPressed: () async {
                                              try {
                                                await deleteNotice(_noticeId);
                                              } catch(e) {
                                              }

                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('취소'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                );
                              },
                              child: Text('삭제')
                          ),
                        ),
                      ],
                    ),
                  ),

                  // //알림장 사진
                  // Container(
                  //     margin: EdgeInsets.fromLTRB(0,10,0,0),
                  //     width: double.infinity,
                  //     color: Colors.white,
                  //     height: 300,
                  //     child: Container(
                  //       child: Image.asset('assets/images/tree.jpg', fit: BoxFit.fill,),
                  //     )
                  // ),

                  Column(
                      children: [
                        for (int i =0; i< _imageUrls.length; i++ ) ...[
                          Image.network(_imageUrls[i], fit: BoxFit.fill,),
                        ]
                      ]
                  ),

                  //알림장 세부 내용
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(7,7,7,7),
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      _noticeDetail['content'].toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),

                  //알림장 안에 있는 어르신의 일일정보
                  informdata(_noticeDetail['sub_content'].toString())
                ],
              )

          );
        }
    );
  }

  //알림장 안에 있는 어르신의 일일정보 함수
  Widget informdata(String info){
    List<String> result = info.split('\n');

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(7,7,7,7),
      child: Column(
        children: [
          inform('아침',result[0]),
          Divider(thickness: 0.5,),
          inform('점심',result[1]),
          Divider(thickness: 0.5,),
          inform('저녁',result[2]),
          Divider(thickness: 0.5,),
          inform('투약',result[3]),
        ],
      ),
    );
  }

  Widget inform(String text1, String text2){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(right: 30),
          child: Text(
            '$text1',
            style: TextStyle(fontSize: 15,color: Colors.black38),
          ),
        ),
        Text('$text2',style: TextStyle(fontSize: 15,color: Colors.black),),
      ],
    );
  }

}



