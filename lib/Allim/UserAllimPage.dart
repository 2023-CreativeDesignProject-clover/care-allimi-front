import 'package:flutter/material.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'UserSecondAllimPage.dart';
import '/AllimModel.dart';

class UserAllimPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return UserAllimPageState();
  }
}
class UserAllimPageState extends State<UserAllimPage>{

  static List<String> noticeDate = [
    '2023.03.20',
    '2023.03.21',
    '2023.03.22',
  ];
  static List<String> noticeDetail = [
    '오늘은 미세먼지가 많아서 걷기 운동을 안 하려고 하였으나 많은 분들이 걷기를 원하셔서 간단하게 걸어보았습니다.오늘은 미세먼지가 많아서 걷기 운동을 안 하려고 하였으나 많은 분들이 걷기를 원하셔서 간단하게 걸어보았습니다.오늘은 미세먼지가 많아서 걷기 운동을 안 하려고 하였으나 많은 분들이 걷기를 원하셔서 간단하게 걸어보았습니다.',
    '오늘은 요양원 행사를 하였습니다. 무슨 행사인지 아시나요? 바로 초콜릿 만들기랍니다.',
    '오늘도 요양원 행사를 하였습니다. 어제 만든 초콜릿이 너무 맛있어서 이 초콜릿으로 케이크를 만들었답니다.',
  ];
  static List<String> noticeimgPath = [
    'assets/images/tree.jpg',
    'assets/images/tree.jpg',
    'assets/images/cake.jpg',
  ];

  final List<Allim> noticeData = List.generate(noticeDetail.length, (index) =>
      Allim(noticeDate[index], noticeDetail[index], noticeimgPath[index]));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f8f8),
      appBar: AppBar(
        title: const Text('알림장'),
      ),
      body: userlist(),
    );
  }



  Widget userlist() {
    return ListView(
      children: [
        ListView.separated(
          itemCount: noticeData.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            return Container(
                color: Colors.white,
                child: ListTile(
                  title: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                        width: double.infinity,
                        height: 130,
                        padding: EdgeInsets.only(top: 5,left: 1,right: 1),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      noticeData[index].date,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                      padding: EdgeInsets.fromLTRB(0, 5, 15, 0),
                                      child: Text(
                                        noticeData[index].detail,
                                        style: TextStyle(fontSize: 14),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                      )
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                            Container(
                                width: 100,
                                height: 100,
                                child: Container(
                                  child: Image.asset(noticeData[index].imgPath, fit: BoxFit.fill,),
                                )
                            ),
                          ],
                        ),
                      ),
                      //Divider(thickness: 5),
                    ],
                  ),
                  onTap: (){
                    pageAnimation(context, UserSecondAllimPage());
                    print(index);
                  },
                ),
            );
          }, separatorBuilder: (BuildContext context, int index) => const Divider(height: 9, color: Color(0xfff8f8f8),),
        ),
      ],
    );
  }
}