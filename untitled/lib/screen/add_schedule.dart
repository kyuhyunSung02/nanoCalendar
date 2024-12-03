// screens/add_schedule.dart
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import 'home_screen.dart';

// 일정 추가를 위한 화면 클래스 정의
class AddSchedule extends StatefulWidget {
  final DateTime selectedDate; // 사용자가 선택한 날짜
  final Map<String, dynamic>? existingSchedule; // 기존 일정 데이터를 받아오는 필드

  const AddSchedule({Key? key, required this.selectedDate, this.existingSchedule}) : super(key: key);

  @override
  _AddScheduleState createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  // 일정 추가 화면에서 사용될 상태 변수들 정의
  late String scheduleTitle;
  late TimeOfDay morningTime;
  late TimeOfDay afternoonTime;
  late bool isAlarmEnabled;
  late String memo;
  late Color? selectedColor;

  @override
  void initState() {
    super.initState();

    // 기존 일정 데이터가 있을 경우 해당 데이터를 초기화
    if (widget.existingSchedule != null) {
      final schedule = widget.existingSchedule!;
      print("초기화되는 값들: $schedule"); // 디버깅 로그 추가

      scheduleTitle = schedule['content'] ?? ''; // 일정 제목
      morningTime = schedule['startTime'] ?? TimeOfDay(hour: 6, minute: 00); // 시작 시간
      afternoonTime = schedule['endTime'] ?? TimeOfDay(hour: 18, minute: 00); // 종료 시간
      isAlarmEnabled = schedule['isAlarmEnabled'] ?? false; // 알람 설정 여부
      memo = schedule['memo'] ?? ''; // 메모
      selectedColor = schedule['color']; // 색상
    } else {
      // 새로운 일정 추가 시 초기값 설정
      scheduleTitle = '';
      morningTime = TimeOfDay(hour: 8, minute: 30);
      afternoonTime = TimeOfDay(hour: 14, minute: 30);
      isAlarmEnabled = true;
      memo = '';
      selectedColor = Colors.blue;
    }
  }

  // 일정 추가 화면의 UI 정의
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("일정 추가")), // 상단 바에 "일정 추가" 제목 표시
      body: RoutineSettingsScreen(
        selectedDate: widget.selectedDate, // 선택된 날짜 전달
        scheduleTitle: scheduleTitle, // 일정 제목
        morningTime: morningTime, // 시작 시간
        afternoonTime: afternoonTime, // 종료 시간
        isAlarmEnabled: isAlarmEnabled, // 알람 설정 여부
        memo: memo, // 메모
        selectedColor: selectedColor, // 색상
        onScheduleChange: (updatedSchedule) {
          // 일정 변경 시 호출되는 콜백 함수
          setState(() {
            scheduleTitle = updatedSchedule['title'];
            morningTime = updatedSchedule['morningTime'];
            afternoonTime = updatedSchedule['afternoonTime'];
            isAlarmEnabled = updatedSchedule['isAlarmEnabled'];
            memo = updatedSchedule['memo'];
            selectedColor = updatedSchedule['color'];
          });
        },
      ),
    );
  }
}

// 일정 설정 화면 정의
class RoutineSettingsScreen extends StatefulWidget {
  final DateTime selectedDate; // 선택된 날짜
  final String scheduleTitle; // 일정 제목
  final TimeOfDay morningTime; // 시작 시간
  final TimeOfDay afternoonTime; // 종료 시간
  final bool isAlarmEnabled; // 알람 설정 여부
  final String memo; // 메모
  final Color? selectedColor; // 색상
  final Function(Map<String, dynamic>) onScheduleChange; // 변경 사항 전달 콜백 함수

  const RoutineSettingsScreen({
    Key? key,
    required this.selectedDate,
    required this.scheduleTitle,
    required this.morningTime,
    required this.afternoonTime,
    required this.isAlarmEnabled,
    required this.memo,
    required this.selectedColor,
    required this.onScheduleChange,
  }) : super(key: key);

  @override
  _RoutineSettingsScreenState createState() => _RoutineSettingsScreenState();
}

class _RoutineSettingsScreenState extends State<RoutineSettingsScreen> {
  // 일정 설정 화면에서 사용될 상태 변수들 정의
  late DateTime selectedDate;
  late TextEditingController titleController;
  late TextEditingController memoController;
  bool isDailyRoutineEnabled = true; // 하루종일 설정 여부
  bool isAlarmEnabled = true; // 알람 설정 여부
  TimeOfDay morningTime = TimeOfDay(hour: 8, minute: 30); // 시작 시간
  TimeOfDay afternoonTime = TimeOfDay(hour: 14, minute: 30); // 종료 시간
  String memo = ''; // 메모
  String scheduleTitle = ''; // 일정 제목
  Color? selectedColor; // 선택된 색상

