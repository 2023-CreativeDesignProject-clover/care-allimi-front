import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_data/Backend.dart';
import 'package:test_data/UI/Supplementary/CustomWidget.dart';
import 'package:test_data/UI/VisitRequest/VisitWritePage.dart';
import '/UI/Supplementary/ThemeColor.dart';
import '/UI/Supplementary/PageRouteWithAnimation.dart';
import 'package:http/http.dart' as http; //http 사용
import '../Supplementary/CustomClick.dart';

ThemeColor themeColor = ThemeColor();

class ManagerRequestPage extends StatefulWidget {
  const ManagerRequestPage({
    Key? key,
    required this.residentId,
    required this.userRole
  }) : super(key: key);

  final int residentId;
  final String userRole;

  @override
  State<ManagerRequestPage> createState() => _ManagerRequestPageState();
}

class _ManagerRequestPageState extends State<ManagerRequestPage> {
  final formKey = GlobalKey<FormState>();
  CheckClick checkClick = new CheckClick();
  late final TextEditingController bodyController = TextEditingController(text: '면회 신청합니다.');
  late final TextEditingController refusalController = TextEditingController();
  String selectedHour = '시간 선택';
  List<Map<String, dynamic>> _visitList = [];
  late int _residentId;
  late String _userRole;
  String _rejectReason = '';
  String? stateText;

  @override
  void initState() {
    super.initState();
    _residentId = widget.residentId;
    _userRole = widget.userRole;
    getVisitList();
  }

  // 서버에 면회신청 상태변경 WAITING -> REJECTED, APPROVED, COMPLETED
  Future<void> editState(int visit_id, String state) async {
    var url = Uri.parse(Backend.getUrl() + 'visit/approval');
    var headers = {'Content-type': 'application/json'};
    var body = json.encode({
      "visit_id": visit_id,
      "state": state,
      "rejReason": _rejectReason
    });

    final response = await http.post(url, headers: headers, body: body);

    debugPrint("@@@" + response.statusCode.toString());

    if (response.statusCode == 200) {
      print("성공");
    } else {
      throw Exception();
    }
  }


  // 서버에 면회신청 삭제요청
  Future<void> deleteVisit(int visit_id) async {
    var url = Uri.parse(Backend.getUrl() + 'visit');
    var headers = {'Content-type': 'application/json'};
    var body = json.encode({
      "visit_id": visit_id
    });

    final response = await http.delete(url, headers: headers, body: body);

    debugPrint("@@@" + response.statusCode.toString());

    if (response.statusCode == 200) {
      print("성공");
    } else {
      throw Exception();
    }
  }

  Future<void> approve(int visit_id) async {
    debugPrint("@@@@@ 면회신청 수락하는 백앤드 url 보냄");
    await editState(visit_id, "APPROVED");
  }

  Future<void> reject(int visit_id) async {
    debugPrint("@@@@@ 면회신청 거절하는 백앤드 url 보냄");
    await editState(visit_id, "REJECTED");
  }

  Future<void> complete(int visit_id) async {
    debugPrint("@@@@@ 면회 완료 백앤드 url 보냄");
    await editState(visit_id, "COMPLETED");
  }

  Future<void> getVisitList() async {
    debugPrint("@@@@@ 면회신청목록 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
        Uri.parse(Backend.getUrl() + "visit/" + _residentId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      _visitList =  parsedJson;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('면회 목록')),
        backgroundColor: Color(0xfff8f8f8), //배경색
        body: RefreshIndicator(
          child: RequestList(),
          onRefresh: _onRefresh,
          color: themeColor.getColor(),
        ),
        floatingActionButton: getButton()
    );
  }

