import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart';
import 'package:test_data/Backend.dart';

class AddPersonPage extends StatefulWidget {
  const AddPersonPage({Key? key, required this.uid}) : super(key: key);

  final int uid;

  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  late int _userId;
  List<Map<String, dynamic>> _residentList = [];

    @override
  void initState() {
    super.initState();
    _userId = widget.uid;
    getResident();
  }

  @override
  Widget build(BuildContext context) {
    return personList();
  }

  Future<void> getResident() async {
    debugPrint("@@@@@ 유저의 입소자들 리스트 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
      Uri.parse(Backend.getUrl()+ 'nhResidents/users/' + _userId.toString()),
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

  Future<void> changeResident(int residentId) async {
    debugPrint("@@@@@ 유저의 현재 입소자를 변경하는 백앤드 url 보냄");
    http.Response response = await http.patch(
      Uri.parse(Backend.getUrl()+ 'users/nhrs'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      },
      body: jsonEncode({
        "user_id" : _userId,
        "nhr_id": residentId
      })
    );

    if (response.statusCode != 200)
      throw Exception();
  }


  Widget personList() {
    if (_residentList.length != 0) {
      return Scaffold(
      appBar: AppBar(title: Text('등록된 요양원 목록')),
      backgroundColor: Color(0xfff8f8f8), //배경색
      body: ListView.separated(
        itemCount: _residentList.length, //면회 목록 출력 개수
        itemBuilder: (context, index) {
          String userRoleString = _residentList[index]['user_role'];
          if (userRoleString == 'PROTECTOR')
            userRoleString = '보호자';
          else if (userRoleString == 'WORKER')
            userRoleString = '직원';
          else if (userRoleString == 'MANAGER')
            userRoleString = '시설장';
          else
            userRoleString = '알 수 없음';

          return Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            color: Colors.white,
            child: ListTile(
              leading: Text('🏡', style: GoogleFonts.notoColorEmoji(fontSize: 50)),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_residentList[index]['facility_name']!= null?_residentList[index]['facility_name']:"null", textScaleFactor: 0.95,
                      style: TextStyle(fontWeight: FontWeight.bold)), //요양원
                  Row(
                    children: [
                      if (_residentList[index]['user_role'] == 'PROTECTOR')
                        Text(_residentList[index]['resident_name'] != null?_residentList[index]['resident_name']+" 님 ":"null", textScaleFactor: 0.95,),
                      Text("("+ userRoleString +")", textScaleFactor: 0.95,), //역할
                    ],
                  ), //사람 이름
                ],
              ),
              onTap: () {
                //현재 입소자 바꿈
                changeResident(_residentList[index]['resident_id']);

                Provider.of<ResidentProvider>(context, listen:false)
                          .setInfo(_residentList[index]['resident_id'], _residentList[index]['facility_id'], _residentList[index]['facility_name'], 
                                    _residentList[index]['resident_name'], _residentList[index]['user_role'], '', '');

                Provider.of<UserProvider>(context, listen: false)
                          .setRole(_residentList[index]['user_role']);

                Provider.of<UserProvider>(context, listen: false)
                          .getData();

                Navigator.pop(context);
              },
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 8);
        },
      ),
    );
  
    } else {
      return Scaffold(backgroundColor: Colors.white, body: Center(child: SpinKitFadingCircle(color: Colors.grey, size: 30)));
    }
  }
}
