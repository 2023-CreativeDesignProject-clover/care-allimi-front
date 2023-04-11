import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Supplementary/ThemeColor.dart';
import 'Supplementary/PageRouteWithAnimation.dart';
import 'Allim/UserAllimPage.dart';
import 'Allim/ManagerAllimPage.dart';
import 'AddHomePage.dart';

ThemeColor themeColor = ThemeColor();

List<String> textEmoji = ['📢', '✏', '🍀', '📷', '🍚', '🗓', '💌'];
List<String> textMenu = ['공지사항', '알림장', '면회신청', '앨범', '식단표', '일정표', '한마디'];

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
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
          //Padding(padding: EdgeInsets.fromLTRB(15,10,15,5), child: Text('바로가기', style: TextStyle(fontWeight: FontWeight.bold))),
          menuList(context),

        ],
      ),
    );
  }


  //소속추가 버튼
  Widget addGroup() {
    return GestureDetector(
      onTap: () {
        pageAnimation(context, AddHomePage());
        print('소속추가 Tap');
        }, //TODO: 소속추가 클릭 시 이벤트
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            border: Border.all(color: themeColor.getColor(), width: 0.5)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, size: 16,color: themeColor.getColor()),
            Text('소속추가 ', textScaleFactor: 0.9, style: TextStyle(color: themeColor.getColor()))
          ],
        ),
      ),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('금오요양원', textScaleFactor: 1.4, style: TextStyle(fontWeight: FontWeight.bold)), //TODO: 요양원 이름
              Text('삼족오 보호자님'), //TODO: 내 역할
            ],
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
    return Container(
      padding: EdgeInsets.fromLTRB(11,0,11,0),
      child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: textMenu.length, //총 몇 개 출력할 건지
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

  // TODO: 메뉴 Tap 시 실행
  void onButtonTap(int index) {
    switch(index) {
      case 0:
        print('공지사항 Tap');
        break;
      case 1:
        print('알림장 Tap');
        pageAnimation(context, ManagerAllimPage());
        break;
      case 2:
        print('면회신청 Tap');
        break;
      case 3:
        print('앨범 Tap');
        break;
      case 4:
        print('식단표 Tap');
        break;
      case 5:
        print('일정표 Tap');
        break;
      case 6:
        print('한마디 Tap');
        break;
      default:
        break;
    }
  }


}