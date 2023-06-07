import 'dart:convert';
import 'package:flutter/material.dart';
import '../MainSetup/ResidentManagementPage.dart';
import '../Supplementary/CustomWidget.dart';
import '../Supplementary/ThemeColor.dart';
import '/UI/Supplementary/PageRouteWithAnimation.dart';
import 'WriteCommentPage.dart';
import 'package:http/http.dart' as http; //http 사용
import 'package:test_data/Backend.dart';

ThemeColor themeColor = ThemeColor();

class UserCommentPage extends StatefulWidget {

  const UserCommentPage({
    Key? key,
    required this.userRole,
    required this.residentId
  }) : super(key: key);

  final String userRole;
  final int residentId;

  @override
  State<UserCommentPage> createState() => _UserCommentPageState();
}

class _UserCommentPageState extends State<UserCommentPage> {
  late int _letterId;
  String _userRole = '';
  int _residentId = 0;
  List<Map<String, dynamic>> _CommentList = [];

  //한마디 목록
  Future<void> getComment(int residentId) async {
    debugPrint("한마디 목록 요청 보냄");
    http.Response response = await http.get(
        Uri.parse(Backend.getUrl() + "letters/" + residentId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );
    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      _CommentList = parsedJson;
    });
  }

  //삭제
  Future<void> deleteComment(int letterid) async {
    http.Response response = await http.delete(
        Uri.parse(Backend.getUrl()+ 'letters'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        },
        body: jsonEncode({
          "letter_id": letterid
        })
    );
    if (response.statusCode == 200){
      setState(() {
        _CommentList.removeWhere((comment) => comment['letter_id'] == letterid);
      });
    } else {
      throw Exception('Failed to delete comment');
    }
  }

  @override
  void initState() {
    _userRole = widget.userRole;
    _residentId = widget.residentId;
    getComment(_residentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f8f8), //배경색
      appBar: AppBar(title: Text('한마디')),
      body: RefreshIndicator(
        child: userCommentList(),
        onRefresh: _onRefresh,
        color: themeColor.getColor(),
      ),
      floatingActionButton: _getFAB()
    );
  }

  // 새로 고침 기능 구현
  Future<void> _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 500));
    await getComment(_residentId);
  }

  Widget _getFAB() {
    if (_userRole == 'PROTECTOR') {
      return writeButton(
        context: context,
        onPressed: () async {
          //글쓰기 화면으로 이동
          await awaitPageAnimation(context, WriteCommentPage());
          getComment(_residentId);
        },
      );
    }
    else
      return Container();
  }

  // 보호자 한마디 목록
  Widget userCommentList(){
    final fontSize = 1.1;
    return ListView(
      children: [
         ListView.separated(
            itemCount: _CommentList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                padding: EdgeInsets.fromLTRB(20, 7, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_userRole != 'PROTECTOR')
                      Container(
                        child: Text(_CommentList[index]['nhr_name']!=null?_CommentList[index]['nhr_name'] + ' 님':'(탈퇴회원)', textScaleFactor: fontSize),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Text(_CommentList[index]['created_date'].toString().substring(0, 10).replaceAll('-', '.'),textScaleFactor: fontSize),
                          ),
                          if (_userRole == 'PROTECTOR')
                            Container(
                              child: OutlinedButton(
                                  style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3))),
                                  onPressed: () async {
                                    _letterId = _CommentList[index]['letter_id'];
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text("삭제하시겠습니까?"),
                                          insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                                          actions: [
                                            TextButton(
                                              child: Text('취소',style: TextStyle(color: themeColor.getColor(),),),
                                              style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('삭제',style: TextStyle(color: themeColor.getColor(),),),
                                              style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                              onPressed: () async {
                                                if (checkClick.isRedundentClick(DateTime.now())) {
                                                  return;
                                                }
                                                try {
                                                  await deleteComment(_letterId);
                                                  Navigator.of(context).pop();
                                                  showToast('삭제 완료');
                                                } catch(e) {
                                                  showToast('한마디 삭제 실패! 다시 시도해주세요');
                                                }
                                                },
                                              ),
                                            ],
                                          );
                                        }
                                    );
                                  },
                                  child: Text('삭제',style: TextStyle(color: Colors.grey))
                              ),
                            ),
                        ],
                    ),
                    Column(
                      children: [
                        if (_userRole != 'PROTECTOR')
                          SizedBox(height: 10,),
                        Text(
                          _CommentList[index]['content'],
                          textAlign: TextAlign.left,
                          textScaleFactor: fontSize
                        ),
                      ],
                    )
                  ],
                ),
              );
            }, separatorBuilder: (BuildContext context, int index) => const Divider(height: 9, color: Color(0xfff8f8f8),),  //구분선(height로 상자 사이 간격을 조절)
         ),
      ],
      physics: const AlwaysScrollableScrollPhysics(), // 여기에서 physics 속성을 추가
    );
  }
}