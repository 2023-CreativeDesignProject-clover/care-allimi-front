import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';
import 'package:provider/provider.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart';
import '../Main/MainPage.dart';
import '/UI/Supplementary/CustomClick.dart';
import 'package:http/http.dart' as http; //http 사용
import 'package:google_fonts/google_fonts.dart';
import 'package:test_data/Backend.dart';

//입소자 정보 입력 화면

class ResidentInfoInputPage extends StatefulWidget {

  const ResidentInfoInputPage({
    Key? key,
    required this.invitationId,
    required this.invitationUserRole,
    required this.invitationFacilityId,
    required this.invitationFacilityName,
    required this.userId
  }) : super(key: key);

  final int invitationId;
  final String invitationUserRole;
  final int invitationFacilityId;
  final String invitationFacilityName;
  final int userId;

  @override
  _ResidentInfoInputPageState createState() => _ResidentInfoInputPageState();
}

class _ResidentInfoInputPageState extends State<ResidentInfoInputPage> {
  final formKey = new GlobalKey<FormState>();

  String _residentname = '';
  String _birthdate = '';
  late int invitationId;
  late String invitationUserRole;
  late int invitationFacilityId;
  late String invitationFacilityName;
  late int _userId;

  bool _isHighBloodPress = false;
  bool _isDiabetes = false;
  bool _isHeartAttack = false;
  bool _isHeartDisease = false;

  CheckClick checkClick = new CheckClick();
  String healthInfo = '';
  List<String> checkList = [];

  void initState() {
    invitationId = widget.invitationId;
    invitationUserRole = widget.invitationUserRole;
    invitationFacilityId = widget.invitationFacilityId;
    invitationFacilityName = widget.invitationFacilityName;
    _userId = widget.userId;
    if (invitationUserRole != 'PROTECTOR') {
      addWorker(_userId);
    }
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

    debugPrint("@@@@@ 입소자 추가하는 백앤드 url 보냄");

    //입소자추가 post
    http.Response response1 = await http.post(
      
      Uri.parse(Backend.getUrl()+ 'nhResidents'),
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
      debugPrint("@@@@@ 초대 수락하는 백앤드 url 보냄");

    http.Response response2 = await http.post(
      Uri.parse(Backend.getUrl()+ 'invitations/approve'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      },
      body: jsonEncode({
        "invite_id": invitationId
      })//66000000
    );

    // 응답 코드가 200 OK가 아닐 경우 예외 처리
    if (response1.statusCode != 200) {
      throw Exception('POST request failed');
    }

    return utf8.decode(response1.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    if(invitationUserRole == 'PROTECTOR') {
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
                      Text('🤗', style: GoogleFonts.notoColorEmoji(fontSize: 55)),
                      SizedBox(height: 10),
                      Text('입소자 정보를', textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('입력해주세요', textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 50),
                      getTextFeild(
                        keyboardType: TextInputType.text,
                        title: '이름',
                        prefixIcon: Icon(Icons.person_rounded, color: Colors.grey),
                        validator: (value) => value!.isEmpty ? '이름을 입력하세요' : null,
                        onSaved: (value) => _residentname = value!,
                      ),
                      SizedBox(height: 7),
                      getTextFeild(
                        keyboardType: TextInputType.number,
                        title: '생년월일 8자리',
                        prefixIcon: Icon(Icons.cake_rounded, color: Colors.grey),
                        inputFormatters: [MultiMaskedTextInputFormatter(masks: ['xxxx.xx.xx'], separator: '.')],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '생년월일을 입력하세요';
                          } else if (value.length != 10) {
                            return '생년월일 8자리를 입력하세요';
                          }
                          return null;
                        },
                        onSaved: (value) => _birthdate = value!,
                      ),
                      SizedBox(height: 100),
                      TextButton(
                        child: Container(
                          width: double.infinity,
                          child: Text('확인', textScaleFactor: 1.2, textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)),
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
                            if (validateAndSave()) {
                              var data;
                              try {
                                data = await addResident(_userId);
                                var json_data = json.decode(data);

                                if (json_data['resident_id'] != null) {
                                  Provider.of<ResidentProvider>(context, listen:false)
                                      .setInfo(json_data['resident_id'], invitationFacilityId, invitationFacilityName, _residentname,
                                      invitationUserRole,_birthdate, healthInfo);

                                  Provider.of<UserProvider>(context, listen:false)
                                      .setRole(invitationUserRole);

                                  Navigator.pop(context);
                                }

                                Provider.of<UserProvider>(context,listen:false).getData();

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
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        )
      );
    }
    else {
      return Scaffold(backgroundColor: Colors.white, body: Center(child: SpinKitFadingCircle(color: Colors.grey, size: 30)));
    }
  }
  Future<void> addWorker(int uid) async {
    debugPrint("@@요양보호사 추가 백엔드 요청 보냄");

    var data;
    try {
      data = await addResident(uid);
      var json_data = json.decode(data);

      if (json_data['resident_id'] != null) {
        Provider.of<ResidentProvider>(context, listen:false)
            .setInfo(json_data['resident_id'], invitationFacilityId, invitationFacilityName, _residentname,
            invitationUserRole,_birthdate, healthInfo);

        Provider.of<UserProvider>(context, listen:false)
            .setRole(invitationUserRole);

        Navigator.pop(context);
      }

      Provider.of<UserProvider>(context,listen:false).getData();

    } catch(e) {}
  }

  Widget getTextFeild({
    required String title,
    required Widget prefixIcon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
}) {
    return TextFormField(
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
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
        hintText: title,
        hintStyle: TextStyle(fontSize: 16),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}

