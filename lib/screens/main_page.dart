import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/room_selection_page.dart';
import 'package:flutter_application_1/screens/reservation_list_page.dart';
import 'package:flutter_application_1/main.dart'; // main.dart에서 예약 내역 접근을 위해 임포트
import 'package:flutter_application_1/models/reservation.dart'; // Reservation 모델 임포트
import 'package:intl/intl.dart'; // DateFormat을 위해 추가

class MainPage extends StatefulWidget {
  MainPage();

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 예약 정보는 이제 allReservations 리스트에서 가져옵니다.
  // MainPage에서는 가장 최근의 예약만 표시합니다.
  Reservation? latestReservation;

  bool darkMode = false;
  bool notifications = true;

  @override
  void initState() {
    super.initState();
    _loadLatestReservation(); // 초기화 시 가장 최근 예약 로드
  }

  // 가장 최근 예약 정보를 불러오는 함수
  void _loadLatestReservation() {
    if (allReservations.isNotEmpty) {
      setState(() {
        latestReservation = allReservations.last; // 가장 마지막에 추가된 예약이 최신 예약
      });
    } else {
      setState(() {
        latestReservation = null;
      });
    }
  }

  // 예약 취소 함수 (예약 내역에서도 삭제)
  void cancelLatestReservation() {
    if (latestReservation != null) {
      removeReservation(latestReservation!); // main.dart의 removeReservation 함수 호출
      setState(() {
        latestReservation = null; // UI에서 제거
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('예약이 취소되었습니다.')),
      );
    }
  }

  // 예약 시간 도달 여부 확인
  bool _isReservationTimeReached() {
    if (latestReservation == null) return false;

    try {
      final reservationDate = DateFormat('yyyy.MM.dd (E)', 'ko_KR').parse(latestReservation!.date);
      final reservationTimeParts = latestReservation!.time.split(':');
      final reservationHour = int.parse(reservationTimeParts[0]);
      final reservationMinute = int.parse(reservationTimeParts[1]);

      final reservationDateTime = DateTime(
        reservationDate.year,
        reservationDate.month,
        reservationDate.day,
        reservationHour,
        reservationMinute,
      );

      final now = DateTime.now();
      final currentDateTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);

      // 현재 시간이 예약 시간과 같거나 예약 시간 이후인지 확인
      return currentDateTime.isAtSameMomentAs(reservationDateTime) || currentDateTime.isAfter(reservationDateTime);

    } catch (e) {
      print("날짜/시간 파싱 오류: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayText = (latestReservation != null)
        ? "${latestReservation!.date} | ${latestReservation!.room} | ${latestReservation!.time} 예약중"
        : "예약 정보가 없습니다";

    bool isReservationTimeActive = _isReservationTimeReached();
    // 강의실 예약 버튼 활성화 여부를 결정하는 변수
    // latestReservation이 null일 때만 활성화 (현재 예약이 없을 때)
    bool canMakeNewReservation = latestReservation == null;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF9C2C38),
        title: Text(
          '메인 페이지',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF9C2C38),
                ),
                child: Text(
                  '메뉴',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              ListTile(
                title: Text('설정',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SwitchListTile(
                title: Text('다크 모드'),
                value: darkMode,
                onChanged: (value) {
                  setState(() {
                    darkMode = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('알림 받기'),
                value: notifications,
                onChanged: (value) {
                  setState(() {
                    notifications = value;
                  });
                },
              ),
              ListTile(
                title: Text('앱 버전'),
                subtitle: Text('v1.0.0'),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.list),
                title: Text('예약 목록'),
                onTap: () async {
                  Navigator.pop(context); // 드로어 닫기
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReservationListPage()),
                  );
                  _loadLatestReservation(); // 예약 목록 페이지에서 돌아온 후 최신 예약 정보 다시 로드
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              displayText,
              style: TextStyle(fontSize: 18, color: Color(0xFF9C2C38)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            if (latestReservation != null && !isReservationTimeActive) // 예약 시간이 도달하면 '예약 취소' 버튼 사라짐
              ElevatedButton(
                onPressed: cancelLatestReservation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  minimumSize: Size(double.infinity, 40),
                ),
                child: Text(
                  '예약 취소',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  // latestReservation이 null일 때만 활성화됩니다.
                  onPressed: canMakeNewReservation ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RoomSelectionPage()),
                    );
                  } : null, // 이미 예약 중이면 비활성화
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canMakeNewReservation ? Color(0xFF9C2C38) : Colors.grey, // 비활성화 시 색상 변경
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    '강의실 예약',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: QR 코드 기능 구현
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF9C2C38),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'QR 코드',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: isReservationTimeActive && latestReservation != null ? () {
                    setState(() {
                      latestReservation = null; // UI에서만 해당 예약 정보를 지웁니다.
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('퇴실 처리되었습니다.')),
                    );
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF9C2C38),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    '퇴실하기',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}