import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_data/exception/LoginIdAlreadyExistsException.dart';
import '../MainSetup/ResidentManagementPage.dart';
import 'package:http/http.dart' as http; //http 사용
import 'package:google_fonts/google_fonts.dart';
import 'package:test_data/Backend.dart';
import 'package:test_data/UI/Supplementary/CustomWidget.dart';
import '../Supplementary/PhoneTextInputFormatter.dart';
import '../Supplementary/ThemeColor.dart';

ThemeColor themeColor = ThemeColor();
Future<String> signUpRequest(String id, String password, String name, String phoneNum) async {
    debugPrint("@@@@@ 회원가입 백앤드 url 보냄");

  http.Response response = await http.post(
    Uri.parse(Backend.getUrl()+"users"),
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

  //응답 코드가 200 OK가 아닐 경우 예외 처리
  if (response.statusCode == 500) {
    throw Exception('로그인 에러 발생');
  }
  else if (response.statusCode == 400) {
    throw FormatException();
  }
  else if (response.statusCode == 409) {
    throw LoginIdAlreadyExistsException("이미 존재하는 id입니다");
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
                    Text('서비스 이용을 위해', textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('회원가입을 진행해주세요', textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 50),
                    getTextFormField(
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
                      ],
                      title: '아이디',
                      prefixIcon: Icon(Icons.person_rounded, color: Colors.grey),
                      validator: (value) => value!.isEmpty ? '아이디를 입력하세요' : null,
                      onSaved: (value) => _id = value!,
                    ),
                    SizedBox(height: 7),
                    getTextFormField(
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp('[ㄱ-ㅎㅏ-ㅣ가-힣]')), //한글 빼고 전부 입력 가능
                      ],
                      title: '비밀번호',
                      prefixIcon: Icon(Icons.lock_rounded, color: Colors.grey),
                      validator: (value) => value!.isEmpty ? '비밀번호를 입력하세요' : null,
                      onSaved: (value) => _password = value!,
                    ),
                    SizedBox(height: 7),
                    getTextFormField(
                      keyboardType: TextInputType.text,
                      title: '이름',
                      prefixIcon: Icon(Icons.people_rounded, color: Colors.grey),
                      validator: (value) => value!.isEmpty ? '이름을 입력하세요' : null,
                      onSaved: (value) => _username = value!,
                    ),
                    SizedBox(height: 7,),
                    getTextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        PhoneTextInputFormatter()
                      ],
                      title: '전화번호',
                      prefixIcon: Icon(Icons.phone_rounded, color: Colors.grey),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '전화번호를 입력하세요';
                        } else if (value.length < 12) {
                          return '전화번호를 정확히 입력하세요';
                        }
                        return null;
                      },
                      onSaved: (value) => _tel = value!.replaceAll("-", ""),
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
                          if (checkClick.isRedundentClick(DateTime.now())) {
                            return;
                          }
                          if (validateAndSave() == true) {
                            var data;
                            //회원가입 요청
                            try {
                              data = await signUpRequest(_id, _password, _username, _tel);
                            } catch(e) {
                              String errorMessage = '';

                              if (e.runtimeType == LoginIdAlreadyExistsException)  //중복된 아이디
                                errorMessage = '중복된 아이디입니다';
                              else if (e.runtimeType == FormatException)
                                errorMessage = '잘못된 요청입니다';
                              else
                                errorMessage = '회원가입에 실패하였습니다';

                              showToast(errorMessage);
                              return;
                            }
                            showToast('회원가입 완료');
                            Navigator.of(context).pop();
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

  Widget getTextFormField({
    required String title,
    required Widget prefixIcon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    bool? obscureText
}) {
    return TextFormField(
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText ?? false,
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