import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_data/exception/InvitAlreadyExistsException.dart';
import 'package:test_data/exception/ResidentAlreadyExistsException.dart';
import 'ResidentManagementPage.dart';
import '../Supplementary/CustomWidget.dart';
import '../Supplementary/PhoneTextInputFormatter.dart';
import '../Supplementary/ThemeColor.dart';
import '/provider/ResidentProvider.dart';
import '/UI/Supplementary/PageRouteWithAnimation.dart';
import 'package:http/http.dart' as http; //http 사용
import 'package:test_data/Backend.dart';

//초대하기 화면
ThemeColor themeColor = ThemeColor();

class InvitePage extends StatefulWidget {
  const InvitePage({Key? key}) : super(key: key);

  @override
  State<InvitePage> createState() => _InvitePageState();
}
enum Answer {PROTECTOR, WORKER}

class _InvitePageState extends State<InvitePage> {
  final _contentEditController = TextEditingController();

  String result = 'PROTECTOR';
  bool isprotect = true;
  bool isemployee = false;
  late List<bool> isSelected;
  List<Map<String, dynamic>> _phoneNumUsers = [];
  late String _phone_num;

  @override
  void initState() {
    isSelected = [isprotect, isemployee];
    super.initState();
  }

  final formKey = GlobalKey<FormState>();

  // 전화번호 받아오기
  Future<void> getUserByPhoneNum(String phoneNum) async {
    debugPrint("@@@@@ 전화번호로 user목록 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
      Uri.parse(Backend.getUrl() + "users/phone-num/" + phoneNum),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      _phoneNumUsers =  parsedJson;
    });
  }

  // 서버에 초대하기 업로드
  Future<void> addInvite(phone_userId, facilityId, userRole) async {
    var url = Uri.parse(Backend.getUrl() + 'invitations');
    var headers = {'Content-type': 'application/json'};
    var body = json.encode({
      "user_id": phone_userId,
      "facility_id": facilityId,
      "user_role": userRole,
    });

    final response = await http.post(url, headers: headers, body: body);
    
    if (response.statusCode == 200) {
      print("성공");
    } else if (response.statusCode == 409) { //이미 같은 초대장이 존재
      throw InvitAlreadyExistsException("이미 존재하는 초대장");
    } else if (response.statusCode == 406) { //이미 존재하는 입소자
      throw ResidentAlreadyExistsException("이미 존재하는 입소자");
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ResidentProvider> (
        builder: (context, residentProvider, child){
          return customPage(
            title: '초대하기',
            buttonName: '확인',
            onPressed: () async {
              if(this.formKey.currentState!.validate()) {
                this.formKey.currentState!.save();

                if(_phoneNumUsers.length != 0){

                  //전화번호 리스트 출력
                  showDialog(
                      context: context,
                      barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("초대할 사람을 선택해주세요"),
                          insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                          actions: [
                            TextButton(
                              style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                              child: Text('다시 작성하기',style: TextStyle(color: themeColor.getColor(),),),
                              onPressed: () {
                                _phoneNumUsers = [];
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                          content: Container(
                            height: _phoneNumUsers.length >= 8? 400: (50 * _phoneNumUsers.length).toDouble(),
                            width: 300,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _phoneNumUsers.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    ListTile(
                                        title: Text(_phoneNumUsers[index]['user_name']),
                                        onTap: () async {
                                          if (checkClick.isRedundentClick(DateTime.now())) {
                                            return;
                                          }
                                          try {
                                            await addInvite(_phoneNumUsers[index]['user_id'], residentProvider.facility_id, result);
                                          } catch(e) {
                                            String errorMessage = '';

                                            if (e.runtimeType == InvitAlreadyExistsException)  //중복된 아이디
                                              errorMessage = '이미 동일한 초대장이 존재합니다';
                                            else if (e.runtimeType == ResidentAlreadyExistsException)
                                              errorMessage = '이미 등록된 사용자입니다';
                                            else
                                              errorMessage = '초대하기에 실패하였습니다';

                                            showDialog(
                                                context: context,
                                                barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    content: Text(errorMessage),
                                                    insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                                                    actions: [
                                                      TextButton(
                                                        style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                                        child: Text('확인',style: TextStyle(color: themeColor.getColor(),),),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                }
                                            );
                                            return;
                                          }
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          showToast('초대하였습니다');
                                        })
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      }
                  );
                }
                try {
                  await getUserByPhoneNum(_phone_num);
                  setState(() {});
                  if(_phoneNumUsers.length == 0){
                    return showToast('회원가입을 하지 않은 전화번호입니다!\n다시 확인해주세요');
                  }
                } catch(e) {
                  showToast('초대 실패! 다시 시도해주세요');
                }
              }},
            body: inviteFormat(),
          );
        }
    );

  }
  Widget inviteFormat(){
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index){
          return Container(
            child: Column(
              children: [
                Container(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(20),
                    title: Text(
                        '초대하실 유형을 선택해주세요',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textScaleFactor: 0.95
                    ),
                    subtitle: Column(
                      children: [
                        SizedBox(height: 10,),
                        Container(
                          width: double.infinity,
                          child: LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints constraints) {
                              final buttonWidth = constraints.maxWidth / 2.03; // 토글 버튼의 너비
                              return ToggleButtons(
                                constraints: BoxConstraints.tight(Size(buttonWidth, buttonWidth)),
                                children: [
                                  Text('보호자', textScaleFactor: 1.1),
                                  Text('직원', textScaleFactor: 1.1),
                                ],
                                isSelected: isSelected,
                                onPressed: toggleSelect,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                selectedBorderColor: themeColor.getColor(),
                                selectedColor: Colors.white,
                                fillColor: themeColor.getColor(),
                                color: themeColor.getColor(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(left: 20,top: 12, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10,),
                        Text(
                            '전화번호',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textScaleFactor: 1.1
                        ),
                        SizedBox(height: 8,),
                        Form(
                          key: formKey,
                          child: SizedBox(
                            child: TextFormField(
                              controller: _contentEditController,
                              inputFormatters: [
                                PhoneTextInputFormatter()
                              ],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '전화번호를 입력하세요';
                                } else if (value.length < 12) {
                                  return '전화번호를 정확히 입력하세요';
                                }
                                return null;
                              },
                              onSaved: (value){
                                _phone_num = value!.replaceAll("-", "");
                              },
                              keyboardType: TextInputType.number, //키보드는 숫자
                              maxLines: 1,
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
                            ),
                          ),
                        ),
                        SizedBox(height: 60,),
                      ],
                    )
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  void toggleSelect(value) {
    if (value == 0) {
      isprotect = true;
      isemployee = false;
      result = 'PROTECTOR';
    } else {
      isprotect = false;
      isemployee = true;
      result = 'WORKER';
    }
    setState(() {
      isSelected = [isprotect, isemployee];
    });
  }
}