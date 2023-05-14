import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'LoginPage.dart';
import 'Supplementary/PageRouteWithAnimation.dart';
import 'package:http/http.dart' as http; //http 사용
import 'package:google_fonts/google_fonts.dart';
import 'package:test_data/Backend.dart';
import '../Supplementary/ThemeColor.dart';
import 'package:test_data/Supplementary/CustomWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';

ThemeColor themeColor = ThemeColor();
String backendUrl = Backend.getUrl();
Future<String> signUpRequest(String id, String password, String name, String phoneNum) async {
    debugPrint("@@@@@ 회원가입 백앤드 url 보냄");

  http.Response response = await http.post(
    Uri.parse(backendUrl+"users"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      "login_id": id,
      "password": password,
      "name": name,
      "phone_num": phoneNum
    }),
  );

  debugPrint("@@StatusCode: " + response.statusCode.toString());

    // 응답 코드가 200 OK가 아닐 경우 예외 처리
  if (response.statusCode == 500) {
    throw Exception('POST request failed');
  }
  else if (response.statusCode == 400) {
    throw FormatException();
  }
  
  return response.body;
}

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = new GlobalKey<FormState>();

  late String _id;
  late String _password;
  late String _username;
  late String _tel;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid ID: $_id, password: $_password,Form is valid name: $_username, tel: $_tel');
      return true;
    } else {
      print('Form is invalid ID: $_id, password: $_password,Form is invalid name: $_username, tel: $_tel');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Text('🥳', style: GoogleFonts.notoColorEmoji(fontSize: 55)),
                    SizedBox(height: 10),
                    Text('회원가입을', textScaleFactor: 1.6, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('진행해주세요', textScaleFactor: 1.6, style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 50),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_rounded, color: Colors.grey),
                        hintText: '아이디',
                        hintStyle: TextStyle(fontSize: 15),
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
                    ),
                    SizedBox(height: 7,),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_rounded, color: Colors.grey),
                        hintText: '비밀번호',
                        hintStyle: TextStyle(fontSize: 15),
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
                    ),
                    SizedBox(height: 7,),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.people_rounded, color: Colors.grey),
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
                        hintText: '이름',
                        hintStyle: TextStyle(fontSize: 15),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? '이름을 입력하세요' : null,
                      onSaved: (value) => _username = value!,
                    ),
                    SizedBox(height: 7,),
                    TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, //숫자만 가능
                      ],
                      keyboardType: TextInputType.number, //키보드는 숫자
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone_rounded, color: Colors.grey),
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
                        hintText: '전화번호',
                        hintStyle: TextStyle(fontSize: 15),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? '전화번호를 입력하세요' : null,
                      onSaved: (value) => _tel = value!,
                    ),
                    SizedBox(height: 50),
                    TextButton (
                        child: Container(
                            width: double.infinity,
                            child: Text('가입하기', textScaleFactor: 1.2, textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)),
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(Colors.white10),
                            backgroundColor: MaterialStateProperty.all(themeColor.getColor()),
                            padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
                        ),
                        onPressed: () async {
                          if (validateAndSave() == true) {
                            var data;
                            //회원가입 요청
                            try {
                              data = await signUpRequest(_id, _password, _username, _tel);
                            } catch(e) {
                              String errorMessage = '';

                              if (e.runtimeType == FormatException)  //중복된 아이디
                                errorMessage = '중복된 아이디입니다';
                              else
                                errorMessage = '회원가입에 실패하였습니다';

                              showToast(errorMessage);

                              // showDialog(
                              //     context: context,
                              //     barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                              //     builder: (BuildContext context) {
                              //       return AlertDialog(
                              //         content: Text(errorMessage),
                              //         insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                              //         actions: [
                              //           TextButton(
                              //             child: const Text('확인'),
                              //             onPressed: () {
                              //               Navigator.of(context).pop();
                              //             },
                              //           ),
                              //         ],
                              //       );
                              //     }
                              // );
                            }

                            var json_data = json.decode(data);

                            if (json_data['user_id'] == null) {
                              //회원가입 실패
                            }

                            Navigator.pop(context);
                          }
                        }
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}