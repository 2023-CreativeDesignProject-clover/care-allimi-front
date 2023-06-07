import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_data/UI/Setup/ResidentDetailPage.dart';
import 'package:test_data/UI/Supplementary/PageRouteWithAnimation.dart';
import '/UI/Supplementary/ThemeColor.dart';
import 'package:test_data/Backend.dart';

ThemeColor themeColor = ThemeColor();

class ProtectorInmateProfilePage extends StatefulWidget {
  const ProtectorInmateProfilePage({Key? key, required this.uid}) : super(key: key);

  final int uid;

  @override
  State<ProtectorInmateProfilePage> createState() => _ProtectorInmateProfilePageState();
}

class _ProtectorInmateProfilePageState extends State<ProtectorInmateProfilePage> {
  late int _userId;
  List<Map<String, dynamic>> _residentList = [];

  @override
  void initState() {
    super.initState();
    _userId = widget.uid;
    getResident();
  }

  Future<void> getResident() async {
    debugPrint("@@@@@ 유저의 입소자들 리스트 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
        Uri.parse(Backend.getUrl() + 'nhResidents/users/' + _userId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    if (response.statusCode != 200) {
      throw Exception('POST request failed');
    }

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);

    Map<String, dynamic> parsedJson = Map<String, dynamic>.from(decodedJson);

    List<Map<String, dynamic>> parsedJsonList
    = List<Map<String, dynamic>>.from(parsedJson['resident_list']);

    setState(() {
      _residentList = parsedJsonList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return myInmateProfile();
  }

  //입소자 정보
  Widget myInmateProfile() {
    return Scaffold(
      appBar: AppBar(title: Text('입소자 정보')),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10, left: 10),
            child: Row(
              children: [
                Icon(Icons.info_rounded, size: 18, color: themeColor.getColor()),
                Expanded(
                  child: Text(
                    ' 현재 내가 보호하고 있는 입소자 목록입니다',
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
                if (_residentList[index]['user_role'] == 'PROTECTOR') {
                  return ListTile(
                    leading: Icon(Icons.person_rounded, color: Colors.grey),
                    title: Row(
                      children: [
                        Text('${_residentList[index]['resident_name']} 님', textScaleFactor: 0.95,), //수급자 이름 리스트
                      ],
                    ),
                    onTap: () async{
                      await awaitPageAnimation(context, ResidentDetailPage(residentId: _residentList[index]['resident_id']));
                      print('입소자 이름 ${_residentList[index]['resident_name']} Tap');

                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }


}
