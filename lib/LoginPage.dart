import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart';
import 'MainPage.dart';
import 'SignupPage.dart';
import 'Supplementary/PageRouteWithAnimation.dart';
import 'package:http/http.dart' as http;

String backendUrl = "http://13.125.155.244:8080/v2/";

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
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(40),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.person_rounded),
                      hintText: '아이디',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                    value!.isEmpty ? '아이디를 입력해주세요.' : null,
                    onSaved: (value) => _id = value!,
                  ),
                  SizedBox(height: 5,),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      hintText: '비밀번호',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                    value!.isEmpty ? '비밀번호를 입력해주세요.' : null,
                    onSaved: (value) => _password = value!,
                  ),
                  SizedBox(height: 20.0,),
                  ElevatedButton (
                      child: Text(
                        '로그인',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),

                      onPressed: () async {
                        if (validateAndSave() == true) {
                          var data;

                          try {
                            data = await loginRequest(_id, _password);
                          } catch(e) {
                            showDialog(
                                context: context,
                                barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text("아이디 또는 패스워드가 일치하지 않습니다"),
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
                            return;
                          }

                          var json_data = json.decode(data);

                          debugPrint(json_data.toString());


                          //유저정보 받아오기
                          var userData = await getUserInfo(json_data['user_id']);
                          var jsonUserData = json.decode(userData);

                          var userRole = '';
                          if (json_data['userRole'] != null) {
                            userRole = json_data['userRole'];
                            var residentData = await getResidentInfo(json_data['user_id']);
                            var jsonResidentData = json.decode(residentData);

                            Provider.of<ResidentProvider>(context, listen:false)
                                .setInfo(jsonResidentData['nhr_id'], jsonResidentData['facility_id'], jsonResidentData['facility_name'], jsonResidentData['resident_name'],
                                json_data['userRole'],'', '');

                          }

                          var residentData = await getResidentInfo(json_data['user_id']);
                          var jsonResidentData = json.decode(residentData);

                          Provider.of<UserProvider>(context, listen:false)
                              .setInfo(json_data['user_id'], userRole, jsonUserData['login_id'], jsonUserData['phone_num'], jsonUserData['user_name']);

                          Provider.of<UserProvider>(context, listen: false)
                              .getData();

                        }


                      }
                  ),
                  SizedBox(height: 10.0,),
                  OutlinedButton (
                    child: Text(
                      '회원가입',
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    onPressed: (){
                      pageAnimation(context, SignupPage());
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

//-----------------------백엔드에 요청보내는 코드-----------------------//
//유저 정보 받아오는 url
Future<String> getUserInfo(int userId) async {
  http.Response response = await http.get(
      Uri.parse(backendUrl + "users/" + userId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      }
  );

  // "user_name": "string", "phone_num": "string", "login_id": "string"
  return utf8.decode(response.bodyBytes);
}

//입소자 정보 받아오는 url
Future<String> getResidentInfo(int userId) async {
  http.Response response = await http.get(
      Uri.parse(backendUrl+ 'users/nhrs/' + userId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      }
  );

  return utf8.decode(response.bodyBytes);
}

//로그인 요청 받는 request
Future<String> loginRequest(String id, String password) async {
  http.Response response = await http.post(
    Uri.parse(backendUrl+"login"),
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