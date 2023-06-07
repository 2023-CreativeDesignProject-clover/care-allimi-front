import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:test_data/UI/Allim/ModificationAllimPage.dart';
import 'package:test_data/UI/Supplementary/PageRouteWithAnimation.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/Backend.dart';
import '../MainSetup/ResidentManagementPage.dart';
import '../Supplementary/CustomWidget.dart';
import '../Supplementary/ThemeColor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

ThemeColor themeColor = ThemeColor();
final fontSize = 1.1;

class ManagerSecondAllimPage extends StatefulWidget {
  const ManagerSecondAllimPage(
      {Key? key, required this.noticeId, required this.userRole})
      : super(key: key);

  final int noticeId;
  final String userRole;

  @override
  State<ManagerSecondAllimPage> createState() => _ManagerSecondAllimPageState();
}

class _ManagerSecondAllimPageState extends State<ManagerSecondAllimPage> {
  late int _noticeId;
  late Map<String, dynamic> _noticeDetail = Map<String, dynamic>();
  late List<String> _imageUrls = [];
  late String _userRole;

  @override
  void initState() {
    _noticeId = widget.noticeId;
    _userRole = widget.userRole;
    getNoticeDetail();
  }

  //삭제
  Future<void> deleteNotice(int noticeId) async {
    http.Response response = await http.delete(
        Uri.parse(Backend.getUrl() + 'notices'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        },
        body: jsonEncode({"notice_id": noticeId}));

    debugPrint("@@@statusCode= " + response.statusCode.toString());

    if (response.statusCode != 200) throw Exception();
  }

  //알림장 상세정보
  Future<void> getNoticeDetail() async {
    debugPrint("@@@@@ 알림장 상세정보 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
        Uri.parse(Backend.getUrl() + 'notices/detail/' + _noticeId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        });

    if (response.statusCode != 200) {
      throw Exception('POST request failed');
    }

    var data = utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);

    Map<String, dynamic> parsedJson = Map<String, dynamic>.from(decodedJson);
    _noticeDetail = parsedJson;
    _imageUrls = List<String>.from(parsedJson['image_url']);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림장 내용'),
      ),
      body: eachmanager(),
    );
  }

  //시설장 및 직원 알림장(각 목록)
  Widget eachmanager() {
    if (_noticeDetail['notice_id'] == null)
      return Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: SpinKitFadingCircle(color: Colors.grey, size: 30)));

    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: [
                if (_userRole != 'PROTECTOR')
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_noticeDetail['target_name'] + ' 님',textScaleFactor: fontSize,),
                        Text(
                          _noticeDetail['create_date']
                              .toString()
                              .substring(0, 10)
                              .replaceAll('-', '.'), // 2023-03-30으로 바꾸기
                          textScaleFactor: fontSize
                        ),
                      ],
                    ),
                  ),
                if (_userRole == 'PROTECTOR')
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_noticeDetail['target_name'] + ' 님',textScaleFactor: fontSize,),
                        Text(
                          _noticeDetail['create_date']
                              .toString()
                              .substring(0, 10)
                              .replaceAll('-', '.'), // 2023-03-30으로 바꾸기
                          textScaleFactor: fontSize
                        ),
                      ],
                    ),
                  ),
                Container(
                  child: Row(
                    children: [
                      if (_userRole != 'PROTECTOR'&& _noticeDetail['writer_id'] == Provider.of<ResidentProvider>(context, listen: false).resident_id)
                        Container(
                          child: Consumer<ResidentProvider>(
                              builder: (context, residentProvider, child) {
                            return OutlinedButton(
                                style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3))),
                                onPressed: () async {
                                  //수정 화면으로 이동
                                  await awaitPageAnimation(context, EditAllimPage(
                                    noticeId: _noticeId,
                                    residentId: residentProvider.resident_id,
                                    targetName: _noticeDetail['target_name'],
                                    targetId: _noticeDetail['target_id'],
                                    noticeDetail: _noticeDetail,
                                    imageUrls: _imageUrls,
                                    facility_id:
                                    residentProvider.facility_id,
                                  ));
                                  getNoticeDetail();
                                  showToast('수정 완료');
                                },
                                child: Text('수정',
                                    style: TextStyle(color: Colors.grey)));
                          }),
                        ),
                      if (_userRole != 'PROTECTOR'&& _noticeDetail['writer_id'] == Provider.of<ResidentProvider>(context, listen: false).resident_id)
                        Container(
                          padding: EdgeInsets.all(5),
                          child: OutlinedButton(
                              style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3))),
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text("삭제하시겠습니까?"),
                                        insetPadding: const EdgeInsets.fromLTRB(
                                            0, 80, 0, 80),
                                        actions: [
                                          TextButton(
                                            style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                            child: Text('취소', style: TextStyle(color: themeColor.getColor()),),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                            child: Text('삭제', style: TextStyle(color: themeColor.getColor(),),),
                                            onPressed: () async {
                                              try {
                                                if (checkClick.isRedundentClick(DateTime.now())) {
                                                  return;
                                                }
                                                await deleteNotice(_noticeId);
                                                showToast('삭제 완료');
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              } catch (e) {
                                                showToast('알림장 삭제 실패! 다시 시도해주세요');
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Text('삭제',
                                  style: TextStyle(color: Colors.grey))),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(padding: EdgeInsets.all(10), child: Divider(thickness: 0.5)),

          //이미지
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(children: [
              for (int i = 0; i < _imageUrls.length; i++) ...[
                CachedNetworkImage(
                  imageUrl: _imageUrls[i],
                  fit: BoxFit.fill,
                  progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                    child: SpinKitFadingCircle(
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error_rounded, color: Colors.grey),
                ),
                SizedBox(height: 10),
              ],
            ]),
          ),
          //알림장 세부 내용
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              _noticeDetail['content'].toString(), textScaleFactor: fontSize
            ),
          ),
          SizedBox(height: 30),
          //알림장 안에 있는 어르신의 일일정보
          informdata(_noticeDetail['sub_content'].toString())
      ],
    ));
  }

  //알림장 안에 있는 어르신의 일일정보 함수
  Widget informdata(String info) {
    List<String> result = info.split('\n');

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
      child: Column(
        children: [
          inform('아침', result[0]),
          Divider(
            thickness: 0.5,
          ),
          inform('점심', result[1]),
          Divider(
            thickness: 0.5,
          ),
          inform('저녁', result[2]),
          Divider(
            thickness: 0.5,
          ),
          inform('투약', result[3]),
        ],
      ),
    );
  }

  Widget inform(String text1, String text2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(right: 30),
          child: Text(
            textScaleFactor: fontSize,
            '$text1',
            style: TextStyle(color: Colors.black38),
          ),
        ),
        Text(
          textScaleFactor: fontSize,
          '$text2',
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
