import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_data/UI/Supplementary/CustomWidget.dart';
import 'package:test_data/UI/VisitRequest/SelectedTimePage.dart';
import 'package:test_data/provider/VisitTempProvider.dart';
import '/UI/Supplementary/ThemeColor.dart';
import '/UI/Supplementary/PageRouteWithAnimation.dart';
import 'SelectedDatePage.dart';
import 'package:http/http.dart' as http; //http 사용
import '../Supplementary/CustomClick.dart';
import 'package:test_data/Backend.dart';

ThemeColor themeColor = ThemeColor();

class VisitWritePage extends StatefulWidget {
  const VisitWritePage({
    Key? key,
    required this.residentId
  }) : super(key: key);

  final int residentId;

  @override
  State<VisitWritePage> createState() => _VisitWritePageState();
}

class _VisitWritePageState extends State<VisitWritePage> {
  CheckClick checkClick = new CheckClick();
  late final TextEditingController bodyController = TextEditingController(text: '면회 신청합니다.');
  late final TextEditingController refusalController = TextEditingController();
  String _text = '';
  final formKey = GlobalKey<FormState>();
  late int _residentId;

  @override
  void initState() {
    super.initState();
    _residentId = widget.residentId;
    Provider.of<VisitTempProvider>(context, listen: false).setDate('방문 날짜 선택'); //초기화
    Provider.of<VisitTempProvider>(context, listen: false).setTime('방문 시간 선택');
  }

  // 서버에 면회신청 업로드
  Future<void> addVisit(String date, String time) async {
    //2023.05.10  //04:00

    String datetimeConvert = date.replaceAll('.', '-') + 'T' + time + ":00.000Z";

    debugPrint("@@@@@ 면회신청 추가하는 백앤드 url 보냄");
    var url = Uri.parse(Backend.getUrl() + 'visit');
    var headers = {'Content-type': 'application/json'};
    var body = json.encode({
      "protector_id": _residentId,
      "texts": _text, 
      "dateTime": datetimeConvert 
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print("성공");
    } else {
      print(response.statusCode);
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: writePage()
    );
  }

    //글쓰기 화면
  Widget writePage() {
    return customPage(
      title: '면회 신청',
      buttonName: '접수',
      onPressed: () {
        if(this.formKey.currentState!.validate()) {
          this.formKey.currentState!.save();

          final visitTempProvider = context.read<VisitTempProvider>();
          final String selectedDate = visitTempProvider.selectedDate;
          final String selectedTime = visitTempProvider.selectedTime;

          if(selectedDate == '방문 날짜 선택') {
            showDialog(
                context: context,
                barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text("방문 날짜를 선택하세요!"),
                    insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                    actions: [
                      TextButton(
                        child: Text('확인',style: TextStyle(color: themeColor.getColor(),),),
                        style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                }
            );
          } else if(selectedTime == '방문 시간 선택') {
            showDialog(
                context: context,
                barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text("방문 시간을 선택하세요!"),
                    insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                    actions: [
                      TextButton(
                        child: Text('확인',style: TextStyle(color: themeColor.getColor(),),),
                        style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                }
            );
          } else {
            showDialog(
                context: context,
                barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                builder: (BuildContext context) {
                  return Consumer<VisitTempProvider>(
                      builder: (context, visitProvider, child) {
                        return AlertDialog(
                          content: Text("면회를 신청하시겠습니까?"),
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
                                  await addVisit(visitProvider.selectedDate, visitProvider.selectedTime);

                                  showToast('작성 완료');

                                  Navigator.of(context).pop();Navigator.of(context).pop();
                                } catch(e) {
                                  showToast('면회 신청 실패! 다시 시도해주세요');
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ],
                        );

                      }
                  );
                }
            );
          }


        }

      },
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            text('방문 날짜'),
            SelectedDatePage(),
            SizedBox(height: 10,),
            text('방문 시간'),
            SelectedTimePage(),
            SizedBox(height: 10,),
            text('할 말 (최대 500글자까지 작성 가능)'),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: textFormField(),
            ),
          ],
        ),
      )
    );
      
  }

  //할 말
  Widget textFormField() {
    return Form(
      key: formKey,
      child: SizedBox(
        height: 200,
        child: TextFormField(
          style: TextStyle(fontSize: 16), // 폰트 크기 지정
          controller: bodyController,
          maxLines: 100,
          inputFormatters: [LengthLimitingTextInputFormatter(500)], //최대 500글자까지 작성 가능
          textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
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
            validator: (value) {
              if(value!.isEmpty) { return '내용을 입력하세요'; }
              else { return null; }
            },
          onSaved: (value) {
            _text = value!;
          }
        ),
      )
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
