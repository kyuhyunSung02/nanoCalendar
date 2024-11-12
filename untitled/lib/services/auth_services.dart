// services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // FirebaseAuth 인스턴스 생성
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 로그인 메서드: 이메일과 비밀번호를 사용하여 로그인
  Future<User?> signIn(String email, String password) async {
    try {
      // 이메일과 비밀번호로 Firebase 인증
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user; // 로그인 성공 시 사용자 객체 반환
    } catch (e) {
      print("Error signing in: $e"); // 오류 메시지 출력
      return null; // 로그인 실패 시 null 반환
    }
  }

  // 로그아웃 메서드
  Future<void> signOut() async {
    await _auth.signOut(); // Firebase 로그아웃
  }

  // 현재 로그인된 사용자 가져오기
  User? get currentUser => _auth.currentUser; // 현재 사용자 객체 반환
}
