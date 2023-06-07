import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/UI/Supplementary/CustomWidget.dart';
import 'package:test_data/provider/AllimTempProvider.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import '/UI/Supplementary/ThemeColor.dart';
import '/UI/Supplementary/PageRouteWithAnimation.dart';
import '/UI/Supplementary/DropdownWidget.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http; //http 사용
import '../Supplementary/CustomClick.dart';
import 'package:test_data/Backend.dart';

ThemeColor themeColor = ThemeColor();

class WriteAllimPage extends StatefulWidget {
  const WriteAllimPage({Key? key}) : super(key: key);

  @override
  State<WriteAllimPage> createState() => _WriteAllimPageState();
}

class _WriteAllimPageState extends State<WriteAllimPage> {
  CheckClick checkClick = new CheckClick();
  final formKey = GlobalKey<FormState>();
  String selectedPerson = "수급자 선택";
  int selectedPersonId = 0;
  String _contents = '';
  String _subContents = '';

  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];
    List<Map<String, dynamic>> _residents = []; // 수정된 부분

  Future<void> getFacilityResident(int facilityId) async {
    debugPrint("@@@@@ 시설의 입소자 정보 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
      Uri.parse(Backend.getUrl() + "nhResidents/protectors/" + facilityId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      }
    );

    var data =  utf8.decode(response.bodyBytes);
    dynamic decodedJson = json.decode(data);
    List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

    setState(() {
      _residents =  parsedJson;
    });
  }

  // 앨범
  Future<void> _pickImg() async {
    List<XFile>? images = await _picker.pickMultiImage(imageQuality: 50);

    if (images != null) {
      if (images.length + _pickedImgs.length > 10) {  
        int count = 10 - _pickedImgs.length;
        images = images.sublist(0, count);
      }

      setState(() {
        _pickedImgs.addAll(images!);
      });
    }
  }

  // 카메라
  Future<void> _takeImg() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      if (_pickedImgs.length + 1 <= 10) {  
        setState(() {
          _pickedImgs.add(image);
        });
        
      }
    }
  }

  // 서버에 알림장 업로드 + 사진 업로드
  Future<void> addAllim(int residentId) async {
    final List<MultipartFile> _files = _pickedImgs.map((img) => MultipartFile.fromFileSync(img.path, contentType: MediaType("image", "jpg"))).toList();
    var formData = FormData.fromMap({
      "notice": MultipartFile.fromString(
        jsonEncode(
          {"writer_id": residentId, "target_id": selectedPersonId,
           "contents": _contents, "sub_contents": _subContents}),
        contentType: MediaType.parse('application/json'),
      ),
      "file": _files
    });

    var dio = Dio();
    dio.options.contentType = 'multipart/form-data';
    final response = await dio.post(Backend.getUrl() + 'notices', data: formData); // ipConfig -> IPv4 주소(실제 주소로 변경)

    debugPrint("@@@@" + response.statusCode.toString());

    if (response.statusCode == 200) {
      print("성공");
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return customPage(
          title: '알림장 작성',
          buttonName: '완료',
          onPressed: () async {

            //수급자 선택 안하면 다이얼로그 띄우기
            if (selectedPersonId == 0) {
              showDialog(
                context: context,
                barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text("수급자를 선택해주세요!"),
                    insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                    actions: [
                      TextButton(
                        child: Text('확인', style: TextStyle(color: themeColor.getColor())),
                        style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                }
              );
              return;
            }

            if(this.formKey.currentState!.validate()) {
              this.formKey.currentState!.save();

              showDialog(
                context: context,
                barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text("알림장을 업로드하시겠습니까?"),
                    insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                    actions: [
                      TextButton(
                        child: Text('취소',style: TextStyle(color: themeColor.getColor())),
                        style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Consumer2<ResidentProvider,AllimTempProvider> (
                        builder: (context, residentProvider,allimTempProvider, child) {
                          return TextButton(
                            child: Text('확인',style: TextStyle(color: themeColor.getColor())),
                            style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                            onPressed: () async {
                              if (checkClick.isRedundentClick(DateTime.now())) { //연타 막기
                                return ;
                              }
                              _subContents = '';
                              _subContents += allimTempProvider.morning + '\n';
                              _subContents += allimTempProvider.launch + '\n';
                              _subContents += allimTempProvider.dinner + '\n';
                              _subContents += allimTempProvider.medication;

                              try {

                                await addAllim(residentProvider.resident_id);
                                _pickedImgs = [];

                                showToast('작성 완료');
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();

                              } catch(e) {
                                Navigator.of(context).pop();
                                print('업로드 실패@@@@@@@@@@@@@@@@@@@@@');
                                print(e);

                                if (e is DioError && e.response?.statusCode == 413) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text("이미지는 최대 10장까지 업로드할 수 있습니다"),
                                        actions: [
                                          TextButton(
                                            child: Text('확인',style: TextStyle(color: themeColor.getColor(),),),
                                            style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else if (e is DioError) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text("이미지 용량이 너무 큽니다"),
                                        actions: [
                                          TextButton(
                                            child: Text('확인',style: TextStyle(color: themeColor.getColor(),),),
                                            style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  showToast('알림장 업로드 실패! 다시 시도해주세요');
                                }
                              }
                              },
                            );
                        }
                      ),
                      ],
                    );
                  }
              );
            }
          },
          body: writePost(),
        );
  }

  Widget writePost() {
    return ListView(
      children: [
        //수급자 선택
        getPersonCard(),
        SizedBox(height: 8),
        //텍스트필드
        getTextField(),
        SizedBox(height: 8),
        //아침, 점심, 저녁, 투약 드롭다운버튼
        getDropdown(),
        SizedBox(height: 8),
        //사진
        getText(padding: EdgeInsets.fromLTRB(8, 8, 8, 0), text: ' 이미지는 최대 10장까지 업로드할 수 있습니다'),
        getPicture(context),
        SizedBox(height: 20)
      ],
    );
  }

  Widget getText({
    required EdgeInsetsGeometry padding,
    String? text
  }) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            Icon(Icons.info_rounded, size: 18, color: themeColor.getColor()),
            Expanded(
              child: Text(
                text!,
                style: TextStyle(color: themeColor.getColor()),
                overflow: TextOverflow.visible,
                maxLines: null,
              ),
            )
          ],
        ),
      ),
    );
  }

  //수급자 선택
  Widget getPersonCard() {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.all(7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.account_circle_rounded, color: Colors.grey, size: 50),
                SizedBox(width: 8),
                // 수급자 선택시 ex. 삼족오 님
                Text('$selectedPerson', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500))
              ],
            ),
            Icon(Icons.expand_more_rounded, color: Colors.grey),
          ],
        ),
      ),
      onTap: () {
        //수급자 선택 화면
        pageAnimation(context, selectedPersonPage());
      },
    );
  }

  Widget selectedPersonPage() {
    return Scaffold(
      appBar: AppBar(title: Text('수급자 선택')),
      body: ListView(
        children: [
          getText(padding: EdgeInsets.fromLTRB(8, 0, 8, 0), text: ' 알림장을 전송할 수급자를 선택하세요'),
          Container(
            color: Colors.white,
            child: Consumer<ResidentProvider>(
              builder: (context, residentProvider, child) {
                return FutureBuilder(
                  future: getFacilityResident(residentProvider.facility_id),
                  builder: (context, snapshot) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _residents.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Icon(Icons.person_rounded, color: Colors.grey),
                          title: Row(
                            children: [
                              Text('${_residents[index]['name']} 님'), // 수급자 이름 리스트
                            ],
                          ),
                          onTap: () {
                            // 수급자 선택 시 처리할 이벤트
                            setState(() {
                              selectedPerson = '${_residents[index]['name']} 님'; 
                              selectedPersonId = _residents[index]['id'];
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  }
                );
              }
            )
          ),
        ],
      ),
    );
  }

  //본문
  Widget getTextField() {
    return Form(
      key: formKey,
      child: SizedBox(
        width: double.infinity,
        height: 350,
        child: TextFormField(
          validator: (value) {
            if(value!.isEmpty) { return '내용을 입력하세요'; }
            else { return null; }
          },
          maxLines: 1000,
          decoration: const InputDecoration(
            hintText: '내용을 입력하세요',
            filled: true,
            fillColor: Colors.white,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          onSaved: (value) {
            _contents = value!;
          }
        ),
      ),
    );
  }

  //드롭다운 버튼
  Widget dropList(String value, Widget page) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        children: [
          Text('$value'),
          SizedBox(width: 30),
          page,
        ],
      ),
    );
  }

  Widget getDropdown() {
    return Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getText(padding: EdgeInsets.fromLTRB(8, 8, 8, 0), text: ' 식사 및 투약 기록 선택'),
            dropList('아침', AllimFirstDropdown(menu: "아침")),
            dropList('점심', AllimFirstDropdown(menu: "점심")),
            dropList('저녁', AllimFirstDropdown(menu: "저녁")),
            dropList('투약', AllimSecondDropdown()),
          ],
        )
    );
  }

  Widget getPicture(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
      height: 115,
      color: Colors.white,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _pickedImgs.length + 1,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(3, 8, 3, 8),
              width: 100,
              height: 100,
              child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(5),
                  color: Colors.grey.shade300,
                  child: Container(
                    child: (index == 0)? Center(child: addImages(context)) : Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: (index == 0)? null : DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(_pickedImgs[index - 1].path))
                            ),
                          ),
                        ),
                        Positioned(
                            top: 3,
                            right: 3,
                            child: GestureDetector(
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.cancel_rounded, color: Colors.black54, size: 20,),
                              ),
                              onTap: () {
                                _pickedImgs.removeAt(index - 1);
                                setState(() {});
                              },
                            )
                        ),
                      ],
                    ),
                  )
              ),
            ),
          );
        },
      ),
    );
  }

  Widget addImages(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (_pickedImgs.length == 10) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text("이미지는 최대 10장까지 업로드할 수 있습니다"),
                actions: [
                  TextButton(
                    child: Text('확인',style: TextStyle(color: themeColor.getColor(),),),
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          ); 
          return;
        }
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.camera_alt_rounded, color: Colors.grey), title: const Text('카메라'),
                      onTap: () async {
                        Navigator.pop(context);
                        _takeImg();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_rounded, color: Colors.grey), title: const Text('갤러리'),
                      onTap: () async {
                        Navigator.pop(context);
                        _pickImg();
                      },
                    ),
                  ],
                ),
              );
            }
        );
      },
      icon: Container(
        alignment: Alignment.center,
        child: Icon(CupertinoIcons.plus, color: Colors.grey),
      ),
    );
  }
}