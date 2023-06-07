import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:test_data/UI/Supplementary/CustomWidget.dart';
import '/UI/Supplementary/ThemeColor.dart';
import '../Supplementary/CustomClick.dart';
import 'package:http/http.dart' as http; //http 사용
import 'package:test_data/Backend.dart';

ThemeColor themeColor = ThemeColor();

class ManagerCalendarPage extends StatefulWidget {
  const ManagerCalendarPage({Key? key, required this.residentId, required this.userRole, required this.facility_id}) : super(key: key);

  final int residentId;
  final int facility_id;
  final String userRole;

  @override
  State<ManagerCalendarPage> createState() => _ManagerCalendarPageState();
}

class Schedule {
  late int scheduleId;
  late String eventName; 

  Schedule(this.scheduleId, this.eventName);
}

class _ManagerCalendarPageState extends State<ManagerCalendarPage> {
  final formKey = GlobalKey<FormState>();
  CheckClick checkClick = new CheckClick();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  Map<String, List<Schedule>> mySelectedEvents = {};

  late int _facility_id;
  late String _userRole;
    late int _resident_id;

  final titleController = TextEditingController();
  final descpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDay;
    _facility_id = widget.facility_id;
    _resident_id = widget.residentId;
    _userRole = widget.userRole;
    loadPreviousEvents();
    getSchedules();
  }

  Future<void> deleteSchedule(int scheduleId) async {
    debugPrint("@@@스케줄 삭제 요청 보냄");
    http.Response response = await http.delete(
      Uri.parse(Backend.getUrl()+ 'schedule'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      },
      body: jsonEncode({
        "schedule_id": scheduleId,
        "nhr_id": _resident_id
      })
    );

    if (response.statusCode != 200) {

      throw Exception();
    } else {
      debugPrint("asdf@@@@");
    }
  }

  Future<void> getSchedules() async {
    debugPrint("월별 일정표 목록 요청 보냄");
    http.Response response = await http.get(
      Uri.parse(Backend.getUrl() + "schedule/" + _facility_id.toString()+ "/" + _focusedDay.toString().substring(0, 7)),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept-Charset': 'utf-8'
      }
    );

    debugPrint("@@response.statusCode: " + response.statusCode.toString());

    if (response.statusCode == 200) {
      var data =  utf8.decode(response.bodyBytes);
      dynamic decodedJson = json.decode(data);
      List<Map<String, dynamic>> parsedJson = List<Map<String, dynamic>>.from(decodedJson);

      mySelectedEvents = {};

      for (Map<String, dynamic> schedule in parsedJson) {
        List<String> result = schedule['date'].split('-'); //"2023-05-08"

        DateTime date = DateTime.utc(int.parse(result[0]), int.parse(result[1]), int.parse(result[2]));

        if (mySelectedEvents[DateFormat('yyyy-MM-dd').format(date!)] != null) {
          mySelectedEvents[DateFormat('yyyy-MM-dd').format(date!)]!.add(
            new Schedule(schedule['schedule_id'], schedule['texts'])
          );
        } else {
          mySelectedEvents[DateFormat('yyyy-MM-dd').format(date!)] = [
            new Schedule(schedule['schedule_id'], schedule['texts'])
          ];
        }
      }     
      setState(() {
        
      });
    } else {
      debugPrint("노노@@@");
    }
  }

  // 서버에 스케줄 업로드
  Future<void> addSchedule(date, texts) async {
    var url = Uri.parse(Backend.getUrl() + 'schedule');
    var headers = {'Content-type': 'application/json'};
    var body = json.encode({
      "writer_id": _resident_id,
      "date": DateFormat('yyyy-MM-dd').format(date),
      "texts": texts,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print("성공");
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('일정표')),
      body: ListView(
        children: [
          TableCalendar(
            locale: 'ko_KR', // 한국어
            firstDay: DateTime(2022),
            lastDay: DateTime(2100),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            daysOfWeekHeight: 20,
            headerStyle: HeaderStyle(
              titleCentered: true,
              titleTextFormatter: (date, locale) => DateFormat.yMMMMd(locale).format(date),
              formatButtonVisible: false,
              titleTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
              headerPadding: const EdgeInsets.symmetric(vertical: 0),
              leftChevronIcon: const Icon(Icons.arrow_left, size: 40),
              rightChevronIcon: const Icon(Icons.arrow_right, size: 40),
            ),
            calendarStyle: CalendarStyle(
              markersMaxCount: 1,
              todayDecoration : BoxDecoration( //오늘 날짜
                color: Color(0xff5BB193).withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              selectedDecoration : const BoxDecoration( //선택 날짜
                color: Color(0xff5BB193),
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
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
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here 
              // 달 바뀔 때 한 번만 호출됨
              _focusedDay = focusedDay;
              getSchedules();
            },
            eventLoader: _listOfDayEvents,
          ),
          for (Schedule sc in _listOfDayEvents(_selectedDate!)) ...[
            ListTile(
              leading: const Icon(Icons.done_rounded, color: Colors.teal),
              title: Text('${sc.eventName}', textScaleFactor: 0.95,),
                trailing: _getFAB(sc)
            )
          ],
        ],
      ),
      floatingActionButton: _getFAB2()
    );
  }

  Widget _getFAB(Schedule sc) {
    if (_userRole == 'PROTECTOR') {
      return Visibility(
        visible: false,
        child: Text('')
      );
    } else {
      return OutlinedButton(
        child: Text('삭제', style: TextStyle(color: Colors.grey)),
        style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3))),
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('삭제하시겠습니까?'),
                insetPadding:
                    const EdgeInsets.fromLTRB(0, 80, 0, 80),
                actions: [
                  TextButton(
                    child: Text('취소', style: TextStyle(color: themeColor.getColor())),
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('삭제', style: TextStyle(color: themeColor.getColor())),
                    style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
                    onPressed: () async {
                      if (checkClick.isRedundentClick(DateTime.now())) { //연타 막기
                        return ;
                      }
                      try {
                        await deleteSchedule(sc.scheduleId);
                        setState(() {
                          mySelectedEvents = {};
                          getSchedules();
                        });

                        showToast('삭제 완료');
                        Navigator.of(context).pop();

                      } catch (e) {

                      }
                    },
                  ),
                ],
              );
            });
        },
      );         
    
    }         
  }

  Widget _getFAB2() {
    if (_userRole == 'PROTECTOR') {
      return Container();
    } else {
      return FloatingActionButton(
        focusColor: Colors.white54,
        backgroundColor: themeColor.getColor(),
        elevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        onPressed: () { _showAddEventDialog(); },
        child: Icon(Icons.create_rounded, color: Colors.white),
      );
    }         

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
            Form(
              key: formKey,
              child: TextFormField(
                controller: titleController,
                validator: (value) {
                  if(value!.isEmpty) return '내용을 입력하세요';
                },
                textCapitalization: TextCapitalization.words,
                minLines: 1,
                maxLines: 10,
                decoration: const InputDecoration(
                  hintText: '내용',
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소', style: TextStyle(color: themeColor.getColor())),
            style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
          ),
          TextButton(
            child: Text('추가', style: TextStyle(color: themeColor.getColor())),
            style: ButtonStyle(overlayColor: MaterialStateProperty.all(themeColor.getColor().withOpacity(0.3))),
            onPressed: () async {

              if (checkClick.isRedundentClick(DateTime.now())) { //연타 막기
                return ;
              }

              if(this.formKey.currentState!.validate()) {

                await addSchedule(_selectedDate, titleController.text);

                setState(() {
                  mySelectedEvents = {};
                  getSchedules();
                });

                titleController.clear();
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
