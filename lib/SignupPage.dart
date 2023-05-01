import 'dart:convert';

import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'Supplementary/PageRouteWithAnimation.dart';
import 'package:http/http.dart' as http; //http 사용

String backendUrl = "http://3.36.73.115:8080/v2/";

Future<String> signUpRequest(String id, String password, String name, String phoneNum) async {
  http.Response response = await http.post(
    Uri.parse(backendUrl+"users"),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "login_id": id,
      "password": password,
      "name": name,
      "phone_num": phoneNum
    }),
  );


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
      body: Container(
        padding: EdgeInsets.all(50),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: '아이디'),
                validator: (value) =>
                value!.isEmpty ? '아이디를 입력해주세요.' : null,
                onSaved: (value) => _id = value!,
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: '비밀번호'),
                validator: (value) =>
                value!.isEmpty ? '비밀번호를 입력해주세요.' : null,
                onSaved: (value) => _password = value!,
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: '이름'),
                validator: (value) =>
                value!.isEmpty ? '이름을 입력해주세요.' : null,
                onSaved: (value) => _username = value!,
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: '전화번호'),
                validator: (value) =>
                value!.isEmpty ? '전화번호를 입력해주세요.' : null,
                onSaved: (value) => _tel = value!,
              ),
              SizedBox(height: 30.0,),
              ElevatedButton (
                  child: Text(
                    '가입하기',
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
                      //회원가입 요청
                      try {
                        data = await signUpRequest(_id, _password, _username, _tel);
                      } catch(e) {
                        String errorMessage = '';

                        if (e.runtimeType == FormatException)  //중복된 아이디
                          errorMessage = '중복된 아이디입니다';
                        else 
                          errorMessage = '회원가입에 실패하였습니다';
                        
                        
                        showDialog(
                            context: context,
                            barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text(errorMessage),
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
                      
                      var json_data = json.decode(data);

                      if (json_data['user_id'] == null) {
                        //회원가입 실패
                      }

                      Navigator.pop(context);
                    }

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => LoginPage()),
                    // );
                    
                    //pageAnimation(context, LoginPage());
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}