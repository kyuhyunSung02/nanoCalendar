import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class _Time extends StatelessWidget {
  final TimeOfDay startTime; // 시작 시간
  final TimeOfDay endTime; // 종료 시간

  const _Time({
    required this.startTime,
    required this.endTime,
    Key? key
  }) : super(key: key);

  // TimeOfDay를 00:00 형식의 문자열로 변환하는 함수
  String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context){
    const textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Color(0xFF1976D2),
      fontSize: 16.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formatTime(startTime),
          style: textStyle,
        ),
        Text(
          formatTime(endTime),
          style: textStyle.copyWith(
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget{
  final String content; // 내용
  final String memo;

  const _Content({
    required this.content,
    required this.memo,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          // 메모가 비어있지 않으면 표시
          if (memo.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                height: 30.0, // 적절한 높이를 설정해서 텍스트가 넘어가지 않도록 조정
                child: SingleChildScrollView(  // 텍스트가 넘치면 스크롤 가능
                  child: Text(
                    '메모: $memo',
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis, // 텍스트가 넘칠 경우 말줄임 표시
                    maxLines: 2,  // 텍스트가 2줄을 넘지 않도록 설정
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget{
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String content;
  final String memo;
  final Color color;
  final bool isAlarmEnabled; // 알람 여부 추가
  final VoidCallback onAlarmToggle; // 알람 토글 콜백 추가

  const ScheduleCard({
    required this.startTime,
    required this.endTime,
    required this.content,
    required this.memo,
    required this.color,
    required this.isAlarmEnabled, // 알람 여부 매개변수 추가
    required this.onAlarmToggle, // 알람 토글 콜백 매개변수 추가
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: const Color(0xFF1976D2),
        ),
        borderRadius: BorderRadius.circular(8.0)
      ),

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child : IntrinsicHeight(
          child : Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Time(startTime: startTime, endTime: endTime),
              SizedBox(width: 16.0,),
              _Content(content: content, memo: memo),
              SizedBox(width: 16.0,),
              // 우측 가운데에 동그라미 색상 표시
              Center(
                child: Container(
                  width: 24.0, // 동그라미의 너비
                  height: 24.0, // 동그라미의 높이
                  decoration: BoxDecoration(
                    color: color, // 동그라미 색상
                    shape: BoxShape.circle, // 원형으로 설정
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              // 알람 아이콘 버튼
              Center(
                child: IconButton(
                  icon: Icon(
                    isAlarmEnabled
                        ? Icons.notifications // 알람이 활성화된 경우
                        : Icons.notifications_none, // 알람이 비활성화된 경우
                    color: isAlarmEnabled ? Colors.black : Colors.grey, // 색상 변경
                  ),
                  onPressed: onAlarmToggle, // 알람 상태 변경 함수 호출
                ),
              ),
            ],
          )
        )
      ),
    );
  }
}

class ScheduleListScreen extends StatelessWidget {
  const ScheduleListScreen({Key? key}) : super(key: key);

  // Firestore에서 데이터를 읽어오는 Stream
  Stream<List<Map<String, dynamic>>> _fetchSchedules() {
    return FirebaseFirestore.instance.collection('schedules').snapshots().map(
          (snapshot) {
        return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedules'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _fetchSchedules(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final schedules = snapshot.data ?? [];

          // 스케줄 카드 목록 표시
          return ListView.builder(
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];

              return ScheduleCard(
                startTime: _parseTimeOfDay(schedule['startTime']),
                endTime: _parseTimeOfDay(schedule['endTime']),
                content: schedule['content'],
                memo: schedule['memo'],
                color: Color(schedule['color']),
                isAlarmEnabled: schedule['isAlarmEnabled'] ?? false,
                onAlarmToggle: () {
                  // 알람 상태 업데이트
                  FirebaseFirestore.instance
                      .collection('schedules')
                      .doc(schedule['id']) // Firestore 문서 ID
                      .update({
                    'isAlarmEnabled': !(schedule['isAlarmEnabled'] ?? false),
                  });
                },
              );
            },
          );
        },
      ),
    );
  }

  // Firestore에서 가져온 시간을 TimeOfDay로 변환하는 함수
  TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(' ');
    final timeParts = parts[0].split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final isPM = parts[1].toUpperCase() == 'PM';
    return TimeOfDay(
      hour: isPM && hour != 12 ? hour + 12 : (hour == 12 && !isPM ? 0 : hour),
      minute: minute,
    );
  }
}