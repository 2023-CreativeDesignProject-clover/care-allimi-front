import 'package:flutter/material.dart';
import '/Supplementary/PageRouteWithAnimation.dart';

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

  void _showTimePicker(BuildContext context) {
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
                  String hour = index < 10 ? '0$index' : '$index';
                  return ListTile(
                    title: Text('$hour:00'),
                    onTap: () {
                      setState(() {
                        selectedTime = '$hour:00';
                      });
                      Navigator.of(context).pop();
                    },
                  );
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
        onTap: () {
          _showTimePicker(context);
          print('날짜 선택 Tap');
        }
    );
  }
}