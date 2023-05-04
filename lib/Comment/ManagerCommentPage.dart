import 'package:flutter/material.dart';
import '/Supplementary/PageRouteWithAnimation.dart';

class ManagerCommentPage extends StatefulWidget {
  const ManagerCommentPage({Key? key}) : super(key: key);

  @override
  State<ManagerCommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<ManagerCommentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(title: Text('한마디')),
      body: commentList(),
    );
  }
  List<String> whosend =['삼족오 보호자님','사족오 보호자님','오족오 보호자님'];
  List<String> date =['2022.12.23','2022.12.24','2022.12.25'];
  List<String> com =['택배로 간식을 보냈으니 어머니께 드려주세요.','보호사님 오늘도 잘 부탁드립니다.','필요 물품을 택배로 보냈습니다.'];

  // 한마디 목록
  Widget commentList(){
    return ListView(
      children: [
        ListView.separated(
          itemCount: com.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white),
              height: 130,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(whosend[index], textScaleFactor: 1.0,),
                  Text(date[index], textScaleFactor: 1.0,),
                  SizedBox(height: 10,),
                  Text(com[index], textScaleFactor: 1.1,),
                ],
              ),
            );
          }, separatorBuilder: (BuildContext context, int index) => const Divider(height: 9, color: Color(0xfff8f8f8),),  //구분선(height로 상자 사이 간격을 조절)
        ),
      ],
    );
  }
}