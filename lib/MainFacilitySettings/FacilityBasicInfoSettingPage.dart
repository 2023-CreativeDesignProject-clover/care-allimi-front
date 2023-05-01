import 'package:flutter/material.dart';
import '/Supplementary/PageRouteWithAnimation.dart';

//시설 기본정보 설정 화면

class FacilityBasicInfoPage extends StatefulWidget {
  const FacilityBasicInfoPage({Key? key}) : super(key: key);

  @override
  State<FacilityBasicInfoPage> createState() => _FacilityBasicInfoPageState();
}
class _FacilityBasicInfoPageState extends State<FacilityBasicInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('시설 기본 정보 설정')),
      body: appSetting(),
    );
  }

  Widget appSetting(){
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    child: Text('시설 정보'),
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Color(0xfff2f3f6),
                      border: Border.all(color: Color(0xfff2f3f6),width: 3)
                    ),
                  ),
                  Container(  //시설 이름
                    child: Text('삼족오 요양원', textScaleFactor: 1.2,),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xfff2f3f6),width: 2)
                      ),
                  ),
                  Container(  //전화번호
                    child: Text('010-1234-5678', textScaleFactor: 1.2,),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xfff2f3f6),width: 2)
                    ),
                  ),

                ],
              )
            ),
            Container(
                padding: EdgeInsets.all(18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: Text('시설 주소'),
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Color(0xfff2f3f6),
                          border: Border.all(color: Color(0xfff2f3f6),width: 3)
                      ),
                    ),
                    Container(
                      child: Text('경상북도 구미시 거의동 456-1', textScaleFactor: 1.2,),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xfff2f3f6),width: 2)
                      ),
                    ),
                  ],
                )
            ),
          ],
        )
      ],
    );
  }
}