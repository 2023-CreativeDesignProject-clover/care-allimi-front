import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/Invite/InviteWaitPage.dart';
import 'package:test_data/LoginPage.dart';
import 'package:test_data/ResidentInfoInputPage.dart';
import 'package:test_data/SignupPage.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart';
import 'Supplementary/ThemeColor.dart';
import 'MainPage.dart';
import 'Setup/SetupPage.dart';

ThemeColor themeColor = ThemeColor();

void main() {
    runApp(
    //Provider 등록
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ResidentProvider())
      ],
          child: const MyApp())
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var _curIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child){
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(data: data.copyWith(textScaleFactor: 1.05), child: child!);
      },
      title: '요양원 알리미',
      theme: ThemeData(
        fontFamily: 'NotoSans',
        scaffoldBackgroundColor: Color(0xfff8f8f8), //기본 배경색
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(fontFamily: 'NotoSans', color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.5), //앱바 텍스트 색상
          backgroundColor: Colors.white, //앱바 배경색
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black
          ),
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Consumer2<UserProvider, ResidentProvider>(
        builder: (context, userProvider, residentProvider, child) {
          if (userProvider.uid == 0) {
            return LoginPage();
          } else if (userProvider.urole == '') {
            return InviteWaitPage();
          } else {
            debugPrint("@@@@@@@@@@" + userProvider.urole);
            return Scaffold(
              body: getPage(),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.black12, width: 0.5))),
                child: BottomNavigationBar(
                  onTap: (index) {
                    setState(() {
                      _curIndex = index;
                    });
                  },
                  currentIndex: _curIndex,
                  unselectedItemColor: Colors.grey,
                  selectedItemColor: themeColor.getColor(),
                  elevation: 0,
                  backgroundColor: Colors.white,
                  selectedFontSize: 12,
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: '홈'),
                    BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: '설정'),
                  ],
                ),
              ),
            );
          }

        }
      ),
    );
  }

  Widget getPage() {
    Widget page;
    switch(_curIndex) {
      case 0: page = MainPage(); break;
      case 1: page = SetupPage(); break;
      default: page = MainPage(); break;
    }
    return page;
  }
}