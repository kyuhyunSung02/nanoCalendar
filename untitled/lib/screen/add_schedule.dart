// screens/add_schedule.dart
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import 'home_screen.dart';

class AddSchedule extends StatelessWidget {
  final DateTime selectedDate; // 선택된 날짜를 받는 필드

  const AddSchedule({Key? key, required this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("일정 추가")),
      body: RoutineSettingsScreen(selectedDate: selectedDate),
    );
  }
}

class RoutineSettingsScreen extends StatefulWidget {
  final DateTime selectedDate; // 선택된 날짜를 받는 필드

  const RoutineSettingsScreen({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _RoutineSettingsScreenState createState() => _RoutineSettingsScreenState();
}

class _RoutineSettingsScreenState extends State<RoutineSettingsScreen> {
  late DateTime selectedDate; // 날짜 필드
  bool isDailyRoutineEnabled = true;
  bool isAlarmEnabled = true;
  TimeOfDay morningTime = TimeOfDay(hour: 8, minute: 30);
  TimeOfDay afternoonTime = TimeOfDay(hour: 14, minute: 30);
  String memo = '';
  String scheduleTitle = '';
  Color? selectedColor;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate; // 초기화
  }

  // 시간 선택 함수 (오전/오후 시간 선택)
  Future<void> _selectTime(BuildContext context, bool isMorning) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isMorning ? morningTime : afternoonTime,
    );
    if (picked != null) {
      setState(() {
        if (isMorning) {
          morningTime = picked;
        } else {
          afternoonTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
      FocusScope.of(context).unfocus(); // 빈 공간을 터치하면 키보드를 숨김
    },
    child: SingleChildScrollView( // 스크롤 가능하게 만듦
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

            // 제목 입력 필드 (밑줄만 표시)
            TextField(
              decoration: InputDecoration(
                hintText: '제목 입력',
                border: UnderlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  scheduleTitle = value;
                });
              },
            ),
            SizedBox(height: 24),


            // 하루종일 설정 스위치 (시계 아이콘 추가)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row( // 아이콘과 텍스트를 함께 배치
                  children: [
                    Icon(Icons.timer), // 시계 아이콘 추가
                    SizedBox(width: 8), // 아이콘과 텍스트 사이 간격
                    Text('하루종일', style: TextStyle(fontSize: 18)),
                  ],
                ),
                Switch(
                  value: isDailyRoutineEnabled,
                  onChanged: (value) {
                    setState(() {
                      isDailyRoutineEnabled = value;
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 24),

            // 시간 설정 섹션 (중앙에 텍스트와 버튼)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center, // 콘텐츠를 가로로 중앙 정렬
              children: [
                // '시간 설정' 텍스트 추가
                Text('시간 설정', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10), // 텍스트와 버튼 사이에 여백 추가

                // 시간 설정 버튼을 위한 행(Row)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 버튼을 균등하게 배치
                  children: [
                    Column(
                      children: [
                        Text('시작', style: TextStyle(fontSize: 16)), // '시작' 텍스트 추가
                        ElevatedButton(
                          onPressed: () => _selectTime(context, true), // 오전 시간 선택
                          style: ElevatedButton.styleFrom(
                            padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16), // 버튼 크기 조정
                          ),
                          child:
                          Text('${morningTime.format(context)}', style: TextStyle(fontSize: 16)), // 텍스트 크기 증가
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('종료', style: TextStyle(fontSize: 16)), // '종료' 텍스트 추가
                        ElevatedButton(
                          onPressed: () => _selectTime(context, false), // 오후 시간 선택
                          style: ElevatedButton.styleFrom(
                            padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16), // 버튼 크기 조정
                          ),
                          child:
                          Text('${afternoonTime.format(context)}', style: TextStyle(fontSize: 16)), // 텍스트 크기 증가
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 24),

            // 알람 설정 스위치 (전구 아이콘 추가)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row( // 아이콘과 텍스트를 함께 배치
                  children: [
                    Icon(Icons.lightbulb), // 전구 아이콘 추가
                    SizedBox(width: 8), // 아이콘과 텍스트 사이 간격
                    Text('알람 설정', style: TextStyle(fontSize: 18)),
                  ],
                ),
                Switch(
                  value: isAlarmEnabled ?? false,
                  onChanged: (value) {
                    setState(() {
                      isAlarmEnabled = value;
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 24),

            // 메모 입력 필드 (직사각형 모양)
            TextField(
              decoration: InputDecoration(
                labelText: '메모',
                icon: Icon(Icons.note),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // 모서리 둥글게
                ),
              ),
              maxLines: 8, // 메모 박스 칸수
              onChanged: (value) {
                setState(() {
                  memo = value;
                });
              },
            ),

            SizedBox(height: 140),



            // 색상 옵션 - 너비에 맞게 확장됨 (moved here)
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ColorOption(
              color: Colors.red,
              isSelected: selectedColor == Colors.red,
              onTap: () {
                setState(() {
                  selectedColor = Colors.red;
                });
              },
            ),
          ),
          Expanded(
            child: ColorOption(
              color: Colors.orange,
              isSelected: selectedColor == Colors.orange,
              onTap: () {
                setState(() {
                  selectedColor = Colors.orange;
                });
              },
            ),
          ),
          Expanded(
            child: ColorOption(
              color: Colors.yellow,
              isSelected: selectedColor == Colors.yellow,
              onTap: () {
                setState(() {
                  selectedColor = Colors.yellow;
                });
              },
            ),
          ),
          Expanded(
            child: ColorOption(
              color: Colors.green,
              isSelected: selectedColor == Colors.green,
              onTap: () {
                setState(() {
                  selectedColor = Colors.green;
                });
              },
            ),
          ),
          Expanded(
            child: ColorOption(
              color: Colors.blue,
              isSelected: selectedColor == Colors.blue,
              onTap: () {
                setState(() {
                  selectedColor = Colors.blue;
                });
              },
            ),
          ),
        ],
      ),

            SizedBox(height: 20),

            // 하단 버튼들 (취소 및 확인)
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: '취소',
                    onPressed: () {
                      // HomeScreen으로 이동
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                            (route) => false, // 이전 화면 스택 제거
                      );
                    },
                    color: Colors.grey[400]!,
                    textColor: Colors.white,
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    text: '확인',
                    onPressed: () {
                      if (scheduleTitle.isEmpty) // 제목이 비어 있으면 추가하지 않음
                      {
                        // 제목이 비어 있으면 알림 메시지 표시
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('일정 제목을 입력해주세요.')),
                        );
                      } else {
                        final newSchedule = {
                          'date': DateTime.utc(
                              selectedDate.year, selectedDate.month,
                              selectedDate.day),
                          'startTime': morningTime, // 시작 시간
                          'endTime': afternoonTime, // 종료 시간
                          'content': scheduleTitle, // 일정 제목
                          'memo': memo, // 메모 내용
                          'isAlarmEnabled': isAlarmEnabled, // 알람 여부
                          'color': selectedColor ?? Colors.blue, // 선택한 색상
                        };
                        print(newSchedule);
                        Navigator.pop(context, newSchedule); // 데이터를 HomeScreen으로 반환
                      }
                    },
                    color: Colors.blue[400]!,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }
}

// 색상 옵션 위젯 정의
class ColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected; // 선택 여부
  final VoidCallback onTap; // 터치 이벤트 콜백

  ColorOption({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 터치 시 콜백 실행
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: Colors.black, width: 2) // 선택된 경우 테두리 추가
              : null,
        ),
      ),
    );
  }
}
