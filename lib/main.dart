import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_data/UI/BeforeMain/InviteWaitPage.dart';
import '/UI/BeforeMain/LoginPage.dart';
import 'package:test_data/provider/AllimTempProvider.dart';
import 'package:test_data/provider/NoticeTempProvider.dart';
import 'package:test_data/provider/ResidentProvider.dart';
import 'package:test_data/provider/UserProvider.dart';
import 'package:test_data/provider/VisitTempProvider.dart';
import 'UI/Supplementary/CustomWidget.dart';
import 'UI/Supplementary/ThemeColor.dart';
import 'UI/Main/MainPage.dart';
import 'UI/Setup/SetupPage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

ThemeColor themeColor = ThemeColor();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await initializeDateFormatting();
  runApp(
    //Provider 등록
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ResidentProvider()),
        ChangeNotifierProvider(create: (_) => AllimTempProvider()),
        ChangeNotifierProvider(create: (_) => VisitTempProvider()),
        ChangeNotifierProvider(create: (_) => NoticeTempProvider())
      ],
      child: const MyApp())
  );
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _curIndex = 0;
  late MainPage mainPage;
  late SetupPage setupPage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        final MediaQueryData data = MediaQuery.of(context);

        return MediaQuery(
          data: data.copyWith(textScaleFactor: 1.05), //기본 글자 크기
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: child!,
          ),
        );
      },
      title: '요양원 알리미',
      //앱 자체 언어 설정 함으로써 캘린더를 한국어로 변경
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', 'KR'),
      ],
      theme: ThemeData(
        fontFamily: 'NotoSans',
        scaffoldBackgroundColor: Colors.white, //기본 배경색 Color
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(fontFamily: 'NotoSans', color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), //앱바 텍스트 색상
          backgroundColor: Colors.white, //앱바 배경색
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black
          ),
        ),
        textTheme: TextTheme(
          labelLarge: TextStyle(fontSize: 14), //폰트 크기
        ),
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: themeColor.getMaterialColor(), //커서 색상
            selectionColor: const Color(0xffEAEAEA), //드래그 색상
            selectionHandleColor: themeColor.getMaterialColor() //water drop 색상
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.uid == 0) {          //userProvider의 uid값이 0이면 로그인이 되지 않은 상태 -> 로그인 페이지로 감
            return LoginPage();
          }
          else if (userProvider.urole == '') {  //userProvider의 user role 역할이 없으면 입소자 등록이 안된 상태 -> 초대화면으로 감
            return InviteWaitPage(uid: userProvider.uid);
          }       
          //로그인도 되었고 입소자도 있을 때 화면
          else {
            mainPage = new MainPage(userRole: userProvider.urole);
            setupPage = new SetupPage(userRole: userProvider.urole, userId: userProvider.uid);

            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {

                return WillPopScope(
                  child: Scaffold(
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
                  ),
                onWillPop: () async {
                  bool result = onWillPop();
                  return await Future.value(result);
                },);
              }
            );
          }
        }
      ),
    );
  }

  Widget getPage() {
    Widget page;
    switch(_curIndex) {
      case 0: page = mainPage; break;
      case 1: page = setupPage; break;
      default: page = mainPage; break;
    }
    return page;
  }
}