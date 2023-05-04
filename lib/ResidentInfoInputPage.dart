import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart';
import 'MainPage.dart';
import 'Supplementary/PageRouteWithAnimation.dart';
import 'package:http/http.dart' as http; //http 사용

String backendUrl = "http://13.125.155.244:8080/v2/";

//입소자 정보 입력 화면

class ResidentInfoInputPage extends StatefulWidget {

  const ResidentInfoInputPage({
    Key? key,
    required this.invitationId,
    required this.invitationUserRole,
    required this.invitationFacilityId,
    required this.invitationFacilityName
  }) : super(key: key);

  final int invitationId;
  final String invitationUserRole;
  final int invitationFacilityId;
  final String invitationFacilityName;

  @override
  _ResidentInfoInputPageState createState() => _ResidentInfoInputPageState();
}

class _ResidentInfoInputPageState extends State<ResidentInfoInputPage> {
  final formKey = new GlobalKey<FormState>();

  late String _residentname;
  late String _birthdate;
  late int invitationId;
  late String invitationUserRole;
  late int invitationFacilityId;
  late String invitationFacilityName;

  bool _isHighBloodPress = false;
  bool _isDiabetes = false;
  bool _isHeartAttack = false;
  bool _isHeartDisease = false;
  bool _isEtc = false;

  String healthInfo = '';
  List<String> checkList = [];

  void initState() {
    invitationId = widget.invitationId;
    invitationUserRole = widget.invitationUserRole;
    invitationFacilityId = widget.invitationFacilityId;
    invitationFacilityName = widget.invitationFacilityName;
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid ID: $_residentname, password: $_birthdate');
      return true;
    } else {
      print('Form is invalid ID: $_residentname, password: $_birthdate');
      return false;
    }
  }

  Future<String> addResident(int uid) async {
    if (_isHighBloodPress)
      healthInfo += "고혈압\n";

    if (_isDiabetes)
      healthInfo += "당뇨\n";

    if (_isHeartAttack)
      healthInfo += "심근경색\n";

    if (_isHeartDisease)
      healthInfo += "심장병";

    //TODO 기타저장 안됨


    //입소자추가 psot
    http.Response response1 = await http.post(
        Uri.parse(backendUrl+ 'nhResidents'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        },
        body: jsonEncode({
          "user_id": uid,
          "facility_id": invitationFacilityId,
          "resident_name": _residentname,
          "birth": _birthdate,
          "user_role": invitationUserRole,
          "health_info": healthInfo
        })
    );

    if (response1.statusCode != 200) {
      throw Exception('POST request failed');
    }

    http.Response response2 = await http.post(
        Uri.parse(backendUrl+ 'invitations/approve'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        },
        body: jsonEncode(invitationId)
    );

    // 응답 코드가 200 OK가 아닐 경우 예외 처리
    if (response1.statusCode != 200) {
      throw Exception('POST request failed');
    }

    return utf8.decode(response1.bodyBytes);
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
                    Consumer<UserProvider>(
                        builder: (context, userProvider, child) {
                          return ElevatedButton (
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
                              onPressed: () async {
                                if (validateAndSave()) {
                                  var data;
                                  try {
                                    data = await addResident(userProvider.uid);
                                    var json_data = json.decode(data);

                                    if (json_data['resident_id'] != null) {
                                      Provider.of<ResidentProvider>(context, listen:false)
                                          .setInfo(json_data['resident_id'], invitationFacilityId, invitationFacilityName, _residentname,
                                          invitationUserRole,_birthdate, healthInfo);

                                      Provider.of<UserProvider>(context, listen:false)
                                          .setRole(invitationUserRole);

                                      Navigator.pop(context);
                                    }

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



                                }
                              }
                          );
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