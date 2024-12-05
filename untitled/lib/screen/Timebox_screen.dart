import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TimeboxScreen extends StatelessWidget {
  const TimeboxScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nano Calendar"),
        foregroundColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchSchedulesFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No schedules found.'));
          } else {
            return SfCalendar(
              view: CalendarView.week,
              todayHighlightColor: const Color(0xFF1976D2),
              dataSource: MeetingDataSource(_getDataSource(snapshot.data!)),
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchSchedulesFromFirestore() async {
    final snapshot = await FirebaseFirestore.instance.collection('schedules').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'content': data['content'],
        'date': DateTime.parse(data['date']),
        'startTime': _parseTime(data['startTime']),
        'endTime': _parseTime(data['endTime']),
        'color': Color(data['color']),
      };
    }).toList();
  }

  List<Meeting> _getDataSource(List<Map<String, dynamic>> schedules) {
    final List<Meeting> meetings = <Meeting>[];

    for (var schedule in schedules) {
      DateTime startTime = DateTime(
        schedule['date'].year,
        schedule['date'].month,
        schedule['date'].day,
        schedule['startTime'].hour,
        schedule['startTime'].minute,
      );
      DateTime endTime = DateTime(
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

  TimeOfDay _parseTime(dynamic time) {
    try {
      if (time is Timestamp) {
        // Timestamp를 DateTime으로 변환 후 TimeOfDay로 변환
        return TimeOfDay.fromDateTime(time.toDate());
      } else if (time is String) {
        // 'HH:mm AM/PM' 형식의 문자열 처리
        final timeParts = time.trim().split(' ');
        final hourMinuteParts = timeParts[0].split(':');
        int hour = int.parse(hourMinuteParts[0]);
        final int minute = int.parse(hourMinuteParts[1]);

        // AM/PM 처리
        if (timeParts.length == 2) {
          final period = timeParts[1].toUpperCase();
          if (period == 'PM' && hour != 12) {
            hour += 12;
          } else if (period == 'AM' && hour == 12) {
            hour = 0;
          }
        }

        return TimeOfDay(hour: hour, minute: minute);
      } else {
        // 기본값 반환
        return const TimeOfDay(hour: 0, minute: 0);
      }
    } catch (e) {
      // 예외 발생 시 기본값 반환
      print('Error parsing time: $time, $e');
      return const TimeOfDay(hour: 0, minute: 0);
    }
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