  @override
  void initState() {
    super.initState();
    // 초기값을 컨트롤러에 설정
    titleController = TextEditingController(text: widget.scheduleTitle);
    memoController = TextEditingController(text: widget.memo);

    // 전달받은 초기값을 상태에 반영
    selectedDate = widget.selectedDate;
    isDailyRoutineEnabled = true; // 기본값 설정
    isAlarmEnabled = widget.isAlarmEnabled;
    morningTime = widget.morningTime;
    afternoonTime = widget.afternoonTime;
    memo = widget.memo;
    scheduleTitle = widget.scheduleTitle;
    selectedColor = widget.selectedColor;
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

        // 변경된 일정 데이터를 상위로 전달
        widget.onScheduleChange({
          'title': scheduleTitle,
          'morningTime': morningTime,
          'afternoonTime': afternoonTime,
          'isAlarmEnabled': isAlarmEnabled,
          'memo': memo,
          'color': selectedColor,
        });
      });
    }
  }

  // 일정 설정 화면의 UI 정의
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 빈 공간을 터치하면 키보드를 숨김
      },
      child: SingleChildScrollView(
        // 스크롤 가능하게 만듦
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목 입력 필드 (밑줄만 표시)
              TextField(
                controller: titleController, // 컨트롤러 연결
                decoration: InputDecoration(
                  hintText: '제목 입력',
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    scheduleTitle = value;
                  });
                  // 변경 사항 상위에 전달
                  widget.onScheduleChange({
                    'title': value,
                    'morningTime': morningTime,
                    'afternoonTime': afternoonTime,
                    'isAlarmEnabled': isAlarmEnabled,
                    'memo': memoController.text, // 메모 필드도 포함
                    'color': selectedColor,
                  });
                },
              ),
              SizedBox(height: 24),

              // 하루종일 설정 스위치 (시계 아이콘 추가)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    // 아이콘과 텍스트를 함께 배치
                    children: [
                      Icon(Icons.timer), // 시계 아이콘 추가
                      SizedBox(width: 8),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('시간 설정', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),

                  // 시간 설정 버튼을 위한 행(Row)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text('시작', style: TextStyle(fontSize: 16)),
                          ElevatedButton(
                            onPressed: () => _selectTime(context, true),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            ),
                            child: Text('${morningTime.format(context)}', style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('종료', style: TextStyle(fontSize: 16)),
                          ElevatedButton(
                            onPressed: () => _selectTime(context, false),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            ),
                            child: Text('${afternoonTime.format(context)}', style: TextStyle(fontSize: 16)),
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
                  Row(
                    children: [
                      Icon(Icons.lightbulb), // 전구 아이콘 추가
                      SizedBox(width: 8),
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
                controller: memoController,
                decoration: InputDecoration(
                  labelText: '메모',
                  icon: Icon(Icons.note),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 8,
                onChanged: (value) {
                  setState(() {
                    memo = value;
                  });
                  widget.onScheduleChange({
                    'title': scheduleTitle,
                    'morningTime': morningTime,
                    'afternoonTime': afternoonTime,
                    'isAlarmEnabled': isAlarmEnabled,
                    'memo': value,
                    'color': selectedColor,
                  });
                },
              ),

              SizedBox(height: 140),

              // 색상 옵션 - 너비에 맞게 확장됨
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
                        if (scheduleTitle.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('일정 제목을 입력해주세요.')));
                        } else {
                          final updatedSchedule = {
                            'date': DateTime.utc(selectedDate.year, selectedDate.month, selectedDate.day),
                            'startTime': morningTime,
                            'endTime': afternoonTime,
                            'content': scheduleTitle,
                            'memo': memo,
                            'isAlarmEnabled': isAlarmEnabled,
                            'color': selectedColor ?? Colors.blue,
                          };
                          Navigator.pop(context, updatedSchedule); // 수정된 일정 반환
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

  @override
  void dispose() {
    titleController.dispose();
    memoController.dispose();
    super.dispose();
  }
}

// 색상 옵션 위젯 정의
class ColorOption extends StatelessWidget {
  final Color color; // 색상
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
