import 'package:flutter/material.dart';

class ManagerSecondAllimPage extends StatefulWidget {
  const ManagerSecondAllimPage({Key? key}) : super(key: key);

  @override
  State<ManagerSecondAllimPage> createState() => _ManagerSecondAllimPageState();
}

class _ManagerSecondAllimPageState extends State<ManagerSecondAllimPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('알림장 내용'),
      ),
      body: eachmanager(),

    );
  }
  //시설장 및 직원 알림장(각 목록)
  Widget eachmanager() {
    return ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '삼족오 보호자님',
                            style: TextStyle(fontSize: 13),
                          ),
                          Text(
                            '2023.03.24',
                            style: TextStyle(fontSize: 10),
                          ),
                        ],

                      ),
                      Spacer(),
                      Container(
                        child: OutlinedButton(
                            onPressed: (){
                              //수정 화면으로 넘어가기
                            },
                            child: Text('수정')
                        ),

                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        //alignment: Alignment.centerRight,
                        child: OutlinedButton(
                            onPressed: (){
                              //삭제
                            },
                            child: Text('삭제')
                        ),
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
                    '오늘은 날씨가 좋아서 걷기 운동을 하였습니다.오늘은 날씨가 좋아서 걷기 운동을 하였습니다.오늘은 날씨가 좋아서 걷기 운동을 하였습니다. 오늘은 날씨가 좋아서 걷기 운동을 하였습니다.오늘은 날씨가 좋아서 걷기 운동을 하였습니다. 오늘은 날씨가 좋아서 걷기 운동을 하였습니다.',
                    style: TextStyle(fontSize: 15),
                  ),
                ),

                //알림장 안에 있는 어르신의 일일정보
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




