import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/UserProvider.dart';
import 'PhoneNumberFormatter.dart';
import '/UI/Supplementary/ThemeColor.dart';
import '../Supplementary/CustomClick.dart';

ThemeColor themeColor = ThemeColor();

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  CheckClick checkClick = new CheckClick();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return myProfile();
  }

  String _getRoleText(String urole) {
    switch (urole) {
      case 'PROTECTOR':
        return '보호자';
      case 'WORKER':
        return '요양보호사';
      case 'MANAGER':
        return '시설장';
      case 'ADMIN':
        return '관리자';
      default:
        return urole;
    }
  }

  Widget myProfile() {
    final userProvider = context.watch<UserProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보'),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          text('아이디'),
          myProfileBox(userProvider.loginid),
          text('역할'),
          myProfileBox(_getRoleText(userProvider.urole)),
          text('이름'),
          myProfileBox(userProvider.name),
          text('전화번호'),
          myProfileBox(PhoneNumberFormatter.format(userProvider.phone_num),),
        ],
      ),
    );
  }

  Widget text(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
      child: Text('$text',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget myProfileBox(String text) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 65),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 16),
        decoration: BoxDecoration(
          color: Color(0xfff2f3f6),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(11.5, 0, 11.5, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text, textScaleFactor: 1.1,),
            ],
          ),
        ),
      ),
    );
  }
}
