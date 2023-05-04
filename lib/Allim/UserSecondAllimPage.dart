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
      //backgroundColor: Colors.white,
      appBar: AppBar(title: Text('알림장 내용')),
      body: eachuser(),
    );
  }

  Widget eachuser() {
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(7, 9, 7, 9),
              width: double.infinity,
              color: Colors.white,
              child: Column(
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
                ],
              ),
            ),

            //알림장 사진
            Container(
                margin: EdgeInsets.fromLTRB(0,10,0,0),
                width: double.infinity,
                color: Colors.white,
                height: 300,
                child: Container(
                  child: Image.asset('assets/images/tree.jpg', fit: BoxFit.fill,),
                )
            ),

            //알림장 세부 내용
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(7,7,7,7),
              margin: EdgeInsets.only(bottom: 10),
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

  //알림장 안에 있는 어르신의 일일정보 함수
  Widget informdata(){
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(7,7,7,7),
      child: Column(
        children: [
          inform('아침','전량섭취'),
          Divider(thickness: 0.5,),
          inform('점심','전량섭취'),
          Divider(thickness: 0.5,),
          inform('저녁','전량섭취'),
          Divider(thickness: 0.5,),
          inform('투약','아침에만'),
        ],
      ),
    );
  }

  Widget inform(String text1, String text2){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(right: 30),
          child: Text(
            '$text1',
            style: TextStyle(fontSize: 15,color: Colors.black38),
          ),
        ),
        Text('$text2',style: TextStyle(fontSize: 15,color: Colors.black),),
      ],
    );
  }

}



