// widgets/custom_button.dart
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  // 버튼에 사용할 텍스트와 색상, 테두리, 클릭 이벤트를 받기 위한 속성 정의
  final String text;
  final Color color;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text, // 버튼 텍스트
    required this.onPressed, // 클릭 이벤트
    this.color = Colors.blue, // 기본 배경색
    this.textColor = Colors.white, // 기본 텍스트 색상
    this.borderColor, // 테두리 색상 (옵션)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // 버튼이 눌렸을 때 실행할 함수
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // 버튼 배경색
        minimumSize: const Size(double.infinity, 50), // 버튼 크기 설정
        side: borderColor != null // 테두리 색상이 있는 경우 테두리를 설정
            ? BorderSide(color: borderColor!)
            : null,
      ),
      child: Text(
        text, // 버튼에 표시할 텍스트
        style: TextStyle(color: textColor), // 텍스트 색상 설정
      ),
    );
  }
}
