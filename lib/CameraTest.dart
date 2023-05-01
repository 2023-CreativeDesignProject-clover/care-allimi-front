
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

String backendUrl = "http://13.125.155.244:8080/v2/";

class pickImages extends StatefulWidget {
  const pickImages({Key? key}) : super(key: key);

  @override
  State<pickImages> createState() => _pickImagesState();
}

class _pickImagesState extends State<pickImages> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];

  Future<void> _pickImg() async { // 앨범
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _pickedImgs.addAll(images);
      });
    }
  }

  Future<void> _takeImg() async { // 카메라
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
        jsonEncode({"user_id": 7, "nhresident_id": 1, "facility_id": 1, "contents": "flutter test", "sub_contents": "test입니다."}),
        contentType: MediaType.parse('application/json'),
      ),
      "file": _files
    });

    var dio = Dio();
    dio.options.contentType = 'multipart/form-data';
    final response = await dio.post(backendUrl + 'notices', data: formData); // ipConfig -> IPv4 주소, TODO: 실제 주소로 변경해야 함

    if (response.statusCode == 200) {
      print("성공");
    } else {
      print("실패");
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget addImages = IconButton(
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
                    leading: const Icon(Icons.photo), title: const Text("사진 앨범"),
                    onTap: () async {
                      Navigator.pop(context);
                      _pickImg();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera_alt), title: const Text("사진 찍기"),
                    onTap: () async {
                      Navigator.pop(context);
                      _takeImg();
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
        child: Icon(
          CupertinoIcons.plus,
          color: Colors.grey,
        ),
      ),
    );

    return Scaffold(
      body: ListView.builder(
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
                    child: (index == 0)? Center(child: addImages) : Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: (index == 0)? null
                                : DecorationImage(
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
      // 일단 플로팅버튼으로...
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.upload),
        onPressed: () {
          imageUpload();
          _pickedImgs = [];
          setState(() {});
        },
      ),
    );
  }
}


