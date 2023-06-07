import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/UI/Notice/ModificationNoticePage.dart';
import 'package:test_data/UI/Supplementary/CustomWidget.dart';
import '../Supplementary/PageRouteWithAnimation.dart';
import '/provider/ResidentProvider.dart';
import '/UI/Supplementary/ThemeColor.dart';
import '../Supplementary/CustomClick.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

ThemeColor themeColor = ThemeColor();

class NoticeDetailPage extends StatefulWidget {
  NoticeDetailPage({
    required this.index,
    required this.userRole,
    required this.noticeList,
    required this.getNotice,
    required this.deleteNotice,
    required this.facilityId});

  final int index;
  final String userRole;
  final List<Map<String, dynamic>> noticeList;
  final Function getNotice;
  final Function deleteNotice;
  final int facilityId;

  @override
  State<NoticeDetailPage> createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {
  @override
  Widget build(BuildContext context) {
    int residentId = Provider.of<ResidentProvider>(context, listen: false).resident_id;
    CheckClick checkClick = new CheckClick();
    List<String> imgList = List<String>.from(widget.noticeList[widget.index]['imageUrl']);
    final fontSize = 1.10;

    return Scaffold(
      appBar: AppBar(
          title: Text('공지사항 내용')),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.noticeList[widget.index]['title'],
                            textScaleFactor: fontSize,
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis, // 오버플로우 처리
                          ), //공지 제목
                          Text(widget.noticeList[widget.index]['create_date'].toString().substring(0, 10).replaceAll('-', '.'),
                            textScaleFactor: fontSize), //공지 게시한 날짜
                        ],
                      ),
                    ),


                    if (widget.userRole != 'PROTECTOR' && widget.noticeList[widget.index]['writer_id'] == residentId)
                      Container(
                        child: Row(
                          children: [
                            SizedBox(width: 3),
                            Consumer<ResidentProvider>(
                              builder: (context, residentProvider, child) {
                                return OutlinedButton(
                                  child: Text('수정', style: TextStyle(color: Colors.grey)),
                                  style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3))),
                                  onPressed: () async {
                                    if (checkClick.isRedundentClick(DateTime.now())) { //연타 막기
                                      return ;
                                    }

                                    debugPrint('@@@@@@@1 : ' + widget.noticeList[widget.index]['writer_id'].toString());
                                    debugPrint('@@@@@@@2 : ' + residentProvider.resident_id.toString());

                                    int facility_id = Provider.of<ResidentProvider>(context, listen: false).facility_id;

                                    await awaitPageAnimation(context, ModificationNoticePage(
                                        residentId: residentProvider.resident_id,
                                        noticeId: widget.noticeList[widget.index]['allNoticeId'],
                                        facility_id: facility_id,
                                        noticeList: widget.noticeList[widget.index],
                                        imageUrls: imgList));

                                    setState(() {
                                      widget.getNotice(facility_id); // 추가된 부분
                                    });
                                    Navigator.of(context).pop(); //목록으로 감
                                    showToast('수정 완료');

                                  },
                                );
                              }
                            ),
                          ],
                        ),
                      ),

                    if (widget.userRole != 'PROTECTOR' && widget.noticeList[widget.index]['writer_id'] == residentId)
                      Container(
                        child: Row(
                          children: [
                            SizedBox(width: 3),
                            OutlinedButton(
                              child: Text('삭제', style: TextStyle(color: Colors.grey)),
                              style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3))),
                              onPressed: () async {
                                if (checkClick.isRedundentClick(DateTime.now())) { //연타 막기
                                  return ;
                                }
                                showDialog(
                                    context: context,
                                    barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text('삭제하시겠습니까?'),
                                        insetPadding: const  EdgeInsets.fromLTRB(0,80, 0, 80),
                                        actions: [

                                          TextButton(
                                            child: Text('취소', style: TextStyle(color: themeColor.getColor())),
                                            style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),

                                          TextButton(
                                            child: Text('삭제', style: TextStyle(color: themeColor.getColor())),
                                            style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                            onPressed: () async {
                                              try {
                                                if (checkClick.isRedundentClick(DateTime.now())) { //연타 막기
                                                  return ;
                                                }
                                                await widget.deleteNotice(widget.noticeList[widget.index]['allNoticeId']);
                                                showToast('삭제 완료');
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                                widget.getNotice(widget.facilityId);
                                              } catch(e) {
                                                debugPrint("@@@삭제 오류 $e");

                                                showToast('공지사항 삭제 실패! 다시 시도해주세요');
                                                Navigator.of(context).pop();
                                              }
                                            },
                                          ),

                                        ],
                                      );
                                    }
                                );
                              },

                            ),
                          ],
                        )
                      ),


                  ],
                ),
              ),

              Padding(padding: EdgeInsets.all(8), child: Divider(thickness: 0.5)),

              Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    for (int i = 0; i < imgList.length; i++) ...[
                      CachedNetworkImage(
                        imageUrl: imgList[i],
                        fit: BoxFit.fill,
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            SpinKitFadingCircle(
                              color: Colors.grey,
                              size: 30,
                            ),
                        errorWidget: (context, url, error) => Icon(Icons.error_rounded, color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                    ],
                  ],
                ),
              ),


              SizedBox(height: 10),
              //공지사항 세부 내용
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.all(10),

                child: Text(widget.noticeList[widget.index]['content'], textScaleFactor: fontSize,),
              ),

              SizedBox(height: 50),
            ],
          )
        ],
      ),
    );
  }
}
