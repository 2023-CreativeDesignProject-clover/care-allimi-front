import 'package:flutter/material.dart';

class AddHomePage extends StatefulWidget {
  const AddHomePage({Key? key}) : super(key: key);

  @override
  State<AddHomePage> createState() => _AddHomePageState();
}


class _AddHomePageState extends State<AddHomePage> {
  List<String> placedata = ['서울특별시','부산광역시','대구광역시','인천광역시','광주광역시',
    '대전광역시','울산광역시','세종특별자치시','경기도','강원도','충청북도','충청남도','전라북도',
    '전라남도','경상북도','경상남도','제주특별자치도'];
  List<String> p1 =['종로구','중구','용산구','성동구','광진구','동대문구','주랑구','성북구',
    '강북구','도봉구','노원구','은평구','서대문구','마포구','양천구','강서구','구로구','금천구',
    '영등포구','동작구','관악구','서초구','강남구','송파구','강동구'];
  List<String> p2 =['부산'];
  List<String> p3 =['대구'];
  List<String> p4 =['인천'];
  List<String> p5 =['광주'];
  List<String> p6 =['대전'];
  List<String> p7 =['울산'];
  List<String> p8 =['세종'];
  List<String> p9 =['경기'];
  List<String> p10 =['강원'];
  List<String> p11 =['충북'];
  List<String> p12 =['충남'];
  List<String> p13 =['전북'];
  List<String> p14 =['전남'];
  List<String> p15 =['경북'];
  List<String> p16 =['경남'];
  List<String> p17 =['제주'];
  List<String> result =[];

  //서울특별시 종로구 클릭하였을 때
  List<String> nursingHomeDistance =['5km','8km','10km'];
  List<String> nursingHomeName =['설화요양원','시립서부노인전문요양','노아케어링하우스'];
  List<String> nursingHomeAddress =['서울특별시 마포구 만리재로 115 송희빌딩','서울특별시 마포구 월드컵로 36길 15','서울특별시 마포구 숭문6길 12'];
  //서울특별시 중구 클릭하였을 때
  List<String> nursingHomeDistance2 =['10km'];
  List<String> nursingHomeName2 =['요양원이름'];
  List<String> nursingHomeAddress2 =['여기는 주소입니다'];

  List<String> nursingHomeDistanceresult =[];
  List<String> nursingHomeNameresult =[];
  List<String> nursingHomeAddressresult =[];

  int check = 0;  //시/도가 선택되었는지 확인하는 변수

  String text1 = '시/도 선택';
  String text2 = '지역 선택';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f8f8),
      appBar: AppBar(
        title: const Text('요양원 검색'),
      ),
      body: findhome(),
    );
  }

  Widget findhome(){
    return ListView(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: (){
                        _showDialog(context);
                      },
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),  //버튼 테두리와 텍스트 사이에 공백
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,  //텍스트와 아이콘 배치
                          children: [
                            Text(
                              // '시/도 선택',
                              text1,
                              textScaleFactor: 1.1,
                              style: TextStyle(color:Colors.black, ),
                            ),
                            Icon(Icons.keyboard_arrow_down_sharp, size: 18,color: Colors.black,)
                          ],
                        ),
                      ),

                    ),
                  ),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: (){
                        if(check==0){
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext ctx){
                                return AlertDialog(
                                  content: Text('시/도를 먼저 선택해주세요!'),
                                  actions: [
                                    Center(
                                      child: TextButton(
                                          child: Text("확인"),
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          }
                                      ),
                                    )
                                  ],
                                );
                              }
                          );
                        }
                        else{
                          _showDialog2(context);
                        }
                      },
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              // '지역 선택',
                              text2,
                              textScaleFactor: 1.1,
                              style: TextStyle(color:Colors.black),
                            ),
                            Icon(Icons.keyboard_arrow_down_sharp, size: 18,color: Colors.black,)
                          ],
                        ),
                      ),

                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                    helperText: '요양원 이름, 주소로 검색 가능',
                    hintText: '입력해주세요.',  //글자를 입력하면 사라진다.
                    icon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(3)
                ),
              ),
            ),
            map(),
            Divider(),
            list()
          ],
        ),
      ],
    );
  }

  //시/도 선택에 관한 함수
  Widget setupAlertDiaload() {
    return Container(
      height: 500,
      width: 300,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: placedata.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              place1(index),
            ],
          );
        },
      ),
    );
  }
  Future _showDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('시/도 선택'),
            content: setupAlertDiaload(),
          );
        }
    );
  }
  Widget place1(int index){
    return ListTile(
        title: Text(placedata[index]),
        onTap: (){
          check=1;  //시/도 선택 여부 확인
          print(index);
          onWhereTap(index);
          Navigator.of(context, rootNavigator: true).pop();
          setState(() {
            text1 = placedata[index];
            text2 = '지역 선택';
          });
        });
  }