  // 새로 고침 기능 구현
  Future<void> _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 500));
    await getVisitList();
  }

  // 면회 리스트
  Widget RequestList() {
    final fontSize = 0.95;
    return  ListView.separated(
      itemCount: _visitList.length, //면회 목록 출력 개수
      itemBuilder: (context, index) {
        return Container(
            padding: EdgeInsets.only(bottom: 8, top: 8),
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Container(
                          child: Row(
                            children: [
                              Container(
                                child: Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(_visitList[index]['residentName'].toString() + " 님 (" + _visitList[index]['visitorName'] + " 보호자님)",
                                        textScaleFactor: fontSize,), //ㅇㅇㅇ 보호자님 출력
                                      Row(
                                        children: [
                                          Flexible(    // 면회 날짜를 감싸는 Flexible 위젯 추가
                                            child: Text(
                                              _visitList[index]['want_date'].substring(0, 10).replaceAll('-', '.'),
                                              textScaleFactor: fontSize,
                                              softWrap: true,  // 글자 수가 많으면 자동으로 2줄로 넘어가게 함
                                            ),
                                          ),
                                          SizedBox(width: 7),
                                          Icon(Icons.schedule_rounded, color: Colors.grey, size: 20),
                                          SizedBox(width: 2),
                                          Flexible(    // 면회 시간을 감싸는 Flexible 위젯 추가
                                            child: Text(
                                              _visitList[index]['want_date'].substring(11, 16),
                                              textScaleFactor: fontSize,
                                              softWrap: true,  // 글자 수가 많으면 자동으로 2줄로 넘어가게 함
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),),
                              ),

                              if (_userRole == 'PROTECTOR' && _visitList[index]['state'] == 'WAITING')
                                OutlinedButton(
                                  child: Text('취소', style: TextStyle(color: Colors.grey),),
                                  style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3))),
                                  onPressed: (){
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            content: const Text('면회 신청을 취소하시겠습니까?'),
                                            actions: [
                                              TextButton(child: Text('아니오',
                                                  style: TextStyle(color: themeColor.getMaterialColor())),
                                                  style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  }),
                                              TextButton(child: Text('예',
                                                  style: TextStyle(color: themeColor.getMaterialColor())),
                                                  style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                                  onPressed: () async{
                                                    if (checkClick.isRedundentClick(DateTime.now())) { //연타 막기
                                                      return ;
                                                    }
                                                    try {
                                                      // 면회신청 취소(삭제)

                                                      await deleteVisit(_visitList[index]['visit_id']);
                                                      showToast('면회 신청을 취소하였습니다');
                                                      Navigator.of(context).pop();
                                                      getVisitList();
                                                    } catch(e) {
                                                      showDialog(
                                                          context: context,
                                                          barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              content: Text("면회 취소 실패! 다시 시도해주세요"),
                                                              insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                                                              actions: [
                                                                TextButton(
                                                                  child: const Text('확인'),
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          }
                                                      );
                                                    }
                                                  }),
                                            ],
                                          ),
                                    );
                                    getVisitList();
                                  },
                                ),
                              if (_userRole != 'PROTECTOR' && _visitList[index]['state'] == 'WAITING')
                                Row(
                                    children: [
                                      OutlinedButton(
                                        child: Text('수락', style: TextStyle(color: themeColor.getColor())),
                                        style: ButtonStyle(
                                            side: MaterialStateProperty.all(BorderSide(color: themeColor.getColor())),
                                            overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))
                                        ),
                                        onPressed: (){
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Text("면회 신청을 수락하시겠습니까?"),
                                                  insetPadding:
                                                  const EdgeInsets.fromLTRB(0, 80, 0, 80),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('취소', style: TextStyle(color: themeColor.getColor())),
                                                      style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('확인', style: TextStyle(color: themeColor.getColor())),
                                                      style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                                      onPressed: () async {
                                                        if (checkClick.isRedundentClick(DateTime.now())) { //연타 막기
                                                          return ;
                                                        }
                                                        try {

                                                          // visit approve event
                                                          await approve(_visitList[index]['visit_id']);
                                                          setState(() {
                                                            getVisitList();
                                                          });
                                                          showToast('면회 신청을 수락하였습니다');
                                                          Navigator.pop(context);
                                                        } catch (e) {
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                      ),
                                      const SizedBox(width: 3),
                                      OutlinedButton(
                                        child: const Text('거절', style: TextStyle(color: Colors.grey)),
                                        style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3))),
                                        onPressed: (){
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                AlertDialog(
                                                  title: Text('거절 사유'),
                                                  content: Form(
                                                    key: formKey,
                                                    autovalidateMode: AutovalidateMode.always,
                                                    child: TextFormField(
                                                      controller: refusalController,
                                                      validator: (value) {
                                                        if(value!.isEmpty) return '면회 거절 사유를 입력하세요';
                                                      },
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                      minLines: 1,
                                                      maxLines: 10,
                                                      decoration: const InputDecoration(
                                                        hintText: '내용을 입력하세요',
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        enabledBorder: InputBorder.none,
                                                        focusedBorder: InputBorder.none,
                                                      ),
                                                      onSaved: (value) {
                                                        _rejectReason = value!;
                                                      },
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(child: Text('취소',
                                                        style: TextStyle(color: themeColor.getMaterialColor())),
                                                        style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        }),
                                                    TextButton(child: Text('확인',
                                                        style: TextStyle(color: themeColor.getMaterialColor())),
                                                        style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                                        onPressed: () async {
                                                          if (checkClick.isRedundentClick(DateTime.now())) { //연타 막기
                                                            return ;
                                                          }

                                                          if(this.formKey.currentState!.validate()) {
                                                            this.formKey.currentState!.save();

                                                            try {
                                                              await reject(_visitList[index]['visit_id']);
                                                              setState(() {
                                                                getVisitList();
                                                              });
                                                              Navigator.pop(context);
                                                            } catch(e) {
                                                              showToast('실패하였습니다 다시 시도해주세요');
                                                              Navigator.pop(context);
                                                            }
                                                          }
                                                          Future.delayed(const Duration(milliseconds: 300), () {
                                                            refusalController.text = '';
                                                          });
                                                        }),
                                                  ],
                                                ),
                                          );
                                        },
                                      ),
                                    ]
                                ),
                              if (_userRole != 'PROTECTOR' && _visitList[index]['state'] == 'APPROVED')
                                OutlinedButton(
                                  child: Text('완료', style: TextStyle(color: themeColor.getColor())),
                                  style: ButtonStyle(
                                      side: MaterialStateProperty.all(BorderSide(color: themeColor.getColor())),
                                      overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))
                                  ),
                                  onPressed: (){
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Text("해당 보호자의 방문이 완료되었습니까?"),
                                            insetPadding:
                                            const EdgeInsets.fromLTRB(0, 80, 0, 80),
                                            actions: [
                                              TextButton(
                                                child: Text('취소', style: TextStyle(color: themeColor.getColor())),
                                                style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(child: Text('확인', style: TextStyle(color: themeColor.getColor())),
                                                style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                                onPressed: () async {
                                                  if (checkClick.isRedundentClick(DateTime.now())) { //연타 막기
                                                    return ;
                                                  }
                                                  try {
                                                    await complete(_visitList[index]['visit_id']);
                                                    setState(() {
                                                      getVisitList();
                                                    });

                                                    Navigator.of(context).pop();
                                                  } catch (e) {
                                                  }
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                ),

                            ],
                          ),
                        ),







                        SizedBox(height: 10),
                        Text(_visitList[index]['texts'], textScaleFactor: fontSize), //할 말 출력
                        Divider(thickness: 0.5),
                        if (_visitList[index]['state'] == 'WAITING')
                          Text('면회 수락 대기 중', style: TextStyle(color: Colors.grey), textScaleFactor: fontSize),
                        if (_visitList[index]['state'] == 'APPROVED')
                          Text('면회 수락\n제때 방문하세요!', style: TextStyle(color: themeColor.getColor()), textScaleFactor: fontSize),
                        if (_visitList[index]['state'] == 'REJECTED')
                          Text("면회 거절\n사유: " + _visitList[index]['rejReason'], style: TextStyle(color: Colors.red), textScaleFactor: fontSize), //거절 출력
                        if (_visitList[index]['state'] == 'COMPLETED')
                          Text("방문 완료", style: TextStyle(color: Colors.grey), textScaleFactor: fontSize), //방문 완료 출력
                      ],
                    )
                ),




              ],
            )
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
      physics: const AlwaysScrollableScrollPhysics(), // 여기에서 physics 속성을 추가
    );
  }

  //글쓰기 버튼
  Widget getButton(){

    if (_userRole == 'PROTECTOR') {
      return writeButton(
        context: context,
        onPressed: () async {
          await awaitPageAnimation(context, VisitWritePage(residentId: _residentId));

          getVisitList();
        },
      );
    } else {
      return Container();
    }

  }
}
