import 'package:flutter/material.dart';
import '/Invite/InvitePage.dart';
import '/Supplementary/PageRouteWithAnimation.dart';

//초대목록화면

class InviteListPage extends StatefulWidget {
  const InviteListPage({Key? key}) : super(key: key);

  @override
  State<InviteListPage> createState() => _InviteListPageState();
}

class _InviteListPageState extends State<InviteListPage> {
  static List<String> invitelistDate = [
    '보호자 구현진',
    '관리자 권태연',
    '관리자 정혜지',
    '보호자 주효림',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: inviteButton(),
      appBar: AppBar(title: Text('초대 목록')),
      body: appInviteList(),
    );
  }
  //전체 구성
  Widget appInviteList(){
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            inviteList(),
            SizedBox(height: 80,)
          ],
        )
      ],
    );
  }

  //이름 나오는 부분
  Widget inviteList(){
    return Container(
      padding: EdgeInsets.only(left: 10, top: 10, right: 5),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: invitelistDate.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(Icons.person_rounded, color: Colors.grey),
            title: Row(
              children: [
                Text('${invitelistDate[index]}'), //초대 리스트
                Spacer(),
                Container(
                  padding: EdgeInsets.all(2),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: themeColor.getColor(),)
                      ),
                      onPressed: (){
                        //취소
                      },
                      child: Text('취소하기',style: TextStyle(color: themeColor.getColor(),),)
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  //초대하기 버튼
  Widget inviteButton(){
    return FloatingActionButton(
      focusColor: Colors.white54,
      backgroundColor: themeColor.getColor(),
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      onPressed: () { pageAnimation(context, InvitePage()); },
      child: Icon(Icons.add, color: Colors.white),
    );
  }
}