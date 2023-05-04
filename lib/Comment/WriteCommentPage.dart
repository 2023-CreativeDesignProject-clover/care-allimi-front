import 'package:flutter/material.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import '/Supplementary/ThemeColor.dart';

ThemeColor themeColor = ThemeColor();

class WriteCommentPage extends StatefulWidget {
  const WriteCommentPage({Key? key}) : super(key: key);

  @override
  State<WriteCommentPage> createState() => _WriteCommentPageState();
}

class _WriteCommentPageState extends State<WriteCommentPage> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return customPage(
      title: '한마디 작성',
      onPressed: () {
        print('한마디');
        if(this.formKey.currentState!.validate()) {
          //TODO: 한마디 작성 완료 버튼 누르면 실행되어야 하는 부분
          Navigator.pop(context);
        }},
      body: commentWrite(),
      buttonName: '완료',
    );
  }

  Widget commentWrite(){
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('날짜'),
              // Container(
              //   width: double.infinity,
              //   child: OutlinedButton(
              //     onPressed: null,
              //     child: Text(
              //       '2023.12.25',
              //       style: TextStyle(color: Colors.black, fontSize: 18),
              //     ),
              //   ),
              // ),
              SizedBox(height: 5,),
              Container(
                padding: EdgeInsets.all(15),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xfff2f3f6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('2023.12.25', textScaleFactor: 1.3),
              ),
              SizedBox(height: 15,),
              Text('한마디 작성'),
              SizedBox(height: 5,),
              createField()
            ],
          ),
        ),
      ],
    );
  }
  Widget createField() {
    return Form(
      key: formKey,
      child: SizedBox(
        child: TextFormField(
          validator: (value) {
            if(value!.isEmpty) { return '내용을 입력하세요'; }
            else { return null; }
          },
          maxLines: 10,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color(0xfff2f3f6),
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
            //focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}