import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart';
import '/UI/MainSetup/ResidentManagementPage.dart';
import 'SignupPage.dart';
import 'package:http/http.dart' as http;
import 'package:test_data/Backend.dart';
import '../Supplementary/ThemeColor.dart';
import '/UI/Supplementary/CustomWidget.dart';

ThemeColor themeColor = ThemeColor();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  late String _id;
  late String _password;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid ID: $_id, password: $_password');
      return true;
    } else {
      print('Form is invalid ID: $_id, password: $_password');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('💫', style: GoogleFonts.notoColorEmoji(fontSize: 55)),
                      SizedBox(height: 10),
                      Text('요양원 알리미', textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('로그인을 진행해주세요', textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 50),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
                        ],
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_rounded, color: Colors.grey),
                          hintText: '아이디',
                          hintStyle: TextStyle(fontSize: 16),
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
                        validator: (value) =>
                        value!.isEmpty ? '아이디를 입력하세요' : null,
                        onSaved: (value) => _id = value!,
                      ), //아이디
                      SizedBox(height: 7),
                      TextFormField(
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp('[ㄱ-ㅎㅏ-ㅣ가-힣]')), //한글 빼고 전부 입력 가능
                        ],
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_rounded, color: Colors.grey,),
                          hintText: '비밀번호',
                          hintStyle: TextStyle(fontSize: 16),
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
                        validator: (value) =>
                        value!.isEmpty ? '비밀번호를 입력하세요' : null,
                        onSaved: (value) => _password = value!,
                      ), //비번
                      SizedBox(height: 100),
                      TextButton (
                          child: Container(
                              width: double.infinity,
                              child: Text('로그인', textScaleFactor: 1.2, textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)),
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(Colors.white10),
                              backgroundColor: MaterialStateProperty.all(themeColor.getColor()),
                              padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
                          ),
                          onPressed: () async {
                            if (checkClick.isRedundentClick(DateTime.now())) {
                              return;
                            }
                            if (validateAndSave() == true) {
                              var data;

                              try {
                                data = await loginRequest(_id, _password);
                              } catch(e) {
                                showToast('아이디 또는 비밀번호가 일치하지 않습니다');
                                return;
                              }

                              var json_data = json.decode(data);

                              var userRole = '';
                              if (json_data['user_role'] != null) {
                                userRole = json_data['user_role'];
                                var residentData = await getResidentInfo(json_data['user_id']);
                                var jsonResidentData = json.decode(residentData);

                                Provider.of<ResidentProvider>(context, listen:false)
                                    .setInfo(jsonResidentData['nhr_id'], jsonResidentData['facility_id'], jsonResidentData['facility_name'], jsonResidentData['resident_name'],
                                    json_data['user_role'],'', '');

                              }

                              var residentData = await getResidentInfo(json_data['user_id']);
                              var jsonResidentData = json.decode(residentData);

                              Provider.of<UserProvider>(context, listen:false)
                                  .setInfo(json_data['user_id'], userRole, _id, json_data['phone_num'], json_data['user_name']);

                              Provider.of<UserProvider>(context, listen: false)
                                  .getData();
                            }
                          }
                      ),
                      Row(
                        children: [
                          Text('처음 오셨나요?', style: TextStyle(color: Colors.grey)),
                          Spacer(),
                          TextButton (
                            child: Text('회원가입', style: TextStyle(color: Colors.grey)),
                            style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: SignupPage(),
                                ),
                              );
                            },
                          ),
                          Icon(Icons.chevron_right_rounded, color: Colors.grey,),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
    ),
      onWillPop: () async {
        bool shouldClose = onWillPop();
        if (shouldClose) {
          SystemNavigator.pop();
        }
        return false;
      },);
  }
}

//-----------------------백엔드에 요청보내는 코드-----------------------//

//입소자 정보 받아오는 url
Future<String> getResidentInfo(int userId) async {
  debugPrint("@@@@@ 입소자 정보 받아오는 백앤드 url 보냄");
  http.Response response = await http.get(
    Uri.parse(Backend.getUrl()+ 'users/nhrs/' + userId.toString()),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Accept-Charset': 'utf-8'
    }
  );

  return utf8.decode(response.bodyBytes);
}

//로그인 요청 받는 request
Future<String> loginRequest(String id, String password) async {
    debugPrint("@@@@@ 로그인 백앤드 url 보냄");

  http.Response response = await http.post(
    Uri.parse(Backend.getUrl()+"login"),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Accept-Charset': 'utf-8'
    },
    body: jsonEncode({
      "login_id": id,
      "password": password,
    }),
  );

  if (response.statusCode != 200)
    throw Exception();

  return utf8.decode(response.bodyBytes); //반환받은 데이터(user_id, userRole) 반환
}