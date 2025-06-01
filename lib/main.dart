import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_application_1/models/reservation.dart';

// 전역 변수로 선언하여 앱 전체에서 접근 가능하도록 합니다.
// SharedPreferences를 사용하여 데이터를 영구적으로 저장하고 로드합니다.
late SharedPreferences _prefs;
List<Reservation> allReservations = []; // 모든 예약 내역을 저장하는 리스트

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _prefs = await SharedPreferences.getInstance();
  await _loadReservations(); // 앱 시작 시 저장된 예약 내역 로드
  runApp(ClassroomReservationApp());
}

// 예약 내역을 SharedPreferences에 저장하는 함수
Future<void> _saveReservations() async {
  final String encodedData = json.encode(allReservations.map((e) => e.toJson()).toList());
  await _prefs.setString('reservations', encodedData);
}

// 예약 내역을 SharedPreferences에서 불러오는 함수
Future<void> _loadReservations() async {
  final String? encodedData = _prefs.getString('reservations');
  if (encodedData != null) {
    final List<dynamic> decodedData = json.decode(encodedData);
    allReservations = decodedData.map((e) => Reservation.fromJson(e)).toList();
  }
}

// 새로운 예약 추가 함수 (외부에서 호출)
void addReservation(Reservation reservation) {
  allReservations.add(reservation);
  _saveReservations(); // 추가 후 저장
}

// 예약 삭제 함수 (외부에서 호출)
void removeReservation(Reservation reservation) {
  allReservations.removeWhere((r) =>
      r.date == reservation.date &&
      r.room == reservation.room &&
      r.time == reservation.time &&
      r.name == reservation.name &&
      r.studentId == reservation.studentId &&
      r.major == reservation.major);
  _saveReservations(); // 삭제 후 저장
}


class ClassroomReservationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '강의실 예약',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      home: LoginPage(), // 시작화면: 로그인
    );
  }
}