// screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:untitled/screen/home_screen.dart';
import '../widgets/custom_button.dart'; // 커스텀 버튼을 사용하기 위해 불러옵니다.

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to Nano Calendar"),
        backgroundColor: const Color(0xFF1976D2), // 앱 바의 배경색을 파란색으로 설정
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0), // 화면 여백을 설정
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 고래 이미지를 화면에 표시합니다.
              Image.asset(
                'assets/whale.png', // 이미지 경로를 여기에 지정하세요
                height: 150, // 이미지 높이를 설정
              ),
              const SizedBox(height: 20), // 위젯 간 간격 설정
              // 사용자 이름 입력 필드
              TextField(
                decoration: InputDecoration(
                  labelText: "Username", // 필드 레이블 텍스트
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), // 둥근 테두리 설정
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // 비밀번호 입력 필드
              TextField(
                obscureText: true, // 입력 시 텍스트를 숨김
                decoration: InputDecoration(
                  labelText: "Password", // 필드 레이블 텍스트
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), // 둥근 테두리 설정
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // 커스텀 로그인 버튼
              CustomButton(
                text: "Login", // 버튼 텍스트
                color: const Color(0xFF1976D2), // 버튼 배경색
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen())
                  );
                },
              ),
              const SizedBox(height: 10),
              // 커스텀 회원가입 버튼
              CustomButton(
                text: "Sign Up", // 버튼 텍스트
                color: Colors.white, // 버튼 배경색
                textColor: Colors.black, // 텍스트 색상
                borderColor: Colors.black, // 테두리 색상
                onPressed: () {
                  // 회원가입 기능 추가
                },
              ),
              const SizedBox(height: 10),
              // 비밀번호 찾기 버튼
              TextButton(
                onPressed: () {
                  // 비밀번호 찾기 기능 추가
                },
                child: const Text("Find Password"),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF1976D2), // 파란색 텍스트
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
