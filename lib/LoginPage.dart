import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart';
import 'MainPage.dart';
import 'SignupPage.dart';
import 'Supplementary/PageRouteWithAnimation.dart';
import 'package:http/http.dart' as http; //http 사용

String backendUrl = "http://13.125.155.244:8080/v2/";

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

  //"user_id": 1,
  // "userRole": "PROTECTOR"

  return utf8.decode(response.bodyBytes); //반환받은 데이터(user_id, userRole) 반환

  // //더미 데이터
  // String response = jsonEncode({
  //   'user_id': 1,
  //   'userRole': 'PROTECTER',
  //   'id': 'asdf1234',
  //   'tel':'0100000000',
  //   'user_name': '권태연'
  // });

  // return response;
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  late String _id;
  late String _password;

   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ResidentProvider>(context, listen: true).getData();
      Provider.of<UserProvider>(context, listen: true).getData();
    });
  }

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
                      //로그인
                      var data = await loginRequest(_id, _password);
                      var json_data = json.decode(data);
 
                      if (json_data['user_id'] == null)//회원가입 필요, user가 없다!
                        return;

                      debugPrint(json_data.toString());

                      //유저정보 받아오기
                      var userData = await getUserInfo(json_data['user_id']);
                      var jsonUserData = json.decode(userData);

                      debugPrint(jsonUserData.toString());

                      var userRole = '';
                      if (json_data['userRole'] != null) {
                        userRole = json_data['userRole'];
                        var residentData = await getResidentInfo(json_data['user_id']);
                        var jsonResidentData = json.decode(residentData);

                        debugPrint(jsonResidentData.toString());

                        Provider.of<ResidentProvider>(context, listen:false)
                          .setInfo(jsonResidentData['nhr_id'], jsonResidentData['facility_id'], jsonResidentData['facility_name'], jsonResidentData['resident_name'],
                                    json_data['userRole'],'', '');

                      }
                        
                      var residentData = await getResidentInfo(json_data['user_id']);
                      var jsonResidentData = json.decode(residentData);

                      Provider.of<UserProvider>(context, listen:false)
                          .setInfo(json_data['user_id'], userRole, jsonUserData['login_id'], jsonUserData['phone_num'], jsonUserData['user_name']);
                      
                    }
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => MainPage()),
                    // );
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
      ),
    );
  }
}