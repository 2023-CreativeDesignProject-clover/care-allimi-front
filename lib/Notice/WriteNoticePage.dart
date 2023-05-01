import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_data/Supplementary/DropdownWidget.dart';
import '/Supplementary/ThemeColor.dart';
import '/Supplementary/PageRouteWithAnimation.dart';

ThemeColor themeColor = ThemeColor();

List<String> imgList = [
  'assets/images/tree.jpg',
  'assets/images/tree.jpg',
  'assets/images/cake.jpg',
  'assets/images/cake.jpg',
  'assets/images/tree.jpg'
];


class WriteNoticePage extends StatefulWidget {
  const WriteNoticePage({Key? key}) : super(key: key);

  @override
  State<WriteNoticePage> createState() => _WriteNoticePageState();
}

class _WriteNoticePageState extends State<WriteNoticePage> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];

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

  // 서버에 이미지 업로드
  Future<void> imageUpload() async {
    final List<MultipartFile> _files = _pickedImgs.map((img) => MultipartFile.fromFileSync(img.path, contentType: MediaType("image", "jpg"))).toList();

    var formData = FormData.fromMap({
      "notice": MultipartFile.fromString(
        jsonEncode({"user_id": 2, "target_id": 1, "facility_id": 1, "contents": "flutter test", "sub_contents": "test입니다."}),
        contentType: MediaType.parse('application/json'),
      ),
      "file": _files
    });

    var dio = Dio();
    dio.options.contentType = 'multipart/form-data';
    final response = await dio.post('http://192.168.0.5:8080/v2/notices', data: formData); // ipConfig -> IPv4 주소, TODO: 실제 주소로 변경해야 함

    if (response.statusCode == 200) {
      print("성공");
    } else {
      print("실패");
    }
  }

  @override
  Widget build(BuildContext context) {
    return customPage(
        title: '공지사항 작성',
        onPressed: () {
          print('공지사항 작성 완료버튼 누름');
          String titleTemp = titleController.text.replaceAll(' ', '');
          String bodyTemp = bodyController.text.replaceAll(' ', '');
          if(titleTemp.isEmpty){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("제목을 입력해주세요.")));
            return;
          }
          if(bodyTemp.isEmpty){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("내용을 입력해주세요.")));
            return;
          }
          Navigator.pop(context);

          //이미지 업로드
          imageUpload();
          _pickedImgs = [];
          setState(() {});

          //TODO: 공지 작성 완료버튼 누르면 실행되어야 할 부분
          },
        body: ListView(
          children: [

            Container(
              padding: EdgeInsets.fromLTRB(8, 0, 10, 0),
              color: Colors.white,
              child: Row(
                children: [
                  Icon(Icons.info_rounded, size: 18, color: Colors.grey),
                  Text(' 중요한 공지는 중요 태그를 사용하세요.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            NoticeDropdown(),

            SizedBox(height: 8),
            getTitle(),
            SizedBox(height: 8),
            getBody(),
            SizedBox(height: 8),
            getPicture(context),

          ],
        ),
        buttonName: '완료'
    );
  }


  //제목
  Widget getTitle() {
    return TextFormField(
      controller: titleController,
      decoration: const InputDecoration(
        hintText: '제목',
        filled: true,
        fillColor: Colors.white,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }

  //내용
  Widget getBody() {
    return SizedBox(
      width: double.infinity,
      height: 430,
      child: TextFormField(
        maxLines: 1000,
        controller: bodyController,
        decoration: const InputDecoration(
          hintText: '내용을 입력하세요',
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  //사진
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
