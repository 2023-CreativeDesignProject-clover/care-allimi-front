import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_data/VisitRequest/SelectedTimePage.dart';
import '/Supplementary/ThemeColor.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'SelectedDatePage.dart';

ThemeColor themeColor = ThemeColor();
List<String> dateList =['2022.12.23','2022.12.24','2022.12.25'];
List<String> timeList =['16:00', '13:00', '11:00'];
List<String> personList =['삼족오 보호자님', '사족오 보호자님', '오족오 보호자님'];
List<String> textList =['면회 신청합니다.', '면회 신청합니다. 동생이 갑니다.', '면회 신청합니다.'];
List<String> subtextList =[' ', '거절하였습니다. (면회 시간이 아님)', ' 수락하였습니다.'];

class ManagerRequestPage extends StatefulWidget {
  const ManagerRequestPage({Key? key}) : super(key: key);

  @override
  State<ManagerRequestPage> createState() => _ManagerRequestPageState();
}

class _ManagerRequestPageState extends State<ManagerRequestPage> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController bodyController = TextEditingController(text: '면회 신청합니다.');
  late final TextEditingController refusalController = TextEditingController();
  String selectedHour = '시간 선택';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('면회 목록')),
      body: RequestList(),
      floatingActionButton: writeButton(),
    );
  }

  // 면회 리스트
  Widget RequestList() {
    return  ListView.separated(
      itemCount: textList.length, //면회 목록 출력 개수
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          color: Colors.white,
          child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(dateList[index]), //TODO: 면회 날짜
                      SizedBox(width: 10),
                      Icon(Icons.schedule_rounded, color: Colors.grey, size: 20),
                      SizedBox(width: 2),
                      Text(timeList[index]), //TODO: 면회 시간
                      const Spacer(),
                      OutlinedButton(
                        child: Text('수락'),
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (context) =>
                                AlertDialog(
                                  content: const Text('면회 신청을 수락하시겠습니까?'),
                                  actions: [
                                    TextButton(child: Text('취소',
                                        style: TextStyle(color: themeColor.getMaterialColor())),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                    TextButton(child: Text('예',
                                        style: TextStyle(color: themeColor.getMaterialColor())),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          //TODO: 면회 수락 이벤트
                                        }),
                                  ],
                                ),
                          );
                        },
                      ),
                      const SizedBox(width: 3),
                      OutlinedButton(
                        child: const Text('거절'),
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (context) =>
                                AlertDialog(
                                  title: const Text('거절 사유'),
                                  content: Form(
                                    key: formKey,
                                    autovalidateMode: AutovalidateMode.always,
                                    child: TextFormField(
                                      controller: refusalController,
                                      validator: (value) {
                                        if(value!.isEmpty) return '면회 거절 사유를 입력하세요.';
                                      },
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      minLines: 1,
                                      maxLines: 10,
                                      decoration: const InputDecoration(
                                        hintText: '내용을 입력하세요',
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        //focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(child: Text('취소',
                                        style: TextStyle(color: themeColor.getMaterialColor())),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                    TextButton(child: Text('예',
                                        style: TextStyle(color: themeColor.getMaterialColor())),
                                        onPressed: () {
                                          if(this.formKey.currentState!.validate()) {

                                            //TODO: 면회 거절 버튼 누르면 실행되어야 하는 부분

                                            Navigator.pop(context);
                                          }
                                          Future.delayed(const Duration(milliseconds: 300), () {
                                            refusalController.text = '';
                                          });
                                        }),
                                  ],
                                ),
                          );
                        },
                      ),
                    ],
                  ),
                  Text(personList[index]), //TODO: ㅇㅇㅇ 보호자님 출력
                  Text(textList[index]), //TODO: 할 말 출력
                  Divider(thickness: 0.5),
                  Text(subtextList[index], style: TextStyle(color: themeColor.getColor())), //TODO: 수락/거절 출력
                ],
              )
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
    );
  }

  //글쓰기 버튼
  Widget writeButton(){
    return FloatingActionButton(
      focusColor: Colors.white54,
      backgroundColor: themeColor.getColor(),
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      onPressed: () { pageAnimation(context, writePage()); },
      child: Icon(Icons.create_rounded, color: Colors.white),
    );
  }

  //글쓰기 화면
  Widget writePage() {
    return customPage(
      title: '면회 신청',
      onPressed: () {
        String bodyTemp = bodyController.text.replaceAll(' ', '');
        if(bodyTemp.isEmpty){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('할 말 내용을 입력해주세요.')));
          return;
        }

        //TODO: ------------------------ 면회신청 완료 누르면 실행되어야 할 부분
        Navigator.pop(context);


        //TODO: ------------------------
        Future.delayed(Duration(milliseconds: 300), () {
          bodyController.text = '면회 신청합니다.'; //TextFormField 처음으로 초기화
        });
      },
      body: ListView(
        children: [

          //TODO: 날짜, 할말(메모) 만들기
          text('날짜'),
          SelectedDatePage(),
          text('방문 시간'),
          SelectedTimePage(),
          text('할 말'),
          textFormField(),

        ],
      ),
      buttonName: '접수',
    );
  }

  //글자 출력
  Widget text(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 6),
      child: Text('$text'),
    );
  }

  //할 말
  Widget textFormField() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: SizedBox(
          height: 200,
          child: TextFormField(
            controller: bodyController,
            maxLines: 100,
            inputFormatters: [LengthLimitingTextInputFormatter(500)], //최대 500글자까지 작성 가능
            textAlignVertical: TextAlignVertical.center,
            decoration: const InputDecoration(
              labelStyle: TextStyle(color: Colors.black54),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(width: 1, color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(width: 1, color: Colors.transparent),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              filled: true,
              fillColor: Color(0xfff2f3f6),
              //fillColor: Colors.greenAccent,
            ),
          ),
        )
    );
  }






}