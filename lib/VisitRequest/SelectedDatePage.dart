import 'package:flutter/material.dart';
import '/Supplementary/PageRouteWithAnimation.dart';

class SelectedDatePage extends StatefulWidget {
  const SelectedDatePage({Key? key}) : super(key: key);

  @override
  State<SelectedDatePage> createState() => _SelectedDatePageState();
}

class _SelectedDatePageState extends State<SelectedDatePage> {
  String selectedDate = '날짜 선택';

  @override
  Widget build(BuildContext context) {
    return selectedCalendar();
  }

  Widget selectedCalendar() {
    // ignore: no_leading_underscores_for_local_identifiers
    _showDatePicker(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        setState(() {
          selectedDate = '${picked.year}.${picked.month.toString().padLeft(2, '0')}.${picked.day.toString().padLeft(2, '0')}';
          // 선택한 날짜를 문자열로 변환하여 저장
        });
      }
    }

    return display(
        title: selectedDate,
        onTap: () {
          _showDatePicker(context);
          print('날짜 선택 Tap');
        }
    );
  }
}