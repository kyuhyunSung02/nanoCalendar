// screens/findpasswd.dart
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FindPasswordScreen(),
      ),
    );
  }
}

class FindPasswordScreen extends StatefulWidget {
  @override
  _FindPasswordScreenState createState() => _FindPasswordScreenState();
}

class _FindPasswordScreenState extends State<FindPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  //final FirebaseAuth _auth = FirebaseAuth.instance;

  Color _borderColor = Colors.grey;
  String _errorMessage = '';
  bool _isEmailSent = false;

  // 이메일 유효성 검사 함수
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // 비밀번호 재설정 이메일 전송 함수
  void _sendPasswordResetEmail() async {
    String email = _emailController.text.trim();

    // 이메일 유효성 검사
    /*if (!isValidEmail(email)) {
      setState(() {
        _borderColor = Colors.red;
        _errorMessage = '올바른 이메일 주소를 입력하세요.';
      });
      _hideErrorMessageAfterDelay();
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      setState(() {
        _borderColor = Colors.grey;
        _errorMessage = '';
        _isEmailSent = true;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _borderColor = Colors.red;
          _errorMessage = '회원 정보가 없습니다.';
        });
      } else {
        setState(() {
          _borderColor = Colors.red;
          _errorMessage = '회원 정보가 없습니다.';
        });
      }
      _hideErrorMessageAfterDelay();
    }*/
  }

  // 에러 메시지를 일정 시간 후에 숨김
  void _hideErrorMessageAfterDelay() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _errorMessage = '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Find Password',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isEmailSent) ...[
              Text(
                'Enter your email here to reset your password',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // 이메일 입력 필드 (이메일 전송 전)
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'example@gmail.com',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: _borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: _borderColor, width: 2.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),

              // Send E-mail 버튼 (이메일 전송 전)
              CustomButton(
                text: 'Send E-mail',
                onPressed: _sendPasswordResetEmail,
                color: Colors.blue, // 버튼 배경색
                textColor: Colors.white, // 텍스트 색상
              ),
            ] else ...[
              // 이메일 전송 후 표시할 텍스트 (성공 시)
              Text(
                '비밀번호 재설정 이메일이 전송되었습니다.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
            ],

            SizedBox(height: 10),

            if (!_isEmailSent) ...[
              // Back to Login 버튼 (이메일 입력 화면일 때만 표시)
              CustomButton(
                text: 'Back to Login',
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.blue, // 버튼 배경색
                textColor: Colors.white, // 텍스트 색상
              ),
            ],

            SizedBox(height: 20),

            if (_errorMessage.isNotEmpty)
              Container(
                padding:
                EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                width:
                MediaQuery.of(context).size.width * 0.8,
                decoration:
                BoxDecoration(color:
                Colors.blue, borderRadius:
                BorderRadius.circular(20),
                    border:
                    Border.all(color:
                    Colors.blue, width:
                    2)),
                child:
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children:[
                    Icon(Icons.close,color:
                    Colors.red),
                    SizedBox(width:
                    8),
                    Text(_errorMessage, style:
                    TextStyle(color:
                    Colors.white)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}