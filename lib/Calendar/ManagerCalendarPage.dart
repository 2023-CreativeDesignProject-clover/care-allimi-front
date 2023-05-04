import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '/Supplementary/ThemeColor.dart';

ThemeColor themeColor = ThemeColor();

class ManagerCalendarPage extends StatefulWidget {
  const ManagerCalendarPage({Key? key}) : super(key: key);

  @override
  State<ManagerCalendarPage> createState() => _ManagerCalendarPageState();
}

class _ManagerCalendarPageState extends State<ManagerCalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  Map<String, List> mySelectedEvents = {};

  final titleController = TextEditingController();
  final descpController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDate = _focusedDay;
    loadPreviousEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('일정표')),
        body: ListView(
          children: [
            TableCalendar(
              locale: 'ko_KR', // 한국어
              firstDay: DateTime(2023),
              lastDay: DateTime(2100),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              headerStyle: HeaderStyle(
                titleCentered: true,
                titleTextFormatter: (date, locale) => DateFormat.yMMMMd(locale).format(date),
                formatButtonVisible: false,
                titleTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
                headerPadding: const EdgeInsets.symmetric(vertical: 4),
                leftChevronIcon: const Icon(Icons.arrow_left, size: 40),
                rightChevronIcon: const Icon(Icons.arrow_right, size: 40),
              ),
              calendarStyle: CalendarStyle(
                markerDecoration : const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDate, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDate = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDate, day);
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
              eventLoader: _listOfDayEvents,
            ),
            ..._listOfDayEvents(_selectedDate!).map((myEvents) =>
                ListTile(
                  leading: const Icon(Icons.done_rounded, color: Colors.teal),
                  title: Text('${myEvents['eventTitle']}'),
                  trailing: OutlinedButton(
                    child: Text('삭제'),
                    onPressed: (){
                      //TODO: 삭제 이벤트
                    },
                  ),
                  //subtitle: Text('Description:   ${myEvents['eventDescp']}'),
                ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          focusColor: Colors.white54,
          backgroundColor: themeColor.getColor(),
          elevation: 0,
          focusElevation: 0,
          highlightElevation: 0,
          hoverElevation: 0,
          onPressed: () { _showAddEventDialog(); },
          child: Icon(Icons.create_rounded, color: Colors.white),
        )
    );
  }


  loadPreviousEvents() {
    mySelectedEvents = {};
  }

  List _listOfDayEvents(DateTime dateTime) {
    if (mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
      return mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)]!;
    } else {
      return [];
    }
  }

  _showAddEventDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('일정 추가'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: '내용',
              ),
            ),
            // TextField(
            //   controller: descpController,
            //   textCapitalization: TextCapitalization.words,
            //   decoration: const InputDecoration(labelText: 'Description'),
            // ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            child: const Text('추가'),
            onPressed: () {
              if (titleController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('내용을 입력하세요'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              } else {
                print(titleController.text);
                //print(descpController.text);

                setState(() {
                  if (mySelectedEvents[
                  DateFormat('yyyy-MM-dd').format(_selectedDate!)] !=
                      null) {
                    mySelectedEvents[
                    DateFormat('yyyy-MM-dd').format(_selectedDate!)]
                        ?.add({
                      "eventTitle": titleController.text,
                      //"eventDescp": descpController.text,
                    });
                  } else {
                    mySelectedEvents[
                    DateFormat('yyyy-MM-dd').format(_selectedDate!)] = [
                      {
                        "eventTitle": titleController.text,
                        //"eventDescp": descpController.text,
                      }
                    ];
                  }
                });

                print(
                    "New Event for backend developer ${json.encode(mySelectedEvents)}");
                titleController.clear();
                //descpController.clear();
                Navigator.pop(context);
                return;
              }
            },
          )
        ],
      ),
    );
  }


}