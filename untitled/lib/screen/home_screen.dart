import 'package:flutter/material.dart';
import 'package:untitled/screen/Timebox_screen.dart';
import 'package:untitled/screen/add_schedule.dart';
import 'package:untitled/screen/calendar_screen.dart';
import 'package:untitled/screen/schedule_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Nano Calendar"),
          foregroundColor: const Color(0xFFFFFFFF),
          backgroundColor: const Color(0xFF1976D2)
      ),
      body: SafeArea(
          child: Column(
            children: [
              CalendarScreen(selectedDate: selectedDate, onDaySelected: onDaySelected,),
              ScheduleCard(startTime: 12, endTime: 14, content: "고모프", memo: "플러터 및 파이어베이스 회의",)
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF1976D2),
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddSchedule())
          );
        },
        child: Icon(
          Icons.add,
          color: const Color(0xFFFFFFFF),
        ),
      ),
      drawer: Drawer(
          child: ListView(
            children: [
              const UserAccountsDrawerHeader(
                accountName: Text("Name"),
                accountEmail: Text("accountEmail"),
                decoration: BoxDecoration(color: Color(0xFF1976D2)),
              ),
              ListTile(
                leading: Icon(Icons.calendar_month),
                iconColor: const Color(0xFF1976D2),
                focusColor: const Color(0xFF1976D2),
                title: Text('월간 달력'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen())
                  );
                },
                trailing: Icon(Icons.navigate_next),
              ),
              ListTile(
                leading: Icon(Icons.calendar_view_week),
                iconColor: const Color(0xFF1976D2),
                focusColor: const Color(0xFF1976D2),
                title: Text('주간 타임박스'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TimeboxScreen())
                  );
                },
                trailing: Icon(Icons.navigate_next),
              )
            ],
          ),
      ),
    );
  }
  void onDaySelected(DateTime selectedDate, DateTime focuesdDate){
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}