import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'LoginPage.dart';
import 'Supplementary/PageRouteWithAnimation.dart';

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

  void validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid ID: $_id, password: $_password,Form is valid name: $_username, tel: $_tel');
    } else {
      print('Form is invalid ID: $_id, password: $_password,Form is invalid name: $_username, tel: $_tel');
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
                        // prefixIcon: Padding(
                        //   padding: EdgeInsets.only(top: 15),
                        //   child: Icon(Icons.person_rounded, color: Colors.grey),
                        // ),
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
                  SizedBox(height: 5,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      icon: Icon(Icons.people),
                      border: OutlineInputBorder(),
                      hintText: '이름',
                    ),
                    validator: (value) =>
                    value!.isEmpty ? '이름을 입력해주세요.' : null,
                    onSaved: (value) => _username = value!,
                  ),
                  SizedBox(height: 5,),
                  TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, //숫자만 가능
                    ],
                    keyboardType: TextInputType.number, //키보드는 숫자
                    decoration: InputDecoration(
                      icon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                      labelText: '전화번호',
                    ),
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
                        primary: themeColor.getColor(),
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      onPressed: (){
                        validateAndSave();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => LoginPage()),
                        // );
                        pageAnimation(context, LoginPage());
                      }
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