import 'dart:convert';
import 'package:kpostal/kpostal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:test_data/UI/Supplementary/CustomWidget.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_data/Backend.dart';
import '../Supplementary/CustomClick.dart';
import '../Supplementary/PageRouteWithAnimation.dart';
import '../Supplementary/PhoneTextInputFormatter.dart';
import '../Supplementary/ThemeColor.dart';

ThemeColor themeColor = ThemeColor();

class AddFacilities extends StatefulWidget {
  const AddFacilities({Key? key, required this.uid}) : super(key: key);
  final int uid;

  @override
  State<AddFacilities> createState() => _AddFacilitiesState();
}

class _AddFacilitiesState extends State<AddFacilities> {
  final formKey = GlobalKey<FormState>();
  TextEditingController facilityNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController personNameController = TextEditingController();
  CheckClick checkClick = new CheckClick();
  String postCode = '우편번호';
  String _facilityName = '';
  String _location = '';
  String _number = '';
  String _personName = '';
  int _facilityId = 0;
  late int _uid;
  int _resident_id = 0;

  @override
  void initState() {
    super.initState();
    _uid = widget.uid;
  }

  Future<void> facilityRequest(int uid) async {
    debugPrint("@@@@ 시설 추가하는 백엔드 url보냄: " + _personName);
    //입소자추가 post
    http.Response response1 = await http.post(
      Uri.parse(Backend.getUrl() + 'facilities'),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept-Charset': 'utf-8'
      },
      body: jsonEncode({
        "name": _facilityName,
        "address": _location,
        "tel": _number,
        "fm_name": _personName
      })
    );

    debugPrint("@@@@ statusCode: " + response1.statusCode.toString());

    if (response1.statusCode != 200) {
        throw Exception('POST request failed');
    }

    var data =  utf8.decode(response1.bodyBytes);
    dynamic decodedJson = json.decode(data);
    Map<String, dynamic> parsedJson = Map<String, dynamic>.from(decodedJson);
    _facilityId = parsedJson['facility_id'];

    debugPrint("@@@@ 시설장 resident 추가하는 백엔드 url보냄");

    http.Response response2 = await http.post(
      Uri.parse(Backend.getUrl()+ 'nhResidents'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      },
      body: jsonEncode({
        "user_id": uid,
        "facility_id": _facilityId,
        "resident_name": '',
        "birth": '',
        "user_role": 'MANAGER',
        "health_info": ''
      })
    );

    if (response2.statusCode != 200) {
        throw Exception('POST');
    }

    data =  utf8.decode(response2.bodyBytes);
    decodedJson = json.decode(data);
    parsedJson = Map<String, dynamic>.from(decodedJson);
    _resident_id = parsedJson['resident_id'];
  }

  @override
  Widget build(BuildContext context) {
    return addFacilities();
  }

  Widget addFacilities() {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🏡', style: GoogleFonts.notoColorEmoji(fontSize: 55)),
                  SizedBox(height: 10),
                  Text('시설 정보를', textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('입력해주세요', textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 50),
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          getTextFormField(
                              keyboardType: TextInputType.text,
                              icon: Icon(Icons.home_rounded, color: Colors.grey),
                              hintText: '시설명',
                              controller: facilityNameController,
                              validator: (value) => value!.isEmpty ? '시설명을 입력하세요' : null,
                          ),
                          SizedBox(height: 7),
                          //주소 검색
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              addressText(text: postCode),
                              GestureDetector(
                                child: addressText(text: '주소 검색', style: TextStyle(fontWeight: FontWeight.bold)),
                                onTap: () async {
                                  await awaitPageAnimation(context, KpostalView(
                                    appBar: AppBar(title: Text('주소 검색')),
                                    callback: (Kpostal result) {
                                      setState(() {
                                        locationController.text = result.address;
                                        postCode = result.postCode;
                                      });
                                    },
                                  ),);
                                }
                              ),
                            ],
                          ),
                          SizedBox(height: 7),
                          getTextFormField(
                              keyboardType: TextInputType.text,
                              icon: Icon(Icons.place_rounded, color: Colors.grey),
                              hintText: '주소',
                              controller: locationController,
                            validator: (value) => value!.isEmpty ? '주소를 입력하세요' : null,),
                          SizedBox(height: 7),
                          getTextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              PhoneTextInputFormatter()
                            ],
                            icon: Icon(Icons.call_rounded, color: Colors.grey),
                            hintText: '전화번호',
                            controller: numberController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '전화번호를 입력하세요';
                              } else if (value.length < 12) {
                                return '전화번호를 정확히 입력하세요';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 7),
                          getTextFormField(
                              keyboardType: TextInputType.text,
                              icon: Icon(Icons.person_rounded, color: Colors.grey),
                              hintText: '시설장 이름',
                              controller: personNameController,
                            validator: (value) => value!.isEmpty ? '시설장 이름을 입력하세요' : null,),
                        ],
                      )
                  ),
                  SizedBox(height: 50),
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
                    onPressed: () {
                      if(this.formKey.currentState!.validate()) {
                        this.formKey.currentState!.save();

                        showDialog(
                            context: context,
                            barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                            builder: (BuildContext context1) {
                              return AlertDialog(
                                content: Text('시설 등록을 진행하시겠습니까?'),
                                insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                                actions: [
                                  TextButton(
                                    child: Text('취소', style: TextStyle(color: themeColor.getColor())),
                                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('확인', style: TextStyle(color: themeColor.getColor())),
                                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                    onPressed: () async {
                                      if (checkClick.isRedundentClick(DateTime.now())) { //연타 막기
                                        return ;
                                      }
                                      try {
                                        await facilityRequest(_uid);
                                        showToast('시설 등록에 성공하였습니다');
                                        Provider.of<ResidentProvider>(context, listen:false)
                                            .setInfo(_resident_id, _facilityId, _facilityName, '', 'MANAGER','', '');

                                        Provider.of<UserProvider>(context, listen: false)
                                            .setRole('MANAGER');

                                        Provider.of<UserProvider>(context, listen: false)
                                            .getData();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      } catch(e) {
                                        showToast('시설 등록에 실패하였습니다');
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  )
                                ],
                              );
                            }
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }

  Widget getTextFormField({
    TextInputType? keyboardType,
    required Widget icon,
    required String? hintText,
    required TextEditingController controller,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 16),
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
        validator: validator,
        onSaved: (value) {
          if (hintText == '시설명') {
            _facilityName = value!;
          } else if (hintText == '주소') {
            _location = value!;
          } else if (hintText == '전화번호') {
            _number = value!;
          } else if (hintText == '시설장 이름') {
            _personName = value!;
          }
        }
    );
  }

  Widget addressText({required String? text, TextStyle? style}) {
    return Container(
      child: Text(text!, style: style),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}