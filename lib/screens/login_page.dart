import 'package:flutter/material.dart';
import 'main_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF9C2C38),
        title: Text('로그인 페이지'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              // 홈 버튼 클릭 시 동작
              print("홈버튼 클릭");
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 화면 가운데 정렬
          children: [
            SizedBox(height: 16),
            Text(
              '강의실 예약 어플 목원대',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF9C2C38)),
            ),
            SizedBox(height: 32),
            TextField(
              controller: idController,
              decoration: InputDecoration(
                labelText: 'ID',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: pwController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'PW',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(
                      date: '2024.04.07 (월)',  // 여기 임시로 넘겨줌
                      room: 'D421',            // 임시 강의실
                      time: '09:00',            // 임시 시간대
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9C2C38),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                '로그인',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
