import 'package:flutter/material.dart';

class UserSecondAllimPage extends StatefulWidget {
  const UserSecondAllimPage({Key? key}) : super(key: key);

  @override
  State<UserSecondAllimPage> createState() => _UserSecondAllimPageState();
}

class _UserSecondAllimPageState extends State<UserSecondAllimPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('개인알림장'),
      ),
      body: eachuser(),
    );
  }

  Widget eachuser() {
    return ListView(
      padding: EdgeInsets.all(15),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '구미요양원 요양보호사',
              style: TextStyle(fontSize: 13),
            ),
            Text(
              '2023.03.24',
              style: TextStyle(fontSize: 10),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(0,30,0,30),
                width: double.infinity,
                height: 250,
                child: Container(
                  child: Image.asset('assets/images/tree.jpg', fit: BoxFit.fill,),
                )
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0,0,0,40),
              child: Text(
                '오늘은 날씨가 좋아서 걷기 운동을 하였습니다.',
                style: TextStyle(fontSize: 15),
              ),
            ),
            informdata()
          ],
        )
      ],
    );
  }

  Widget informdata(){
    return Row(
      children: [
        inform('아침','점심','저녁','투약'),
        VerticalDivider(),
        inform('전량섭취','전량섭취','전량섭취','진통제'),
      ],
    );
  }

  Widget inform(String text1, String text2,String text3, String text4){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$text1'),
        Text('$text2'),
        Text('$text3'),
        Text('$text4'),
      ],
    );
  }

}




