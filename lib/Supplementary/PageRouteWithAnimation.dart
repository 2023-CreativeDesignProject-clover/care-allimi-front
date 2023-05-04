import 'package:flutter/material.dart';
import 'ThemeColor.dart';

ThemeColor themeColor = ThemeColor();

class PageRouteWithAnimation {
  final Widget page;

  PageRouteWithAnimation(this.page);

  Route slideRitghtToLeft() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
          ) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route slideLeftToRight() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
          ) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

//페이지 이동 함수
void pageAnimation(BuildContext context, Widget page) {
  PageRouteWithAnimation pageRouteWithAnimation = PageRouteWithAnimation(page);
  Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
}

//커스텀 페이지 위젯
Widget customPage({
  required String title,
  required VoidCallback onPressed,
  required Widget body,
  required String buttonName,
}) {
  return Scaffold(
    //backgroundColor: Colors.white,
    appBar: AppBar(
      title: Text('$title'),
      actions: [
        Padding(
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: 50,
            height: 10,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: themeColor.getColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Text('$buttonName', style: TextStyle(color: Colors.white), textScaleFactor: 1.0,),
              onPressed: onPressed,
            ),
          ),
        ),
      ],),
    body: body,
  );
}

//화면 클릭할 수 있는 위젯
Widget display({
  required String title,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
        width: double.infinity,
        height: 50,
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
          color: Color(0xfff2f3f6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(11.5, 0, 11.5, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('$title', textScaleFactor: 1.2),
              Icon(Icons.expand_more_rounded, color: Colors.black54),
            ],
          ),
        )
    ),
  );
}

//FloatingActionButton 커스텀
Widget writeButton(BuildContext context, Widget widget){
  return FloatingActionButton(
    focusColor: Colors.white54,
    backgroundColor: themeColor.getColor(),
    elevation: 0,
    focusElevation: 0,
    highlightElevation: 0,
    hoverElevation: 0,
    onPressed: () { pageAnimation(context, widget); },
    child: Icon(Icons.create_rounded, color: Colors.white),
  );
}