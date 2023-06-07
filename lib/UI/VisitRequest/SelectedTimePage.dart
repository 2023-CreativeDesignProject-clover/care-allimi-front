import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/provider/VisitTempProvider.dart';
import '/UI/Supplementary/PageRouteWithAnimation.dart';
import '../Supplementary/ThemeColor.dart';

ThemeColor themeColor = ThemeColor();

class SelectedTimePage extends StatefulWidget {
  const SelectedTimePage({Key? key}) : super(key: key);

  @override
  State<SelectedTimePage> createState() => _SelectedTimePageState();
}

class _SelectedTimePageState extends State<SelectedTimePage> {
  String selectedTime = '방문 시간 선택';


  @override
  Widget build(BuildContext context) {
    return selectedCalendar();
  }

  Future<void> _showTimePicker(BuildContext context_) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('방문 시간 선택'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              itemCount: 24,
              itemBuilder: (BuildContext context, int index) {
                if (index >= 9 && index <= 18) {
                  String hour = index < 10 ? '0$index' : '$index';
                  return ListTile(
                    title: Text('$hour:00'),
                    onTap: () {
                      setState(() {
                        selectedTime = '$hour:00';
                        Provider.of<VisitTempProvider>(context, listen: false).setTime(selectedTime); //04:00
                      });
                      Navigator.of(context).pop();
                    },
                  );
                } else {
                  return Container(); // 범위 이외의 시간은 빈 컨테이너로 반환하여 표시되지 않게 함
                }
              },
            ),
          ),
          actions: [
            TextButton(child: Text('취소',
                style: TextStyle(color: themeColor.getMaterialColor())),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        );
      });
  }

  Widget selectedCalendar() {
    return display(
        title: selectedTime,
        onTap: () async {
          await _showTimePicker(context);
        }
    );
  }
}
