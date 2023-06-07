import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_data/UI/Calendar/ManagerCalendarPage.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart';
import '../MainSetup/MainFacilitySetup.dart';
import '../Notice/ManagerNoticePage.dart';
import '../Supplementary/ThemeColor.dart';
import '../Supplementary/PageRouteWithAnimation.dart';
import '../Allim/ManagerAllimPage.dart';
import '../VisitRequest/ManagerRequestPage.dart';
import 'AddPersonPage.dart';
import '../Comment/UserCommentPage.dart';

ThemeColor themeColor = ThemeColor();

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.userRole}) : super(key: key);
  final String userRole;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> textEmoji = ['📢', '✏', '🗓', '🍀', '💌', '🔧'];
  List<String> textMenu = ['공지사항', '알림장', '일정표', '면회 관리', '한마디', '시설 설정'];
  late String _userRole;
  late int _resident_id = 0;
  late int _facility_id = 0;
  late int _userId = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _userRole = widget.userRole;
    return Scaffold(
      backgroundColor: Color(0xfff8f8f8), //배경색
      appBar: AppBar(
        title: Text('요양원 알리미'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          //본문
          myCard(),
          menuList(context),
        ],
      )
    );
  }

  //등록된 요양원 버튼
  Widget addGroup() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.all(4),
            color: Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.menu_rounded, color: themeColor.getColor()),
              ],
            ),
          ),
          onTap: () {
            print('등록된 요양원 목록 Tap');
            //등록된 요양원 목록 나오는 페이지
            pageAnimation(context, AddPersonPage(uid: userProvider.uid));
          },
        );
      }
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
          Expanded(
            child: Consumer2<UserProvider, ResidentProvider>(
                builder: (context, userProvider, residentProvider, child) {
                  _resident_id = residentProvider.resident_id;
                  _facility_id = residentProvider.facility_id;
                  _userId = userProvider.uid;

                  String userRoleString = '';
                  if (userProvider.urole == 'PROTECTOR')
                    userRoleString = '보호자님 ' + '(' + residentProvider.resident_name + ' 님)';
                  else if (userProvider.urole == 'WORKER')
                    userRoleString = '직원';
                  else if (userProvider.urole == 'MANAGER')
                    userRoleString = '시설장님';

                  return Container(

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible (
                          child: Text(residentProvider.facility_name, textScaleFactor: 1.2, style: TextStyle(fontWeight: FontWeight.bold),
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),), //요양원 이름
                        Flexible(
                          child: Text(userProvider.name + ' ' + userRoleString, textScaleFactor: 1, softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ), //내 역할
                      ],
                    ),
                  );
                }
            ),
          ),
          SizedBox(width: 35)
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
        itemCount: (_userRole != 'PROTECTOR')? textMenu.length : textMenu.length -1, //총 몇 개 출력할 건지
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
                  SizedBox(height: 10),
                  Text(textMenu[index], textScaleFactor: 1),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  void onButtonTap(int index) {
    switch(index) {
      case 0:
        print('공지사항 Tap');
        pageAnimation(context, new ManagerNoticePage(userRole: _userRole,  residentId: _resident_id, facilityId: _facility_id));
        break;
      case 1:
        print('알림장 Tap');
        pageAnimation(context, new ManagerAllimPage(userRole: _userRole, residentId: _resident_id));
        break;
      case 2:
        print('일정표 Tap');
        pageAnimation(context, new ManagerCalendarPage(userRole: _userRole, residentId: _resident_id, facility_id: _facility_id));
        break;
      case 3:
        print('면회신청 Tap');
        pageAnimation(context, new ManagerRequestPage(userRole: _userRole, residentId: _resident_id));
        break;
      case 4:
        print('한마디 Tap');
        pageAnimation(context, new UserCommentPage(userRole: _userRole, residentId: _resident_id));
        break;
      case 5:
        print('시설설정 Tap');
        pageAnimation(context, new MainFacilitySettingsPage(facilityId: _facility_id));
        break;
      default:
        break;
    }
  }
}