import 'package:flutter/material.dart';

class AllimFirstDropdown extends StatefulWidget {
  const AllimFirstDropdown({Key? key}) : super(key: key);

  @override
  State<AllimFirstDropdown> createState() => _AllimFirstDropdownState();
}

class _AllimFirstDropdownState extends State<AllimFirstDropdown> {
  final items = ['금식', '전량섭취', '반량섭취'];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedValue = items[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
      DropdownButton<String>(
        value: selectedValue,
        items: items.map((e) => DropdownMenuItem(
            value: e,
            child: Text(e))).toList(),
        onChanged: (value) {setState(() => selectedValue = value!);},
      ),
    );
  }
}


/* ---------------------------------------------------------------------------------- */


class AllimSecondDropdown extends StatefulWidget {
  const AllimSecondDropdown({Key? key}) : super(key: key);

  @override
  State<AllimSecondDropdown> createState() => _AllimSecondDropdownState();
}

class _AllimSecondDropdownState extends State<AllimSecondDropdown> {
  final items = ['해당 사항 없음','아침', '점심', '저녁', '아침&점심', '아침&저녁', '점심&저녁', '아침&점심&저녁'];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedValue = items[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
      DropdownButton<String>(
        value: selectedValue,
        items: items.map((e) => DropdownMenuItem(
            value: e,
            child: Text(e))).toList(),
        onChanged: (value) {setState(() => selectedValue = value!);},
      ),
    );
  }
}


/* ---------------------------------------------------------------------------------- */

class NoticeDropdown extends StatefulWidget {
  const NoticeDropdown({Key? key}) : super(key: key);

  @override
  State<NoticeDropdown> createState() => _NoticeDropdownState();
}

class _NoticeDropdownState extends State<NoticeDropdown> {
  final items = ['공지사항', '중요'];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedValue = items[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      color: Colors.white,
      child:
      DropdownButton<String>(
        isExpanded: true,
        value: selectedValue,
        underline: SizedBox.shrink(),
        items: items.map((e) => DropdownMenuItem(
            value: e,
            child: Text(e))).toList(),
        onChanged: (value) {setState(() => selectedValue = value!);},
      ),
    );
  }
}
