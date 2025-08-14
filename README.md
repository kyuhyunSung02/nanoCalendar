# nanoCalendar-Flutter
> Smart Calendar & Schedule Management App <br>



## 🧑‍💻 *****Contributors*****
| 성규현 <br> [@dmp100](https://github.com/dmp100) | 이재욱<br> [@22-JWL](https://github.com/22-JWL) | 한승주 <br> [@eyeofsol](https://github.com/eyeofsol) | 고윤영 <br> [@koyy418](https://github.com/koyy418) |
|:---:|:---:|:---:|:---:|
| <img width="150" alt="성규현" src="https://github.com/user-attachments/assets/6be11fa5-af14-41e3-aa71-db90749dcf2e" /> | <img width="150" alt="이재욱" src="https://github.com/user-attachments/assets/89929f1d-9874-4557-934e-364191a9cd8a" /> | <img width="150" alt="한승주" src="https://github.com/user-attachments/assets/461e239f-161c-429b-9a16-8a0ad0ec69ae" /> | <img width="150" alt="고윤영" src="https://github.com/user-attachments/assets/c9c4fdf3-8c5e-4b07-bc48-a6ef2d7a6502" /> |


<br/>


## ✨ *****Features*****
- **사용자 인증**: Firebase Auth를 통한 로그인/회원가입
- **일정 관리**: 캘린더 기반 일정 추가/수정/삭제
- **타임박스**: 시간 단위 일정 관리
- **실시간 동기화**: Firebase Firestore를 통한 실시간 데이터 동기화
- **반응형 UI**: Material Design 기반 직관적인 인터페이스
## 🟨 *****PlayDemo*****
[![Watch the video](https://img.youtube.com/vi/k6SYZ354swc/hqdefault.jpg)](https://www.youtube.com/watch?v=k6SYZ354swc)




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




