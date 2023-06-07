import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Supplementary/PageRouteWithAnimation.dart';
import '../Supplementary/CustomClick.dart';
import 'package:test_data/Backend.dart';
import '/UI/Supplementary/ThemeColor.dart';
import 'ResidentDetailPage.dart';

ThemeColor themeColor = ThemeColor();

class WorkerInmateProfilePage extends StatefulWidget {
  const WorkerInmateProfilePage({Key? key, required this.facilityId, required this.uid, required this.residentId}) : super(key: key);

  final int facilityId;
  final int uid;
  final int residentId;

  @override
  State<WorkerInmateProfilePage> createState() => _WorkerInmateProfilePageState();
}

class _WorkerInmateProfilePageState extends State<WorkerInmateProfilePage> {
  late int _userId;
  late int _facilityId;
  late int _residentId;
  List<Map<String, dynamic>> _residentList = [];
  CheckClick checkClick = new CheckClick();

  @override
  void initState() {
    super.initState();
    _userId = widget.uid;
    _facilityId = widget.facilityId;
    _residentId = widget.residentId;
    addInmate();
  }

  Future<void> addInmate() async {
    debugPrint("@@내가 담당하는 입소자 정보 받아오는 백엔드 요청 ");
    var url = Uri.parse(Backend.getUrl() + 'nhResidents/manage/' + _residentId.toString());
    var headers = {'Content-type': 'application/json'};
    final response = await http.get(url, headers: headers);

    debugPrint("@@statusCode: " + response.statusCode.toString());

    if (response.statusCode == 200) {
      print("성공");
    } else {
      throw Exception();
    }

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);

    List<Map<String, dynamic>> parsedJsonList 
      = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      _residentList = parsedJsonList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('입소자 정보')),
      body: myInmateProfile(),
    );
  }

  //입소자 정보
  Widget myInmateProfile() {
    if (_residentList.length != 0) {
      return ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10, left: 10),
            child: Row(
              children: [
                Icon(Icons.info_rounded, size: 18, color: themeColor.getColor()),
                Expanded(
                  child: Text(
                    ' 현재 내가 담당하고 있는 입소자 목록입니다',
                    style: TextStyle(color: themeColor.getColor()),
                    overflow: TextOverflow.visible,
                    maxLines: null,
                    textScaleFactor: 1,
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _residentList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.person_rounded, color: Colors.grey),
                  title: Row(
                    children: [
                      Text('${_residentList[index]['resident_name']} 님', textScaleFactor: 0.95,), //수급자 이름 리스트
                    ],
                  ),
                  onTap: () async {
                    if (checkClick.isRedundentClick(DateTime.now())) { //연타 막기
                      return ;
                    }
                    await awaitPageAnimation(context, ResidentDetailPage(residentId: _residentList[index]['resident_id']));
                    print('입소자 이름 ${_residentList[index]['resident_name']} Tap');
                  },
                );
              },
            ),
          ),
        ],
      );
    } else {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
              children: [
                Icon(Icons.error_outline_rounded, color: Colors.grey, size: 100),
                Text('현재 담당 중인 입소자가 없습니다', textScaleFactor: 1.4, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 50,),
                Text('입소자 담당 방법'),
                Text('메인 화면 - 시설 설정 - 입소자 관리 - [추가]'),
              ]
          ),
        )
      ),
    );
  }
}
}
