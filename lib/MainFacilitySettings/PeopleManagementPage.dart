import 'package:flutter/material.dart';

import '../Allim/WriteAllimPage.dart';

class PeopleManagementPage extends StatefulWidget {
  const PeopleManagementPage({Key? key}) : super(key: key);

  @override
  State<PeopleManagementPage> createState() => _PeopleManagementPageState();
}

class _PeopleManagementPageState extends State<PeopleManagementPage> with TickerProviderStateMixin {
  static List<String> employeeDate = [
    '구현진',
    '권태연',
    '정혜지',
    '주효림',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('직원 관리')),
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
        itemCount: employeeDate.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(Icons.person_rounded, color: Colors.grey),
            title: Row(
              children: [
                Text('${employeeDate[index]}'),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(2),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: themeColor.getColor(),)
                      ),
                      onPressed: (){
                        //직원 삭제
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