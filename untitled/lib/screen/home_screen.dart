import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/screen/Timebox_screen.dart';
import 'package:untitled/screen/add_schedule.dart';
import 'package:untitled/screen/calendar_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'schedule_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime
        .now()
        .year,
    DateTime
        .now()
        .month,
    DateTime
        .now()
        .day,
  );

  // Firestore에서 일정 데이터를 가져오는 Stream
// Firestore에서 현재 로그인한 사용자의 일정 데이터를 가져오는 Stream
  Stream<List<Map<String, dynamic>>> _fetchSchedules() {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 가져오기
    if (user != null) {
      // 사용자의 UID를 사용하여 Firestore 경로 설정
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid) // 사용자 문서 참조
          .collection('schedules') // 사용자별 일정 컬렉션
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id; // 문서 ID 추가
          return data as Map<String, dynamic>;
        }).toList();
      });
    } else {
      // 사용자가 로그인되지 않았을 경우 빈 Stream 반환
      return Stream.value([]);
    }
  }


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
            CalendarScreen(
              selectedDate: selectedDate,
              onDaySelected: onDaySelected,
            ),
            // 선택된 날짜의 스케줄 표시
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _fetchSchedules(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final schedules = snapshot.data ?? [];

                  // 선택된 날짜의 스케줄 필터링
                  final filteredSchedules = schedules.where((schedule) {
                    final dynamic rawDate = schedule['date'];
                    DateTime scheduleDate;

                    // date 필드가 Timestamp인지 확인하고 변환
                    if (rawDate is Timestamp) {
                      scheduleDate = rawDate.toDate();
                    } else if (rawDate is String) {
                      // date 필드가 String이면 DateTime으로 파싱
                      scheduleDate = DateTime.parse(rawDate);
                    } else {
                      // 지원하지 않는 형식의 경우 스킵
                      return false;
                    }

                    // 선택된 날짜와 비교
                    return scheduleDate.year == selectedDate.year &&
                        scheduleDate.month == selectedDate.month &&
                        scheduleDate.day == selectedDate.day;
                  }).toList();


                  return ListView.builder(
                    itemCount: filteredSchedules.length,
                    itemBuilder: (context, index) {
                      final schedule = filteredSchedules[index];
                      return Slidable(
                        key: Key(schedule['id']),
                        startActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddSchedule(
                                      selectedDate: selectedDate,
                                      existingSchedule: {
                                        ...schedule,
                                        'startTime': _parseTime(schedule['startTime']),
                                        'endTime': _parseTime(schedule['endTime']),
                                      },
                                    ),
                                  ),
                                ).then((updatedSchedule) {
                                  if (updatedSchedule != null) {
                                    final user = FirebaseAuth.instance.currentUser;
                                    if (user != null) {
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('schedules')
                                          .doc(schedule['id'])
                                          .update(updatedSchedule);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("로그인이 필요합니다.")),
                                      );
                                    }
                                  }
                                });
                              },
                              backgroundColor: Colors.blue,
                              icon: Icons.edit,
                              label: '편집',
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                final user = FirebaseAuth.instance.currentUser;
                                if (user != null) {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .collection('schedules')
                                      .doc(schedule['id'])
                                      .delete();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("로그인이 필요합니다.")),
                                  );
                                }
                              },
                              backgroundColor: Colors.red,
                              icon: Icons.delete,
                              label: '삭제',
                            ),
                          ],
                        ),
                        child: ScheduleCard(
                          startTime: _parseTime(schedule['startTime']),
                          endTime: _parseTime(schedule['endTime']),
                          content: schedule['content'],
                          memo: schedule['memo'],
                          color: Color(schedule['color']),
                          isAlarmEnabled: schedule['isAlarmEnabled'],
                          onAlarmToggle: () {
                            FirebaseFirestore.instance
                                .collection('schedules')
                                .doc(schedule['id'])
                                .update({
                              'isAlarmEnabled': !schedule['isAlarmEnabled'],
                            });
                          },
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
          onPressed: () async {
            // AddSchedule 화면에서 데이터를 받아 Firestore에 저장
            final newSchedule = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddSchedule(selectedDate: selectedDate),
              ),
            );
            if (newSchedule != null) {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('schedules')
                    .add(newSchedule);
              } else {
                // 로그인되지 않은 경우 처리 (필요 시)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("로그인이 필요합니다.")),
                );
              }
            }
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
              title: const Text('월간 달력'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
              trailing: const Icon(Icons.navigate_next),
            ),
      ListTile(
        leading: const Icon(Icons.calendar_view_week),
        iconColor: const Color(0xFF1976D2),
        title: const Text('주간 타임박스'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TimeboxScreen(),
            ),
          );
        },
        trailing: const Icon(Icons.navigate_next),
      ),
          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }

  TimeOfDay _parseTime(dynamic time) {
    try {
      if (time is Timestamp) {
        // Timestamp를 DateTime으로 변환 후 TimeOfDay로 변환
        return TimeOfDay.fromDateTime(time.toDate());
      } else if (time is String) {
        // 'HH:mm' 또는 'HH:mm AM/PM' 형식의 문자열 처리
        final timeParts = time.split(' ');
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
