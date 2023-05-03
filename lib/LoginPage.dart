import 'package:flutter/material.dart';
import 'MainPage.dart';
import 'SignupPage.dart';
import 'Supplementary/PageRouteWithAnimation.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  late String _id;
  late String _password;

  void validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid ID: $_id, password: $_password');
    } else {
      print('Form is invalid ID: $_id, password: $_password');
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

                      onPressed: (){
                        validateAndSave();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()),
                        );
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