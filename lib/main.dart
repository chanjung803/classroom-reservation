import 'package:flutter/material.dart';
import 'screens/login_page.dart';

List<Map<String, String>> reservationHistory = [];

void main() => runApp(ClassroomReservationApp());

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
