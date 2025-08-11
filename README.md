# nanoCalendar-Flutter
> Smart Calendar & Schedule Management App <br>



## 🧑‍💻 *****Contributors*****
| 성규현 <br> [@dmp100](https://github.com/dmp100) | 이재욱<br> [@22-JWL](https://github.com/22-JWL) | 한승주 <br> [@eyeofsol](https://github.com/eyeofsol) | 고윤영 <br> [@koyy418](https://github.com/koyy418) |
|:---:|:---:|:---:|:---:|
| <img width="150" src="https://github.com/user-attachments/assets/placeholder-profile"/> | <img width="150" src="https://github.com/user-attachments/assets/placeholder-profile2"/> | <img width="150" src="https://github.com/user-attachments/assets/placeholder-profile3"/> | <img width="150" src="https://github.com/user-attachments/assets/placeholder-profile4"/> |

<br/>


## ✨ *****Features*****
- **사용자 인증**: Firebase Auth를 통한 로그인/회원가입
- **일정 관리**: 캘린더 기반 일정 추가/수정/삭제
- **타임박스**: 시간 단위 일정 관리
- **실시간 동기화**: Firebase Firestore를 통한 실시간 데이터 동기화
- **반응형 UI**: Material Design 기반 직관적인 인터페이스
## 🟨 *****SCREENSHOT*****
| 로그인 | 회원가입 | 홈화면 | 캘린더 | 일정추가 | 타임박스 |
|:---:|:---:|:---:|:---:|:---:|:---:|
| <img width="200" src="https://github.com/user-attachments/assets/placeholder-login"/> | <img width="200" src="https://github.com/user-attachments/assets/placeholder-signup"/> | <img width="200" src="https://github.com/user-attachments/assets/placeholder-home"/> | <img width="200" src="https://github.com/user-attachments/assets/placeholder-calendar"/> | <img width="200" src="https://github.com/user-attachments/assets/placeholder-add"/> | <img width="200" src="https://github.com/user-attachments/assets/placeholder-timebox"/> |

<br/>



<br/>

## 🔧 *****TECH STACKS*****
| **Category** | **TechStack** |
| --- | --- |
| Language | Dart |
| Framework | Flutter |
| Database | Firebase Firestore |
| Authentication | Firebase Auth |
| Calendar | table_calendar, syncfusion_flutter_calendar |
| State Management | Provider/Riverpod |
| UI Components | Material Design |

<br/>

## 📁 *****Foldering*****
```
📂 lib
┣ 📂 screen
┃ ┣ 📂 auth
┃ ┃ ┣ 📂 login_screen.dart
┃ ┃ ┣ 📂 signup_screen.dart
┃ ┃ ┗ 📂 find_passwd.dart
┃ ┣ 📂 calendar
┃ ┃ ┣ 📂 calendar_screen.dart
┃ ┃ ┣ 📂 add_schedule.dart
┃ ┃ ┗ 📂 schedule_screen.dart
┃ ┣ 📂 home
┃ ┃ ┗ 📂 home_screen.dart
┃ ┣ 📂 timebox
┃ ┃ ┗ 📂 Timebox_screen.dart
┃ ┗ 📂 service
┃   ┣ 📂 auth.dart
┃   ┗ 📂 dastabase.dart
┣ 📂 services
┃ ┗ 📂 auth_services.dart
┣ 📂 widgets
┃ ┗ 📂 custom_button.dart
┣ 📂 firebase_options.dart
┗ 📂 main.dart
```




