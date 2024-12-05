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
        'date': DateTime.parse(data['date']), // "2024-12-05"
        'startTime': TimeOfDay(
          hour: int.parse(data['startTime'].split(':')[0]),
          minute: int.parse(data['startTime'].split(':')[1]),
        ),
        'endTime': TimeOfDay(
          hour: int.parse(data['endTime'].split(':')[0]),
          minute: int.parse(data['endTime'].split(':')[1]),
        ),
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
