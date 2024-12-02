// screens/add_schedule.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/custom_button.dart';
import 'home_screen.dart';

class AddSchedule extends StatefulWidget {
  final DateTime selectedDate;
  final Map<String, dynamic>? existingSchedule; // 기존 일정

  const AddSchedule({Key? key, required this.selectedDate, this.existingSchedule}) : super(key: key);

  @override
  _AddScheduleState createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  late String scheduleTitle;
  late TimeOfDay morningTime;
  late TimeOfDay afternoonTime;
  late bool isAlarmEnabled;
  late String memo;
  late Color? selectedColor;

  @override
  void initState() {
    super.initState();

    // 기존 일정이 있다면 데이터를 초기화
    if (widget.existingSchedule != null) {
      final schedule = widget.existingSchedule!;
      print("초기화되는 값들: $schedule"); // 디버깅 로그 추가

      scheduleTitle = schedule['content'] ?? '';
      morningTime = schedule['startTime'] ?? TimeOfDay(hour: 6, minute: 00);
      afternoonTime = schedule['endTime'] ?? TimeOfDay(hour: 18, minute: 00);
      isAlarmEnabled = schedule['isAlarmEnabled'] ?? false;
      memo = schedule['memo'] ?? '';
      selectedColor = schedule['color'];
    } else {
      scheduleTitle = '';
      morningTime = TimeOfDay(hour: 8, minute: 30);
      afternoonTime = TimeOfDay(hour: 14, minute: 30);
      isAlarmEnabled = true;
      memo = '';
      selectedColor = Colors.blue;
    }
  }

  // 기존과 동일한 시간 선택, 알람 설정, 메모 입력 등을 추가하는 로직
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("일정 추가")),
      body: RoutineSettingsScreen(
        selectedDate: widget.selectedDate,
        scheduleTitle: scheduleTitle,
        morningTime: morningTime,
        afternoonTime: afternoonTime,
        isAlarmEnabled: isAlarmEnabled,
        memo: memo,
        selectedColor: selectedColor,
        onScheduleChange: (updatedSchedule) {
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

class RoutineSettingsScreen extends StatefulWidget {
  final DateTime selectedDate; // 선택된 날짜를 받는 필드
  final String scheduleTitle;
  final TimeOfDay morningTime;
  final TimeOfDay afternoonTime;
  final bool isAlarmEnabled;
  final String memo;
  final Color? selectedColor;
  final Function(Map<String, dynamic>) onScheduleChange; // 변경 사항 전달 콜백

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
  late DateTime selectedDate; // 날짜 필드
  late TextEditingController titleController;
  late TextEditingController memoController;
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
    // 초기값을 컨트롤러에 설정
    titleController = TextEditingController(text: widget.scheduleTitle);
    memoController = TextEditingController(text: widget.memo);

    // 전달받은 초기값을 상태에 복원
    selectedDate = widget.selectedDate;
    isDailyRoutineEnabled = true; // 기본값 설정 (전달받는 값이 없다면)
    isAlarmEnabled = widget.isAlarmEnabled; // 전달받은 알람 설정 값
    morningTime = widget.morningTime; // 전달받은 시작 시간
    afternoonTime = widget.afternoonTime; // 전달받은 종료 시간
    memo = widget.memo; // 전달받은 메모
    scheduleTitle = widget.scheduleTitle; // 전달받은 일정 제목
    selectedColor = widget.selectedColor; // 전달받은 색상
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 빈 곳을 터치하면 키보드를 숫기지지만
      },
      child: SingleChildScrollView( // 스크롤 가능하게 만들기
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
                controller: memoController, // 컨트롤러 연결
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
                  // 변경 사항 상위에 전달
                  widget.onScheduleChange({
                    'title': scheduleTitle,
                    'morningTime': morningTime,
                    'afternoonTime': afternoonTime,
                    'isAlarmEnabled': isAlarmEnabled,
                    'memo': value, // 메모 필드
                    'color': selectedColor,
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
                      onPressed: () async {
                        if (scheduleTitle.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('일정 제목을 입력해주세요.')));
                        } else {
                          final updatedSchedule = {
                            'date': DateTime.utc(
                                selectedDate.year, selectedDate.month, selectedDate.day),
                            'startTime': morningTime.format(context),
                            'endTime': afternoonTime.format(context),
                            'content': scheduleTitle,
                            'memo': memo,
                            'isAlarmEnabled': isAlarmEnabled,
                            'color': selectedColor?.value ?? Colors.blue.value,
                          };

                          // Firestore에 데이터 저장
                          await FirestoreService().saveSchedule(updatedSchedule);

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

// FirestoreService 클래스 정의
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 일정 데이터 저장 함수
  Future<void> saveSchedule(Map<String, dynamic> scheduleData) async {
    try {
      await _firestore.collection('schedules').add(scheduleData);
      print("데이터 저장 성공!");
    } catch (e) {
      print("데이터 저장 실패: $e");
    }
  }
}
