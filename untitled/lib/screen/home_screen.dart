import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/screen/add_schedule.dart';
import 'package:untitled/screen/Timebox_screen.dart';
import 'package:untitled/screen/calendar_screen.dart';

// 시간 표시 위젯
class _Time extends StatelessWidget {
  final String startTime;
  final String endTime;

  const _Time({
    required this.startTime,
    required this.endTime,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Color(0xFF1976D2),
      fontSize: 16.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          startTime,
          style: textStyle,
        ),
        Text(
          endTime,
          style: textStyle.copyWith(
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }
}

// 내용 표시 위젯
class _Content extends StatelessWidget {
  final String content;

  const _Content({
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        content,
        style: const TextStyle(fontSize: 14.0),
      ),
    );
  }
}

// 일정 카드 위젯
class ScheduleCard extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String content;
  final Color borderColor;

  const ScheduleCard({
    required this.startTime,
    required this.endTime,
    required this.content,
    required this.borderColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: borderColor,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Time(startTime: startTime, endTime: endTime),
              const SizedBox(width: 16.0),
              _Content(content: content),
            ],
          ),
        ),
      ),
    );
  }
}

// HomeScreen 유지 및 수정
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
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 캘린더 화면
            CalendarScreen(
              selectedDate: selectedDate,
              onDaySelected: onDaySelected,
            ),

            // 일정 목록 표시
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('schedules')
                    .orderBy('createdAt') // 생성 시간 기준 정렬
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // 데이터 로딩 중
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    // 데이터가 없을 때
                    return const Center(child: Text('일정이 없습니다.'));
                  }

                  // Firestore에서 가져온 데이터 리스트
                  final scheduleDocs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: scheduleDocs.length,
                    itemBuilder: (context, index) {
                      final schedule = scheduleDocs[index].data() as Map<String, dynamic>;

                      // Firestore에서 받은 색상 처리
                      final borderColor = schedule['color'] != null
                          ? Color(int.parse(schedule['color'], radix: 16))
                          : const Color(0xFF1976D2);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: ScheduleCard(
                          startTime: schedule['morningTime'] ?? 'N/A',
                          endTime: schedule['afternoonTime'] ?? 'N/A',
                          content: schedule['title'] ?? 'Untitled',
                          borderColor: borderColor, // 테두리 색상 적용
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1976D2),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSchedule()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Color(0xFFFFFFFF),
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
              leading: const Icon(Icons.calendar_month),
              iconColor: const Color(0xFF1976D2),
              focusColor: const Color(0xFF1976D2),
              title: const Text('월간 달력'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_view_week),
              iconColor: const Color(0xFF1976D2),
              focusColor: const Color(0xFF1976D2),
              title: const Text('주간 타임박스'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TimeboxScreen()),
                );
              },
              trailing: const Icon(Icons.navigate_next),
            ),
          ],
        ),
      ),
    );
  }

  // 날짜 선택 시 상태 업데이트
  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
