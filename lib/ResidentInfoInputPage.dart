import 'package:flutter/material.dart';
import 'MainPage.dart';
import 'Supplementary/PageRouteWithAnimation.dart';

//입소자 정보 입력 화면

class ResidentInfoInputPage extends StatefulWidget {
  @override
  _ResidentInfoInputPageState createState() => _ResidentInfoInputPageState();
}

class _ResidentInfoInputPageState extends State<ResidentInfoInputPage> {
  final formKey = new GlobalKey<FormState>();

  late String _residentname;
  late String _birthdate;

  bool _isHighBloodPress = false;
  bool _isDiabetes = false;
  bool _isHeartAttack = false;
  bool _isHeartDisease = false;
  bool _isEtc = false;
  //bool _isDisabled = true;
  List<String> checkList = [];

  void validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid ID: $_residentname, password: $_birthdate');
    } else {
      print('Form is invalid ID: $_residentname, password: $_birthdate');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(30),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: [
                      Icon(
                        Icons.room,
                        color: Colors.black,
                      ),
                      Text(
                        "구미요양원",
                        style: TextStyle(fontSize: 10.0),
                      )
                    ],
                  ),
                  SizedBox(height: 15.0,),
                  Text(
                    "입소자 정보를 입력해주세요",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(labelText: '이름'),
                          validator: (value) =>
                          value!.isEmpty ? '이름을 입력해주세요.' : null,
                          onSaved: (value) => _residentname = value!,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(labelText: '생년월일'),
                          validator: (value) =>
                          value!.isEmpty ? '생년월일을 입력해주세요.' : null,
                          onSaved: (value) => _birthdate = value!,
                        ),
                        SizedBox(height: 35.0,),
                        Text(
                          '건강 정보(중복선택 가능)',
                        ),
                        SizedBox(height: 12.0,),
                        Row(
                          children: [
                            Checkbox(
                              value: _isHighBloodPress,
                              onChanged: (value) {
                                setState(() {
                                  _isHighBloodPress = value!;
                                });
                              },
                            ),
                            Text("고혈압")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isDiabetes,
                              onChanged: (value) {
                                setState(() {
                                  _isDiabetes = value!;
                                });
                              },
                            ),
                            Text("당뇨")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isHeartAttack,
                              onChanged: (value) {
                                setState(() {
                                  _isHeartAttack = value!;
                                });
                              },
                            ),
                            Text("심근경색")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isHeartDisease,
                              onChanged: (value) {
                                setState(() {
                                  _isHeartDisease = value!;
                                });
                              },
                            ),
                            Text("심장병")
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: _isEtc,
                              onChanged: (value) {
                                setState(() {
                                  _isEtc = value!;
                                });
                              },
                            ),
                            Text("기타", textAlign: TextAlign.left),
                            SizedBox(width: 10,),
                            Container(
                              child: Flexible(
                                child: TextFormField(
                                  //enabled: !_isDisabled,
                                  decoration: InputDecoration(
                                    isDense: true
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  ElevatedButton (
                      child: Text(
                        '확인',
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => LoginPage()),
                        // );
                        pageAnimation(context, MainPage());
                      }
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}