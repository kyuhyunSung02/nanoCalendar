import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeboxScreen extends StatelessWidget {
  const TimeboxScreen({Key? key}) : super(key: key);

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
        )
    );
  }
}