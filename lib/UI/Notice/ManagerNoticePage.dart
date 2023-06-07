import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/UI/Notice/NoticeDetailPage.dart';
import '../Supplementary/PageRouteWithAnimation.dart';
import '/provider/NoticeTempProvider.dart';
import '/UI/Supplementary/ThemeColor.dart';
import 'WriteNoticePage.dart';
import 'package:http/http.dart' as http; //http 사용
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test_data/Backend.dart';

ThemeColor themeColor = ThemeColor();

class ManagerNoticePage extends StatefulWidget {
  const ManagerNoticePage({
    Key? key,
    required this.userRole,
    required this.facilityId,
    required this.residentId,
  }) : super(key: key);

  final String userRole;
  final int facilityId;
  final int residentId;

  @override
  State<ManagerNoticePage> createState() => _ManagerNoticePageState();
}

class _ManagerNoticePageState extends State<ManagerNoticePage> {
  late int _facilityId;
  late int _residentId;
  String _userRole = '';
  List<Map<String, dynamic>> _noticeList = [];

    @override
  void initState() {
    _userRole = widget.userRole;
    _facilityId = widget.facilityId;
    _residentId = widget.residentId;
    getNotice(_facilityId);
  }

  //삭제
  Future<void> deleteNotice(int allnoticeId) async {
    http.Response response = await http.delete(
        Uri.parse(Backend.getUrl()+ 'all-notices'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        },
        body: jsonEncode({
          "allnotice_id": allnoticeId
        })
    );

    debugPrint("@@@statusCode= " + response.statusCode.toString());

    if (response.statusCode != 200)
      throw Exception();
  }

  //공지사항 받아옴
 Future<void> getNotice(int facility_id) async {
    debugPrint("@@@@@ 공지사항 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
        Uri.parse(Backend.getUrl() + "all-notices/facilities/" + facility_id.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8'
        }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    parsedJson.sort((a, b) { //날짜 최신순으로 정렬
      DateTime aDate = DateTime.parse(a['create_date']);
      DateTime bDate = DateTime.parse(b['create_date']);
      return bDate.compareTo(aDate);
    });

    setState(() {
      _noticeList =  parsedJson;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('공지사항')),
      backgroundColor: Color(0xfff8f8f8), //배경색
      body: RefreshIndicator(
        color: themeColor.getColor(),
        onRefresh: _onRefresh,
        child: ListView(
          children: [
            noticeList(),
          ],
        ),
      ),
      floatingActionButton: _getFAB(),
    );
  }

  // 새로 고침 기능 구현
  Future<void> _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 500));
    await getNotice(_facilityId);
  }

  //플로팅액션 버튼
  Widget _getFAB() {
    if (_userRole == 'PROTECTOR') {
      return Container();
    } else {
      return writeButton(
          context: context,
          onPressed: () async {
            await awaitPageAnimation(context, WriteNoticePage(residentId: _residentId));
            getNotice(_facilityId);
          });
    }
  }

  //공지사항 목록
  Widget noticeList() {
    final fontSize = 0.95;
    return ListView.separated(
      itemCount: _noticeList.length, //공지 목록 출력 개수
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {


        if(_noticeList != null && _noticeList.length != 0) {
          List<String> imgList = List<String>.from(_noticeList[index]['imageUrl']);

          bool isImportant = _noticeList[index]['important']; // 각 게시물의 중요 여부 가져오기

          return Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            color: Colors.white,
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isImportant ? getRedTag() : getGreyTag(), // 중요 여부에 따른 태그 표시
                        SizedBox(height: 5),

                        Text(_noticeList[index]['title'], maxLines: 1, overflow: TextOverflow.ellipsis, textScaleFactor: fontSize), //공지 제목
                        Text(_noticeList[index]['create_date'].toString().substring(0, 10).replaceAll('-', '.'), textScaleFactor: fontSize), //공지사항 날짜
                      ],
                    ),
                  ),

                  //이미지
                  Container(
                    width: 100,
                    height: 100,
                    color: imgList.length != 0 ? null : Colors.white,
                    child: imgList.length != 0
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        imageUrl: imgList[0],
                        fit: BoxFit.fill,
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            SpinKitFadingCircle(
                              color: Colors.grey,
                              size: 30,
                            ),
                        errorWidget: (context, url, error) => Icon(Icons.error_rounded, color: Colors.grey),
                      ),
                    )
                        : null,
                  )

                ],
              ),
              onTap: () {
                print('공지 목록: ${_noticeList[index]['title']} Tap');
                pageAnimation(context, noticeManagerPage(index)); //공지사항 내용으로 이동
              },
            ),
          );
        }


        else
          return Container();

      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
    );
  }


  //태그 선택
  Widget getTag(BuildContext context) {
    if (Provider.of<NoticeTempProvider>(context).isImportant) {
      return getRedTag(); // 중요
    } else {
      return getGreyTag(); // 공지사항
    }
  }

  Widget getRedTag() {
    return Container(
      padding: EdgeInsets.fromLTRB(7, 3, 7, 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Color(0xffffe9e9),
      ),
      child: Text('중요', textScaleFactor: 0.8, style: TextStyle(color: Color(0xffed3939))),
    );
  }

  Widget getGreyTag() {
    return Container(
      padding: EdgeInsets.fromLTRB(7, 3, 7, 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Color(0xfff2f3f5),
      ),
      child: Text('공지사항', textScaleFactor: 0.8, style: TextStyle(color: Color(0xff6d767f))),
    );
  }


  Widget noticeManagerPage(int index) {
    return NoticeDetailPage(
        index: index,
        userRole: _userRole,
        noticeList: _noticeList,
        getNotice: getNotice,
        facilityId: _facilityId,
        deleteNotice: deleteNotice);
  }

}


