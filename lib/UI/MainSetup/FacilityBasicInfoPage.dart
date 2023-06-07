import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:test_data/Backend.dart';

class FacilityBasicInfoPage extends StatefulWidget {
  const FacilityBasicInfoPage({Key? key, required this.facilityId}) : super(key: key);
  final int facilityId;

  @override
  State<FacilityBasicInfoPage> createState() => _FacilityBasicInfoPageState();
}
class _FacilityBasicInfoPageState extends State<FacilityBasicInfoPage> {
  int _facilityId = 0;
  Map<String, dynamic> _facilityInfo = {};

  Future<void> getFacilityInfo() async {
    debugPrint("@@@@시설 정보 받아오기 백엔드");

    http.Response response = await http.get(
        Uri.parse(Backend.getUrl() + "facilities/" + _facilityId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    Map<String, dynamic> parsedJson = Map<String, dynamic>.from(decodedJson);

    setState(() {
      _facilityInfo =  parsedJson;
    });
  }

  @override
  void initState() {
    super.initState();
    _facilityId = widget.facilityId;
    getFacilityInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('시설 기본 정보')),
      body: appSetting(),
    );
  }

  Widget appSetting(){
    if (_facilityInfo.length == 0) {
      return Scaffold(backgroundColor: Colors.white, body: Center(child: SpinKitFadingCircle(color: Colors.grey, size: 30)));
    } else {
      return ListView(
        children: [

          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color(0xfff2f3f6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text('시설 정보'),
                myDetailBox(_facilityInfo['name']), //시설 이름
                myDetailBox(_facilityInfo['address']), //시설 주소
                myDetailBox(_facilityInfo['tel']),  //전화번호
              ],
            ),
          ),

          SizedBox(height: 10),

          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color(0xfff2f3f6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text('시설장 이름'),
                myDetailBox(_facilityInfo['fm_name']), //시설장 이름
              ],
            ),
          )
        ],
      );
    }
  }

  Widget text(String text) {
    return Container(
      child: Text(text,style: TextStyle(fontWeight: FontWeight.bold)),
      padding: EdgeInsets.all(8),
    );
  }

  Widget myDetailBox(String text) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 57),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(11.5, 0, 11.5, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}