import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/provider/UserProvider.dart';
import '../AddFacilities.dart';
import '/Supplementary/ThemeColor.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import '/Setup/SetupHealthPage.dart';

ThemeColor themeColor = ThemeColor();

List<String> personList = ['구현진', '권태연', '정혜지', '주효림'];


class SetupPage extends StatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('설정')),
      body: ListView(
        children: [

          //TODO: 위젯 작성
          appProfile(),
          appInmateProfile(),
          appLogout(),
          appTest(),
        ],
      ),
    );
  }

  Widget appTest() {
    return ListTile(
        title: Text('시설 추가하기 - 화면 테스트'),
        leading: Icon(Icons.supervisor_account_rounded, color: Colors.grey),
        onTap: () { pageAnimation(context, AddFacilities()); });
  }


  Widget appProfile() {
    return ListTile(
        title: Text('내 정보'),
        leading: Icon(Icons.person_rounded, color: Colors.grey),
        onTap: () { pageAnimation(context, myProfile()); });
  }

  Widget appInmateProfile() {
    return ListTile(
        title: Text('입소자 정보'),
        leading: Icon(Icons.supervisor_account_rounded, color: Colors.grey),
        onTap: () { pageAnimation(context, myInmateProfile()); });
  }

  Widget appLogout() {
    return ListTile(
        title: Text('로그아웃'),
        leading: Icon(Icons.logout_rounded, color: Colors.grey),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  content: const Text('로그아웃하시겠습니까?'),
                  actions: [
                    TextButton(child: Text('아니오',
                      style: TextStyle(color: themeColor.getMaterialColor())),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    Consumer<UserProvider>(
                      builder: (context, userProvider, child) {
                        return TextButton(child: Text('예',
                          style: TextStyle(color: themeColor.getMaterialColor())),
                            onPressed: () {
                              userProvider.logout();
                              userProvider.getData();
                          Navigator.pop(context);
                          //TODO: 로그아웃 실행
                          
                        });
                      }
                    ),
                  ],
                ),
          );
        });
  }

  //내 정보
  Widget myProfile() {
    return Scaffold(
        appBar: AppBar(title: Text('내 정보')),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Text('아이디'),
            myProfileBox('kumohtest'),
            Text('역할'),
            myProfileBox('보호자'),
            Text('이름'),
            myProfileBox('구현진'),
            Text('전화번호'),
            myProfileBox('010-1234-5678'),
          ],
        )
    );
  }

  Widget myProfileBox(String text) {
    return Container(
        width: double.infinity,
        height: 50,
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
          color: Color(0xfff2f3f6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(11.5, 0, 11.5, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('$text', textScaleFactor: 1.2),
            ],
          )
        )
    );
  }

  //입소자 정보
  Widget myInmateProfile() {
    return Scaffold(
        appBar: AppBar(title: Text('입소자 정보')),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(Icons.info_rounded, color: Colors.grey),
                  SizedBox(width: 5),
                  Text('현재 내가 보호하고 있는 피보호자 목록입니다.'),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: personList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Icon(Icons.person_rounded, color: Colors.grey),
                    title: Row(
                      children: [
                        Text('${personList[index]} 님'), //TODO: 수급자 이름 리스트
                      ],
                    ),
                    onTap: () {
                      print('입소자 이름 ${personList[index]} Tap');

                      // TODO: 수급자 선택 시 처리할 이벤트
                      pageAnimation(context, inmateProfilePage(index));

                    },
                  );
                },
              ),
            ),
          ],
        ),
    );
  }

  // Widget ss(int index) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text('${personList[index]} 님의 정보')),
  //     body: ListView(
  //       children: [
  //
  //         Text('${personList[index]} 님의 페이지입니다.'),
  //
  //         Text('건강 상태'),
  //         SetupHealthPage(),
  //
  //       ],
  //     ),
  //   );
  // }

  Widget inmateProfilePage(int index) {
    List<String> healthList = ['고혈압', '당뇨', '고지혈증', '심근경색'];
    List<bool> isCheckedList = [false, false, false, false];

    return customPage(
        title: '${personList[index]} 님의 정보',
        onPressed: () {
          print('완료 버튼 누름');

          //TODO: 완료 버튼 누르면 실행되어야 할 부분

          Navigator.pop(context);

          },
        body: ListView(
          children: [

            //Text('${personList[index]} 님의 페이지입니다.'),
            Text('건강 상태'),
            
            //TODO: 페이지 나갔다 들어가면 체크박스 전부 초기화됨 나중에 수정하기
            SetupHealthPage(healthList: healthList, isCheckedList: isCheckedList)
          ],
        ),
        buttonName: '완료'
    );
  }


}




