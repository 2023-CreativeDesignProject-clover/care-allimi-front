import 'package:flutter/material.dart';
import 'Supplementary/ThemeColor.dart';
import 'MainPage.dart';
import 'NotificationPage.dart';
import 'SetupPage.dart';

ThemeColor themeColor = ThemeColor();

void main() {
  runApp(const MyApp());
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
      builder: (context, child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
            data: data.copyWith(textScaleFactor: 1.05), child: child!);
      },
      title: '요양원 알리미',
      theme: ThemeData(
        fontFamily: 'NotoSans',
        scaffoldBackgroundColor: Color(0xfff8f8f8), //기본 배경색
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
              fontFamily: 'NotoSans',
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18.5), //앱바 텍스트 색상
          backgroundColor: Colors.white, //앱바 배경색
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: getPage(),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Colors.black12, width: 0.5))),
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
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded), label: '홈'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_rounded), label: '내 소식'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings_rounded), label: '설정'),
            ],
          ),
        ),
      ),
    );
  }

  Widget getPage() {
    Widget page;
    switch (_curIndex) {
      case 0:
        page = MainPage();
        break;
      case 1:
        page = NotificationPage();
        break;
      case 2:
        page = SetupPage();
        break;
      default:
        page = MainPage();
        break;
    }
    return page;
  }
}
