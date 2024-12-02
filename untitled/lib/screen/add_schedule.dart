import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore 임포트
import '../widgets/custom_button.dart';
import 'home_screen.dart';

class AddSchedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: RoutineSettingsScreen(),
      ),
    );
  }
}

class RoutineSettingsScreen extends StatefulWidget {
  @override
  _RoutineSettingsScreenState createState() => _RoutineSettingsScreenState();
}

class _RoutineSettingsScreenState extends State<RoutineSettingsScreen> {
  bool isDailyRoutineEnabled = true;
  bool isAlarmEnabled = true;
  TimeOfDay morningTime = TimeOfDay(hour: 8, minute: 30);
  TimeOfDay afternoonTime = TimeOfDay(hour: 14, minute: 30);
  String memo = '';
  String scheduleTitle = '';
  Color? selectedColor;

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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.timer),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('시간 설정',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text('시작', style: TextStyle(fontSize: 16)),
                          ElevatedButton(
                            onPressed: () => _selectTime(context, true),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                            ),
                            child: Text('${morningTime.format(context)}',
                                style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('종료', style: TextStyle(fontSize: 16)),
                          ElevatedButton(
                            onPressed: () => _selectTime(context, false),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                            ),
                            child: Text('${afternoonTime.format(context)}',
                                style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb),
                      SizedBox(width: 8),
                      Text('알람 설정', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  Switch(
                    value: isAlarmEnabled,
                    onChanged: (value) {
                      setState(() {
                        isAlarmEnabled = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 24),
              TextField(
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
                },
              ),
              SizedBox(height: 140),
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
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: '취소',
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()),
                              (route) => false,
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
                        try {
                          await FirebaseFirestore.instance
                              .collection('schedules')
                              .add({
                            'title': scheduleTitle,
                            'isDailyRoutineEnabled': isDailyRoutineEnabled,
                            'morningTime': '${morningTime.format(context)}',
                            'afternoonTime': '${afternoonTime.format(context)}',
                            'isAlarmEnabled': isAlarmEnabled,
                            'memo': memo,
                            'color': selectedColor != null
                                ? selectedColor!.value.toRadixString(16)
                                : null,
                            'createdAt': FieldValue.serverTimestamp(),
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Schedule saved successfully!')),
                          );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                                (route) => false,
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Failed to save schedule: $e')),
                          );
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

class ColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  ColorOption({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: Colors.black, width: 2)
              : null,
        ),
      ),
    );
  }
}
