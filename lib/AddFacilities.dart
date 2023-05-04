import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';

class AddFacilities extends StatefulWidget {
  const AddFacilities({Key? key}) : super(key: key);

  @override
  State<AddFacilities> createState() => _AddFacilitiesState();
}

class _AddFacilitiesState extends State<AddFacilities> {

  final formKey = GlobalKey<FormState>();
  TextEditingController facilityNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController personNameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return addFacilities();
  }

  Widget addFacilities() {
    return Scaffold(
      body: SafeArea(
          child: ListView(
            children: [
              Text('시설 정보를 입력해주세요.'),


              //TODO: 시설명, 주소, 전번, 이름

              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      getTextFormField(
                          textInputType: TextInputType.text,
                          icon: Icons.home_rounded,
                          hintText: '시설명',
                          controller: facilityNameController,
                          errormsg: '시설명을 입력하세요'),

                      getTextFormField(
                          textInputType: TextInputType.text,
                          icon: Icons.place_rounded,
                          hintText: '주소',
                          controller: locationController,
                          errormsg: '주소를 입력하세요'),


                      getTextFormField(
                          textInputType: TextInputType.number,
                          inputFormatters: [
                            MultiMaskedTextInputFormatter(masks: ['xxx-xxxx-xxxx', 'xxx-xxx-xxxx'], separator: '-')
                          ],
                          icon: Icons.call_rounded,
                          hintText: '전화번호',
                          controller: numberController,
                          errormsg: '전화번호를 입력하세요'),

                      getTextFormField(
                          textInputType: TextInputType.text,
                          icon: Icons.person_rounded,
                          hintText: '시설장 이름',
                          controller: personNameController,
                          errormsg: '시설장 이름을 입력하세요'),
                    ],
                  )
              ),


              OutlinedButton(
                child: Text('확인'),
                onPressed: (){
                  print('시설 추가 확인 Tap');

                  if(this.formKey.currentState!.validate()) {
                    //TODO: 시설 추가 확인 버튼 누르면 실행되어야 할 부분

                  }

                },
              ),
            ],
          )
      ),
    );
  }


  Widget getTextFormField({
    TextInputType? textInputType,
    required IconData? icon,
    required String? hintText,
    required TextEditingController controller,
    required String? errormsg,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if(value!.isEmpty) { return errormsg; } else { return null; }
      },
      keyboardType: textInputType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        icon: Icon(icon),
        hintText: hintText,
        labelStyle: const TextStyle(color: Colors.black54),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: Colors.transparent),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 1, color: Colors.transparent),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        filled: true,
        fillColor: Color(0xfff2f3f6),
      ),
    );
  }
}