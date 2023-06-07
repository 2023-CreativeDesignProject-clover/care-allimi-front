import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:test_data/Backend.dart';
import 'PhoneNumberFormatter.dart';

//시설 기본정보 설정 화면

class ResidentDetailPage extends StatefulWidget {
  const ResidentDetailPage({Key? key, required this.residentId}) : super(key: key);
  final int residentId;

  @override
  State<ResidentDetailPage> createState() => _ResidentDetailPageState();
}
class _ResidentDetailPageState extends State<ResidentDetailPage> {
  int _residentId = 0;
  Map<String, dynamic> _residentInfo = {};

  Future<void> getFacilityInfo() async {
    debugPrint("@@@@입소자 상세정보 받아오기 백엔드");

    http.Response response = await http.get(
        Uri.parse(Backend.getUrl() + 'nhResidents/' + _residentId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    Map<String, dynamic> parsedJson = Map<String, dynamic>.from(decodedJson);

    setState(() {
      _residentInfo =  parsedJson;
    });
  }

  @override
  void initState() {
    super.initState();
    _residentId = widget.residentId;
    getFacilityInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('입소자 상세 정보')),
      body: appSetting(),
    );
  }

  Widget appSetting(){
    if (_residentInfo.length == 0) {
      return Scaffold(backgroundColor: Colors.white, body: Center(child: SpinKitFadingCircle(color: Colors.grey, size: 30)));
    } else {
      return Container(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                text('입소자 이름'),
                myProfileBox(_residentInfo['resident_name']), //입소자 이름

                text('입소자 생년월일'),
                myProfileBox(_residentInfo['birth']), //입소자 생일
                
                text('보호자 이름'),
                myProfileBox(_residentInfo['protector_name']),

                text('보호자 연락처'),
                myProfileBox(PhoneNumberFormatter.format(_residentInfo['protector_phone_num'])),

            ],
          );
        }
      )
      );
    }
  }

  Widget text(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
      child: Text('$text',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget myProfileBox(String text) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 65),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 16),
        decoration: BoxDecoration(
          color: Color(0xfff2f3f6),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(11.5, 0, 11.5, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text, textScaleFactor: 1.1,),
            ],
          ),
        ),
      ),
    );
  }
}