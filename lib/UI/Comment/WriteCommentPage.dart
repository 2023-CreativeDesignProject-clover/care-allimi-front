import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart';
import 'package:flutter/material.dart';
import '../MainSetup/ResidentManagementPage.dart';
import '../Supplementary/CustomWidget.dart';
import '/UI/Supplementary/PageRouteWithAnimation.dart';
import '/UI/Supplementary/ThemeColor.dart';
import 'package:http/http.dart' as http; //http 사용
import 'package:test_data/Backend.dart';

ThemeColor themeColor = ThemeColor();

class WriteCommentPage extends StatefulWidget {
  const WriteCommentPage({Key? key}) : super(key: key);

  @override
  State<WriteCommentPage> createState() => _WriteCommentPageState();
}

class _WriteCommentPageState extends State<WriteCommentPage> {
  final formKey = GlobalKey<FormState>();
  String _contents = '';

  // 서버에 한마디 업로드
  Future<void> addComment(userId, nhresidentid, facilityId) async {
    var url = Uri.parse(Backend.getUrl() + 'letters');
    var headers = {'Content-type': 'application/json'};
    var body = json.encode({
      "user_id": userId,
      "nhresident_id": nhresidentid,
      "facility_id": facilityId,
      "contents": _contents,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print("성공");
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer2<UserProvider, ResidentProvider> (
          builder: (context, userProvider, residentProvider, child){
            return customPage(
              title: '한마디 작성',
              onPressed: () async {
                print('한마디');
                if (checkClick.isRedundentClick(DateTime.now())) {  //연타막기
                  return;
                }

                if(this.formKey.currentState!.validate()) {
                  this.formKey.currentState!.save();

                  showDialog(
                      context: context,
                      barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text("한마디를 업로드하시겠습니까?"),
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
                              child: Text('확인',style: TextStyle(color: themeColor.getColor(),),),
                              style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                              onPressed: () async {
                                try {
                                  if (checkClick.isRedundentClick(DateTime.now())) { //연타 막기
                                    return ;
                                  }
                                  await addComment(userProvider.uid, residentProvider.resident_id, residentProvider.facility_id);
                                  showToast('작성 완료');
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                } catch(e) {
                                  print(e);
                                  showToast('한마디 업로드 실패! 다시 시도해주세요');
                                }
                              },
                            ),
                          ],
                        );
                      }
                  );
                }},
              body: commentWrite(),
              buttonName: '완료',
            );
          }
      ),
    );
  }

  //한마디 작성페이지
  Widget commentWrite(){
    String currentDate = DateTime.now().toString().substring(0, 10).replaceAll('-', '.');
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          text('날짜'),

          Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey.shade300, width: 1)
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(11.5, 0, 11.5, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(currentDate, textScaleFactor: 1.1,),
                  ],
                ),
              )
          ),

          SizedBox(height: 10,),
          text('한마디 작성'),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: createField(),
          ),
        ],
      ),
    );
  }
  
  //한마디 내용
  Widget createField() {
    return Form(
      key: formKey,
      child: SizedBox(
        height: 300,
        child: TextFormField(
          style: TextStyle(fontSize: 16), // 폰트 크기 지정
          validator: (value) {
            if(value!.isEmpty) { return '내용을 입력하세요'; }
            else { return null; }
          },
          maxLines: 100,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: '요양보호사님께 간단한 메시지를 전송할 수 있어요\n\n예시) 필요한 물품을 택배로 보냈습니다',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 2, color: Colors.red),
            ),
          ),
          onSaved: (value) {
            _contents = value!;
          }
        ),
      ),
    );
  }

  //글자 출력
  Widget text(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
      child: Text('$text',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
