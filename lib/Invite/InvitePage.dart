import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/Supplementary/PageRouteWithAnimation.dart';

//초대하기 화면

class InvitePage extends StatefulWidget {
  const InvitePage({Key? key}) : super(key: key);

  @override
  State<InvitePage> createState() => _InvitePageState();
}
enum Answer {protect, employee}

class _InvitePageState extends State<InvitePage> {
  String result = '';
  bool isprotect = true;
  bool isemployee = false;
  late List<bool> isSelected;

  @override
  void initState() {
    isSelected = [isprotect, isemployee];
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return customPage(
      title: '초대하기',
      onPressed: () {
        print('초대하기 누름');

        if(this.formKey.currentState!.validate()) {

          //TODO: 확인 버튼 누르면 실행되어야 하는 부분

          Navigator.pop(context);
        }},
      body: inviteFormat(),
      buttonName: '확인',
    );
  }
  Widget inviteFormat(){
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index){
        return Container(
          //color: Colors.white,
          child: Column(
            children: [
              Container(
                //color: Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: const Text('초대하실 유형을 선택해주세요', textScaleFactor: 1.1,),
                  subtitle: Column(
                    children: [
                      SizedBox(height: 25,),
                      ToggleButtons(
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50,vertical: 50),
                              child: Text('보호자', style: TextStyle(fontSize: 18))),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50,vertical: 50),
                              child: Text('직원', style: TextStyle(fontSize: 18))),
                        ],
                        isSelected: isSelected,
                        onPressed: toggleSelect,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                //color: Colors.white,
                  padding: EdgeInsets.only(left: 18,top: 12, right: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 10,),
                      Text('휴대폰 번호', textScaleFactor: 1.1,),
                      SizedBox(height: 5,),
                      Form(
                        key: formKey,
                        child: SizedBox(
                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly, //숫자만 가능
                              NumberFormatter(), // 자동으로 하이픈
                              LengthLimitingTextInputFormatter(13) //13자리만 입력(하이픈 2+숫자 11)
                            ],
                            validator: (value) {
                              if(value!.isEmpty||value.length!=13) { return '번호를 입력해주세요'; }
                              else { return null; }
                            },
                            keyboardType: TextInputType.number, //키보드는 숫자
                            maxLines: 1,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xfff2f3f6),
                              //fillColor: Colors.white,
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
                      ),
                      SizedBox(height: 60,),

                    ],
                  )
              ),
            ],
          ),
        );

      },
    );
  }
  void toggleSelect(value) {
    if (value == 0) {
      isprotect = true;
      isemployee = false;
    } else {
      isprotect = false;
      isemployee = true;
    }
    setState(() {
      isSelected = [isprotect, isemployee];
    });
  }
}
//자동 하이픈
class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex <= 3) {
        if (nonZeroIndex % 3 == 0 && nonZeroIndex != text.length) {
          buffer.write('-');
        }
      } else {
        if (nonZeroIndex % 7 == 0 &&
            nonZeroIndex != text.length &&
            nonZeroIndex > 4) {
          buffer.write('-');
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }

}