import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String content;
  final String memo;
  final Color color;
  final bool isAlarmEnabled;
  final VoidCallback onAlarmToggle;

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
          color: const Color(0xFF1976D2),
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
              SizedBox(width: 16.0,),
              _Content(content: content, memo: memo),
              SizedBox(width: 16.0,),
              Center(
                child: Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Center(
                child: IconButton(
                  icon: Icon(
                    isAlarmEnabled ? Icons.notifications : Icons.notifications_none,
                    color: isAlarmEnabled ? Colors.black : Colors.grey,
                  ),
                  onPressed: onAlarmToggle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Time extends StatelessWidget {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const _Time({required this.startTime, required this.endTime, Key? key}) : super(key: key);

  String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formatTime(startTime),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1976D2),
            fontSize: 16.0,
          ),
        ),
        Text(
          formatTime(endTime),
          style: const TextStyle(
            fontSize: 10.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final String content;
  final String memo;

  const _Content({required this.content, required this.memo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          if (memo.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '메모: $memo',
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.grey[600],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
