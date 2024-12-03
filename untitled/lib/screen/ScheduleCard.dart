import 'package:flutter/material.dart';

// 일정 카드 위젯 정의 (일정 정보를 표시하는 역할)
class ScheduleCard extends StatelessWidget {
  final TimeOfDay startTime; // 일정 시작 시간
  final TimeOfDay endTime; // 일정 종료 시간
  final String content; // 일정 제목 또는 내용
  final String memo; // 일정에 대한 메모
  final Color color; // 일정 카드 색상
  final bool isAlarmEnabled; // 알람 설정 여부
  final VoidCallback onAlarmToggle; // 알람 설정을 토글하는 콜백 함수

  const ScheduleCard({
    required this.startTime,
    required this.endTime,
    required this.content,
    required this.memo,
    required this.color,
    required this.isAlarmEnabled,
    required this.onAlarmToggle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: const Color(0xFF1976D2), // 파란색 테두리
        ),
        borderRadius: BorderRadius.circular(8.0), // 둥근 모서리 설정
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // 내부 여백 설정
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Time(startTime: startTime, endTime: endTime), // 일정 시작 및 종료 시간을 표시하는 위젯
              SizedBox(width: 16.0),
              _Content(content: content, memo: memo), // 일정 제목 및 메모를 표시하는 위젯
              SizedBox(width: 16.0),
              Center(
                child: Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    color: color, // 일정 카드 색상
                    shape: BoxShape.circle, // 원형 모양
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Center(
                child: IconButton(
                  icon: Icon(
                    isAlarmEnabled ? Icons.notifications : Icons.notifications_none, // 알람 설정 여부에 따른 아이콘 변경
                    color: isAlarmEnabled ? Colors.black : Colors.grey, // 알람 여부에 따른 색상 변경
                  ),
                  onPressed: onAlarmToggle, // 알람 설정 토글 함수 호출
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 일정 시작 및 종료 시간을 표시하는 위젯
class _Time extends StatelessWidget {
  final TimeOfDay startTime; // 시작 시간
  final TimeOfDay endTime; // 종료 시간

  const _Time({required this.startTime, required this.endTime, Key? key}) : super(key: key);

  // TimeOfDay를 형식화하여 문자열로 반환하는 함수
  String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0'); // 시간 값을 두 자리로 패딩
    final minute = time.minute.toString().padLeft(2, '0'); // 분 값을 두 자리로 패딩
    return '$hour:$minute'; // HH:MM 형식의 문자열 반환
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formatTime(startTime), // 시작 시간 표시
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1976D2), // 파란색 텍스트 색상
            fontSize: 16.0,
          ),
        ),
        Text(
          formatTime(endTime), // 종료 시간 표시
          style: const TextStyle(
            fontSize: 10.0,
            color: Colors.grey, // 회색 텍스트 색상
          ),
        ),
      ],
    );
  }
}

// 일정 제목 및 메모를 표시하는 위젯
class _Content extends StatelessWidget {
  final String content; // 일정 제목 또는 내용
  final String memo; // 메모 내용

  const _Content({required this.content, required this.memo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content, // 일정 제목 표시
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (memo.isNotEmpty) // 메모가 비어있지 않은 경우에만 표시
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '메모: $memo', // 메모 내용 표시
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.grey[600], // 회색 톤의 메모 텍스트 색상
                ),
              ),
            ),
        ],
      ),
    );
  }
}
