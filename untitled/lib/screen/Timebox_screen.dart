import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeboxScreen extends StatelessWidget {
  final List<Map<String, dynamic>> schedules; // 스케줄 데이터 받기
  const TimeboxScreen({Key? key, required this.schedules}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Nano Calendar"),
          foregroundColor: const Color(0xFFFFFFFF),
          backgroundColor: const Color(0xFF1976D2)
        ),
        body: SfCalendar(
          view: CalendarView.week,
          todayHighlightColor: const Color(0xFF1976D2),
          dataSource: MeetingDataSource(_getDataSource(schedules)),
        )
    );
  }
  List<Meeting> _getDataSource(List<Map<String, dynamic>> schedules) {
    final List<Meeting> meetings = <Meeting>[];

    for (var schedule in schedules) {
      DateTime startTime = DateTime.utc(
        schedule['date'].year,
        schedule['date'].month,
        schedule['date'].day,
        schedule['startTime'].hour,
        schedule['startTime'].minute,
      );
      DateTime endTime = DateTime.utc(
        schedule['date'].year,
        schedule['date'].month,
        schedule['date'].day,
        schedule['endTime'].hour,
        schedule['endTime'].minute,
      );
      meetings.add(
        Meeting(
          schedule['content'],
          startTime,
          endTime,
          schedule['color'],
        ),
      );
    }
    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
}