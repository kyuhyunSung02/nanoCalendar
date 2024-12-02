import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  final DateTime selectedDate;
  final void Function(DateTime, DateTime) onDaySelected;
  final Map<String, String> dateColors; // 날짜와 색상 매핑

  const CalendarScreen({
    required this.selectedDate,
    required this.onDaySelected,
    required this.dateColors,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 예시 캘린더 구현 (날짜별 색상 적용)
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7, // 7일로 나눔 (월~일)
      ),
      itemCount: 30, // 30일 기준
      itemBuilder: (context, index) {
        final date = DateTime(selectedDate.year, selectedDate.month, index + 1);
        final dateKey = date.toIso8601String().substring(0, 10);

        // 해당 날짜의 색상 가져오기
        final color = dateColors[dateKey] != null
            ? Color(int.parse(dateColors[dateKey]!, radix: 16))
            : Colors.grey;

        return GestureDetector(
          onTap: () => onDaySelected(date, date),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2), // 배경 색상
              border: Border.all(color: color), // 테두리 색상
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                "${index + 1}",
                style: TextStyle(color: color),
              ),
            ),
          ),
        );
      },
    );
  }
}
