# nanoCalendar-Flutter
> 효율적인 일정 관리와 시간 활용을 위한 스마트 캘린더 앱

## 📋 **프로젝트 배경**

현대인들은 바쁜 일상 속에서 체계적인 시간 관리의 필요성을 절실히 느끼고 있습니다. **nanoCalendar**는 이러한 요구에 부응하여 개발된 종합적인 일정 관리 솔루션입니다.

### 개발 목적
- **효율적인 시간 관리**: 개인 및 팀 단위의 일정을 체계적으로 관리하여 생산성 향상
- **크로스 플랫폼 지원**: Flutter를 활용하여 iOS와 Android 모두에서 통합된 사용자 경험 제공
- **실시간 동기화**: Firebase 백엔드 서비스로 다양한 기기 간 실시간 데이터 동기화
- **직관적인 UI/UX**: 사용자 친화적인 인터페이스로 누구나 쉽게 사용할 수 있는 환경 구축

## 🧑‍💻 **Contributors**
| 성규현 <br> [@dmp100](https://github.com/dmp100) | 이재욱<br> [@22-JWL](https://github.com/22-JWL) | 한승주 <br> [@eyeofsol](https://github.com/eyeofsol) | 고윤영 <br> [@koyy418](https://github.com/koyy418) |
|:---:|:---:|:---:|:---:|
| <img width="150" alt="성규현" src="https://github.com/user-attachments/assets/6be11fa5-af14-41e3-aa71-db90749dcf2e" /> | <img width="150" alt="이재욱" src="https://github.com/user-attachments/assets/89929f1d-9874-4557-934e-364191a9cd8a" /> | <img width="150" alt="한승주" src="https://github.com/user-attachments/assets/461e239f-161c-429b-9a16-8a0ad0ec69ae" /> | <img width="150" alt="고윤영" src="https://github.com/user-attachments/assets/c9c4fdf3-8c5e-4b07-bc48-a6ef2d7a6502" /> |

## ✨ **주요 기능**

### 🔐 **사용자 인증 시스템**
- **Firebase Authentication** 기반 안전한 로그인/회원가입
- 이메일 기반 계정 생성 및 비밀번호 찾기 기능
- 사용자별 독립적인 데이터 관리로 개인정보 보안 강화
- 자동 로그인 상태 유지 및 세션 관리

### 📅 **월간/일간 캘린더 뷰**
- **Table Calendar** 라이브러리를 활용한 직관적인 월간 캘린더
- 날짜별 일정 표시 및 선택 기능
- 한국어 로케일 지원으로 국내 사용자 최적화
- 오늘 날짜 하이라이트 및 선택된 날짜 강조 표시

### ⏰ **타임박스(주간 뷰) 기능**
- **Syncfusion Calendar** 기반 주간 시간표 형태 일정 관리
- 시간대별 세부 일정 배치로 하루 스케줄 최적화
- 색상별 일정 분류로 카테고리 구분 가능
- 시각적 타임라인으로 시간 흐름 파악 용이

### 📝 **일정 생성 및 관리**
- **상세 일정 정보 입력**: 제목, 시작/종료 시간, 메모, 색상 설정
- **하루종일 일정** 설정 기능으로 다양한 일정 유형 지원
- **알람 기능**: 일정 시작 전 사용자 알림 설정
- **색상 코딩**: 5가지 색상(빨강, 주황, 노랑, 초록, 파랑)으로 일정 분류
- **메모 기능**: 각 일정에 대한 상세 정보 기록 가능

### 🔄 **일정 편집 및 삭제**
- **스와이프 기반 조작**: 일정 카드를 좌우로 스와이프하여 편집/삭제
- **실시간 수정**: 기존 일정 정보 불러오기 및 즉시 수정 반영
- **시간 충돌 방지**: 동일한 시간대 일정 중복 생성 방지 로직

### 🔄 **실시간 데이터 동기화**
- **Firebase Firestore** 기반 클라우드 데이터베이스
- 사용자별 독립적인 일정 컬렉션 구조
- **Stream 기반 실시간 업데이트**: 데이터 변경 시 즉시 UI 반영
- 다중 디바이스 간 자동 동기화

### 🎨 **사용자 친화적 인터페이스**
- **Material Design** 기반 일관된 디자인 언어
- **반응형 UI**: 다양한 화면 크기에 최적화
- **직관적인 네비게이션**: 하단 드로어 메뉴로 쉬운 화면 전환
- **색상 통일성**: 브랜드 컬러(#1976D2) 기반 일관된 시각적 경험

## 🟨 **PlayDemo**
[![Watch the video](https://img.youtube.com/vi/k6SYZ354swc/hqdefault.jpg)](https://www.youtube.com/watch?v=k6SYZ354swc)

## 🔧 **기술 스택**
| **Category** | **Technology** | **Purpose** |
|:---:|:---:|:---:|
| **Language** | Dart | Flutter 앱 개발 언어 |
| **Framework** | Flutter | 크로스플랫폼 모바일 앱 프레임워크 |
| **Database** | Firebase Firestore | NoSQL 클라우드 데이터베이스 |
| **Authentication** | Firebase Auth | 사용자 인증 및 권한 관리 |
| **Calendar UI** | table_calendar | 월간 캘린더 뷰 구현 |
| **Timebox UI** | syncfusion_flutter_calendar | 주간 타임박스 뷰 구현 |
| **UI Components** | Material Design | 일관된 디자인 시스템 |
| **Slide Actions** | flutter_slidable | 스와이프 기반 편집/삭제 기능 |
| **Date Handling** | intl | 날짜 형식 지원 및 국제화 |
| **Notifications** | fluttertoast | 사용자 알림 메시지 |

## 📁 **프로젝트 구조**

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



## 🚀 **핵심 아키텍처**

### 데이터베이스 구조

**Firestore 컬렉션 경로:** `users/{userId}/schedules/{scheduleId}`

| 필드명 | 데이터 타입 | 설명 |
|:---:|:---:|:---|
| content | String | 일정 제목 |
| date | String | 날짜 (yyyy-MM-dd 형식) |
| startTime | String | 시작 시간 (HH:mm 형식) |
| endTime | String | 종료 시간 (HH:mm 형식) |
| memo | String | 메모 내용 |
| color | int | 색상 값 |
| isAlarmEnabled | boolean | 알람 설정 여부 |
| isDailyRoutineEnabled | boolean | 하루종일 여부 |

### 상태 관리 패턴
- **setState 기반**: 간단하고 직관적인 로컬 상태 관리
- **Stream 기반**: Firestore 실시간 데이터 수신
- **Future/async-await**: 비동기 데이터 처리

### 보안 및 권한 관리
- **Firebase Security Rules**: 사용자별 데이터 접근 제어
- **사용자 인증 확인**: 모든 데이터 조작 시 로그인 상태 검증
- **데이터 격리**: 사용자별 독립적인 컬렉션 구조

## 📱 **주요 화면 구성**

### 1. 로그인/회원가입 화면
- 이메일 기반 계정 생성 및 로그인
- 입력 유효성 검사 및 오류 메시지 표시
- 비밀번호 찾기 기능 제공

### 2. 메인 홈 화면
- 월간 캘린더와 선택된 날짜의 일정 목록 표시
- 플로팅 액션 버튼을 통한 새 일정 추가
- 드로어 메뉴로 타임박스 화면 이동

### 3. 일정 추가/편집 화면
- 제목, 시간, 메모, 색상 등 상세 정보 입력
- 시간 충돌 검사 및 사용자 알림
- 하루종일 일정 설정 옵션

### 4. 타임박스 화면
- 주간 시간표 형태의 일정 시각화
- 시간대별 일정 배치 및 색상 구분
- 직관적인 시간 흐름 파악

## 🔄 **개발 프로세스 및 협업**

### Git 브랜치 전략
- **main**: 릴리즈 브랜치
- **develop**: 개발 통합 브랜치  
- **개인 브랜치**: dmp100, jwl, HSJ, koyy 등 개발자별 작업 브랜치

### 코드 품질 관리
- **Flutter Lints**: 코드 스타일 및 품질 검사
- **모듈화**: 기능별 클래스 및 서비스 분리
- **에러 핸들링**: try-catch 블록을 통한 예외 처리






