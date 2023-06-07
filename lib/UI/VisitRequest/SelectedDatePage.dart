import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/provider/VisitTempProvider.dart';
import '/UI/Supplementary/PageRouteWithAnimation.dart';
import '/UI/Supplementary/ThemeColor.dart';

ThemeColor themeColor = ThemeColor();

class SelectedDatePage extends StatefulWidget {
  const SelectedDatePage({Key? key}) : super(key: key);

  @override
  State<SelectedDatePage> createState() => _SelectedDatePageState();
}

class _SelectedDatePageState extends State<SelectedDatePage> {
  String selectedDate = '방문 날짜 선택';

  @override
  Widget build(BuildContext context) {
    return selectedCalendar(context);
  }

  _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: themeColor.getColor(), // 전체적인 색
                onPrimary: Colors.white, // 헤더 글씨
                onSurface: Colors.black, // 캘린더 글씨 색
              ),
            ),
            child: child!,
          );
        }
    );
    if (picked != null) {
      setState(() {
        selectedDate = '${picked.year}.${picked.month.toString().padLeft(2, '0')}.${picked.day.toString().padLeft(2, '0')}';
        // 선택한 날짜를 문자열로 변환하여 저장
        //2023.05.10

      });
    }
  }

  Widget selectedCalendar(BuildContext context_) {
    return display(
        title: selectedDate,
        onTap: () async {
          await _showDatePicker(context);
          Provider.of<VisitTempProvider>(context, listen: false).setDate(selectedDate);
        }
    );
  }
}
