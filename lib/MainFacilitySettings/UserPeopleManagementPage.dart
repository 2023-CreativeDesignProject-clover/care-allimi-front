import 'package:flutter/material.dart';

import '../Allim/WriteAllimPage.dart';

class userPeopleManagementPage extends StatefulWidget {
  const userPeopleManagementPage({Key? key}) : super(key: key);

  @override
  State<userPeopleManagementPage> createState() => _userPeopleManagementPageState();
}


class _userPeopleManagementPageState extends State<userPeopleManagementPage> with TickerProviderStateMixin {
  static List<String> userDate = [
    '구현진',
    '권태연',
    '정혜지',
    '주효림',
    '입소자'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text('입소자 관리')),
        body: ListView(
          children: [
            approve()
          ],
        )
    );
  }


  Widget approve(){
    return Container(
      padding: EdgeInsets.only(left: 20, top: 10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: userDate.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(Icons.person_rounded, color: Colors.grey),
            title: Row(
              children: [
                Text('${userDate[index]}'),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(2),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: themeColor.getColor(),)
                      ),
                      onPressed: (){
                        //입소자 삭제
                      },
                      child: Text('삭제',style: TextStyle(color: themeColor.getColor(),),)
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}