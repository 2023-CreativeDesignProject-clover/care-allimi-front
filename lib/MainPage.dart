import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_data/Allim/AllimPage.dart';
import 'package:test_data/CameraTest.dart';
import 'package:test_data/Notice/UserNoticePage.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart';
import 'MainFacilitySettings/MainFacilitySetting.dart';
import 'Notice/ManagerNoticePage.dart';
import 'Supplementary/ThemeColor.dart';
import 'Supplementary/PageRouteWithAnimation.dart';
import 'Allim/UserAllimPage.dart';
import 'Allim/ManagerAllimPage.dart';
import 'VisitRequest/UserRequestPage.dart';
import 'VisitRequest/ManagerRequestPage.dart';
import 'AddPersonPage.dart';
import 'Comment/UserCommentPage.dart';
import 'package:http/http.dart' as http; //http 사용

ThemeColor themeColor = ThemeColor();

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> textEmoji = ['📢', '✏', '🗓', '🍀', '💌', '🔧'];
  List<String> textMenu = ['공지사항', '알림장', '일정표', '면회 관리', '한마디', '시설 설정'];

  @override
  Widget build(BuildContext context) {
    // return pickImages();
    return Scaffold(
      backgroundColor: Color(0xfff8f8f8), //배경색
      appBar: AppBar(
        title: Text('요양원 알리미', textScaleFactor: 1.0, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [

          //TODO: 위젯 작성
          myCard(),
          menuList(context),

        ],
      ),
    );
  }

  //소속추가 버튼
  Widget addGroup() {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            border: Border.all(color: themeColor.getColor(), width: 0.5)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_rounded, color: themeColor.getColor()),
            //Text('소속추가 ', textScaleFactor: 0.9, style: TextStyle(color: themeColor.getColor()))
          ],
        ),
      ),
      onTap: () {
        print('소속추가 Tap');
        //TODO: 요양원 이름, 입소자 이름 나오는 페이지
        pageAnimation(context, AddPersonPage());
      },
    );
  }

  //현재 선택된 요양원 + 내 역할
  Widget myInfo() {
    return Container(
      width: double.infinity,
      height: 120,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('🏡', style: GoogleFonts.notoColorEmoji(fontSize: 50)),
          SizedBox(width: 10),
          Consumer2<UserProvider, ResidentProvider>(
            builder: (context, userProvider, residentProvider, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(residentProvider.facility_name, textScaleFactor: 1.4, style: TextStyle(fontWeight: FontWeight.bold)), //TODO: 요양원 이름
                  Text(userProvider.name + ' 보호자님(' + residentProvider.resident_name + '님'), //TODO: 내 역할
                ],
              );
            }
          ),
        ],
      ),
    );
     
  }

  //현재 선택된 요양원 출력
  Widget myCard() {
    return Stack(
      children: [
        myInfo(),
        Positioned(
            top: 23,
            right: 23,
            child: addGroup(),
        ),
      ],
    );
  }

  //메뉴 리스트 출력
  Widget menuList(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Container(
          padding: EdgeInsets.fromLTRB(11,0,11,0),
          child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: (userProvider.urole == 'PROTECTER')?textMenu.length-1: textMenu.length, //총 몇 개 출력할 건지: 보호자면 하나 뺌
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, //한 행에 몇 개 출력할 건지
                childAspectRatio: 2/2.2, //가로세로 비율
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () { onButtonTap(index); },
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(textEmoji[index], style: GoogleFonts.notoColorEmoji(fontSize: 30)),
                        SizedBox(height: 5),
                        Text(textMenu[index], textScaleFactor: 1.05,),
                      ],
                    ),
                  ),
                );
              }
          ),
        );
      }
    );
  }

  // TODO: 메뉴 Tap 시 실행
  void onButtonTap(int index) {
    switch(index) {
      case 0:
        print('공지사항 Tap');
        pageAnimation(context, ManagerNoticePage()); //일단은 요양보호사 버전으로
        break;
      case 1:
        print('알림장 Tap');
        pageAnimation(context, AllimPage()); //요양보호사 버전, user버전 알아서 찾아감
        break;
      case 2:
        print('일정표 Tap');
        break;
      case 3:
        print('면회신청 Tap');
        pageAnimation(context, ManagerRequestPage()); //일단은 요양보호사 버전으로
        break;
      case 4:
        print('한마디 Tap');
        pageAnimation(context, UserCommentPage()); //일단은 보호자 버전으로
        break;
      case 5:
        print('시설설정 Tap');
        pageAnimation(context, MainFacilitySettingsPage());
        break;
      default:
        break;
    }
  }

}