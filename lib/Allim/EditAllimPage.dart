import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/provider/AllimTempProvider.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart';
import '/Supplementary/ThemeColor.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import '/Supplementary/DropdownWidget.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as ppp;
import 'package:path_provider/path_provider.dart' as pp;
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http; //http 사용

String backendUrl = "http://52.78.62.115:8080/v2/";


ThemeColor themeColor = ThemeColor();

class EditAllimPage extends StatefulWidget {
  const EditAllimPage({Key? key, 
    required this.noticeId,
    required this.noticeDetail,
    required this.imageUrls,
    required this.facility_id
  }) : super(key: key);

  final Map<String, dynamic> noticeDetail;
  final List<String> imageUrls;

  final int noticeId;
  final int facility_id;

  @override
  State<EditAllimPage> createState() => _EditAllimPageState();
}

class _EditAllimPageState extends State<EditAllimPage> {
  final formKey = GlobalKey<FormState>();
  String selectedPerson = "수급자 선택";
  int selectedPersonId = 0;
  late int _facility_id;
  String _contents = '';
  String _subContents = '';

  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];
  List<Map<String, dynamic>> _residents = []; // 수정된 부분

  late int _noticeId;
  late Map<String, dynamic> _noticeDetail;
  late List<String> _imageUrls;

  void initState() {
    _noticeId = widget.noticeId;
    _noticeDetail = widget.noticeDetail;
    _imageUrls = widget.imageUrls;
    _facility_id = widget.facility_id;

    _contents = _noticeDetail['content'];
    getFacilityResident(_facility_id);

    getFile();
  }

  Future<void> getFile() async {
    List<XFile> filesList= await _fileFromImageUrl(_imageUrls);

    if (filesList != null) {
      setState(() {
        _pickedImgs.addAll(filesList);
      });
    }
  }

  Future<List<XFile>> _fileFromImageUrl(List<String> imageUrls) async {
    List<XFile> xfileList  = [];

    for (int i = 0; i<imageUrls.length; i++) {
      final response = await http.get(Uri.parse(imageUrls[i]));
      final documentDirectory = await pp.getApplicationDocumentsDirectory();
      final file = File(ppp.join(documentDirectory.path, i.toString() + ".jpg"));
      file.writeAsBytesSync(response.bodyBytes);

      final xfile = new XFile(file.path);
      xfileList.add(xfile);
    }

    return xfileList;
  }

  Future<void> getFacilityResident(int facilityId) async {
    debugPrint("@@@@@ 시설의 입소자 정보 받아오는 백앤드 url 보냄");

    http.Response response = await http.get(
      Uri.parse(backendUrl + "nhResidents/protectors/" + facilityId.toString()),
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
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _pickedImgs.addAll(images);
      });
    }
  }

  // 카메라
  Future<void> _takeImg() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _pickedImgs.add(image);
      });
    }
  }

  // 서버에 알림장 업로드 + 사진 업로드
  Future<void> editAllim(userId, facilityId) async {
    debugPrint("@@@@ 공지사항 수정 백엔드 요청 보냄");
    List<MultipartFile> _files = [];
    var formData = null;


    if (_pickedImgs.length != 0 ) {
      _files = _pickedImgs.map((img) 
          => MultipartFile.fromFileSync(img.path, contentType: MediaType("image", "jpg"))).toList();

      formData = FormData.fromMap({
        "notice": MultipartFile.fromString(
          jsonEncode(
            {"notice_id": _noticeId, "user_id": userId, "resident_id": selectedPersonId, 
            "content": _contents, "sub_content": _subContents}),
          contentType: MediaType.parse('application/json'),
        ),
        "file": _files
      });
    } else {
      formData = FormData.fromMap({
        "notice": MultipartFile.fromString(
          jsonEncode(
            {"notice_id": _noticeId, "user_id": userId, "resident_id": selectedPersonId, 
            "content": _contents, "sub_content": _subContents}),
          contentType: MediaType.parse('application/json'),
        ),
        "file": _files
      });
    }
    
    var dio = Dio();
    dio.options.contentType = 'multipart/form-data';

    var response = null;
    try {
     response = await dio.patch(backendUrl + 'notices', data: formData); // ipConfig -> IPv4 주소, TODO: 실제 주소로 변경해야 함
    }catch(e) {
      debugPrint("@@response .. : " + e.toString());
      throw new Exception();
    }
    debugPrint("@@StatusCode: " + response.statusCode.toString());

    if (response.statusCode == 200) {
      print("@@성공");
    } else {
      throw Exception();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer3<UserProvider, ResidentProvider,AllimTempProvider> (
      builder: (context, userProvider, residentProvider,allimTempProvider, child) {
        return customPage(
          title: '알림장 수정',
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
                        child: const Text('확인'),
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

              _subContents = '';
              _subContents += allimTempProvider.morning + '\n';
              _subContents += allimTempProvider.launch + '\n';
              _subContents += allimTempProvider.dinner + '\n';
              _subContents += allimTempProvider.medication;

              try {
                await editAllim(userProvider.uid, residentProvider.facility_id);
                _pickedImgs = [];
                setState(() {});
                Navigator.pop(context);
              } catch(e) {
                showDialog(
                  context: context,
                  barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text("알림장 업로드 실패! 다시 시도해주세요"),
                      insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                      actions: [
                        TextButton(
                          child: const Text('확인'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  }
                );
              }
            }
          },
          body: writePost(),
          buttonName: '완료',
        );
      }
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
        //testpicture(),
        getPicture(context),
        SizedBox(height: 20)
      ],
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

                //TODO: 수급자 선택하기 글자가 바뀌어야 함
                // 수급자 선택시 ex. 삼족오 님
                Text('$selectedPerson', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500))
              ],
            ),
            Icon(Icons.expand_more_rounded, color: Colors.grey),
          ],
        ),
      ),
      onTap: () {

        print('수급자 선택하기 Tap');

        //TODO: 수급자 선택 화면
        pageAnimation(context, selectedPersonPage());

      },
    );
  }

  Widget selectedPersonPage() {
    return Scaffold(
      appBar: AppBar(title: Text('수급자 선택')),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.info_rounded, color: Colors.grey),
                SizedBox(width: 5),
                Text('알림장을 전송할 수급자를 선택해주세요.'),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _residents.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.person_rounded, color: Colors.grey),
                  title: Row(
                    children: [
                      Text('${_residents[index]['name']} 님'), //TODO: 수급자 이름 리스트
                    ],
                  ),
                  onTap: () {
                    // TODO: 수급자 선택 시 처리할 이벤트
                    setState(() {
                      selectedPerson = '${_residents[index]['name']} 님'; 
                      selectedPersonId = _residents[index]['id'];
                    });

                    Navigator.pop(context);

                  },
                );
              },
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
          initialValue: _contents,
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
    List<String> subContent = _noticeDetail['sub_content'].toString().split('\n');
    return Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  Icon(Icons.info_rounded, size: 18, color: themeColor.getColor()),
                  Text(' 식사 및 투약 기록 선택', style: TextStyle(color: themeColor.getColor())),
                ],
              ),
            ),
            dropList('아침', AllimFirstDropdown(menu: "아침", initialVal: subContent[0])),
            dropList('점심', AllimFirstDropdown(menu: "점심", initialVal: subContent[1])),
            dropList('저녁', AllimFirstDropdown(menu: "저녁", initialVal: subContent[2])),
            dropList('투약', AllimSecondDropdown(initialVal: subContent[3])),
          ],
        )
    );
  }

  //사진
  Widget testpicture() {
    return Container(
      height: 130,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //사진 추가하는 버튼
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 3),
              child: Row(
                children: [
                  Icon(Icons.camera_alt_rounded, size: 18, color: themeColor.getColor()),
                  Text(' 사진 추가', style: TextStyle(color: themeColor.getColor())),
                ],
              ),
            ),
            onTap: () {

              //TODO: 사진 추가 기능
              print('사진 추가하기 Tap');
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Wrap(
                      children: [
                        ListTile(leading: Icon(Icons.camera_alt, color: Colors.grey), title: Text('카메라'),
                          onTap: () {
                            //TODO: 카메라 누르면 실행되어야 할 부분
                          },
                        ),
                        ListTile(leading: Icon(Icons.photo_library, color: Colors.grey), title: Text('갤러리'),
                          onTap: () {
                            //TODO: 갤러리 누르면 실행되어야 할 부분
                          },
                        ),
                      ],
                    );
                  }
              );

            },
          ),
        ],
      ),
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
          if (index != 0)
            debugPrint("@@img: " + _pickedImgs[index-1].path.toString());

          return Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(3, 8, 3, 8),
              width: 100,
              height: 100,
              child: DottedBorder(
                color: Colors.grey,
                child: Container(
                  child: (index == 0)? Center(child: addImages(context)) : Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
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
                              child: Icon(Icons.cancel_rounded, color: Colors.black54,),
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