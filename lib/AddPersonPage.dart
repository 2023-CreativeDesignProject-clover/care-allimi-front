import 'package:flutter/material.dart';

List<String> home =['금오요양원', '빛나요양원', '강아지요양원'];
List<String> person =['구현진 님', '주효림 님', '권태연 님'];

class AddPersonPage extends StatefulWidget {
  const AddPersonPage({Key? key}) : super(key: key);

  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  @override
  Widget build(BuildContext context) {
    return personList();
  }

  Widget personList() {
    return Scaffold(
      appBar: AppBar(title: Text('등록된 요양원 목록')),
      body: ListView.separated(
        itemCount: home.length, //면회 목록 출력 개수
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.home_rounded, size: 50),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(home[index]), //요양원
                  Text(person[index]), //사람 이름
                ],
              ),
              onTap: () {
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
  }
}