//result에 눌린 시/도에 해당되는 지역들 넣어주기
  void onWhereTap(int index) {
    switch(index) {
      case 0:
        result = p1;
        break;
      case 1:
        result = p2;
        break;
      case 2:
        result = p3;
        break;
      case 3:
        result = p4;
        break;
      case 4:
        result = p5;
        break;
      case 5:
        result = p6;
        break;
      case 6:
        result = p7;
        break;
      case 7:
        result = p8;
        break;
      case 8:
        result = p9;
        break;
      case 9:
        result = p10;
        break;
      case 10:
        result = p11;
        break;
      case 11:
        result = p12;
        break;
      case 12:
        result = p13;
        break;
      case 13:
        result = p14;
        break;
      case 14:
        result = p15;
        break;
      case 15:
        result = p16;
        break;
      case 16:
        result = p17;
        break;
      default:
        break;
    }
  }

  //지역 선택에 관한 함수
  Widget setupAlertDiaload2() {
    return Container(
      height: 500,
      width: 300,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: result.length,
        itemBuilder: (BuildContext context, int index2) {
          return Column(
              children: [
                place2(index2),
              ]
          );
        },
      ),
    );
  }
  Future _showDialog2(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('지역 선택'),
            content: setupAlertDiaload2(),
          );
        }
    );
  }
  Widget place2(int index2){
    return ListTile(
        title: Text(result[index2]),
        onTap: (){
          print(index2);
          Navigator.of(context, rootNavigator: true).pop();
          setState(() {
            text2 = result[index2];
          });
          onNursingTap(index2);
        });
  }


  //지도
  Widget map() {
    return Container(
      height: 500,
      width: double.infinity,
      color: Colors.green,
    );
  }

  //리스트
  Widget list() {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),  //스크롤바 없애기
        itemCount: nursingHomeDistanceresult.length,
        shrinkWrap: true,
        itemBuilder: (context, index3){
          return InkWell(
            onTap: (){
              print(index3);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Divider(),
                Row(
                  children: [
                    Icon(Icons.location_pin, size: 20,),
                    Text(
                      nursingHomeDistanceresult[index3],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Text(
                  nursingHomeNameresult[index3],
                  style: TextStyle(
                      fontSize: 23
                  ),
                ),
                Text(
                  nursingHomeAddressresult[index3],
                  style: TextStyle(
                      fontSize: 15
                  ),
                ),
                Divider(thickness: 0.5,),
              ],
            ),
          );
        }
    );
  }

//지역들 누르면 그 지역에 해당되는 요양원들 넣기
  void onNursingTap(int index3) {
    switch(index3) {
      case 0:
        nursingHomeDistanceresult = nursingHomeDistance;
        nursingHomeNameresult = nursingHomeName;
        nursingHomeAddressresult = nursingHomeAddress;
        break;
      case 1:
        nursingHomeDistanceresult = nursingHomeDistance2;
        nursingHomeNameresult = nursingHomeName2;
        nursingHomeAddressresult = nursingHomeAddress2;
        break;
      default:
        break;
    }
  }

}