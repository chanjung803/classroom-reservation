import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/screens/room_selection_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'main_page.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ReservationPage extends StatefulWidget {
  final String room;
  final String time;

  ReservationPage({required this.room, required this.time});

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  late String currentDate;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR', null).then((_) {
      DateTime now = DateTime.now();
      setState(() {
        currentDate = DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(now);
      });
    });
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void handleReservation() {
    if (nameController.text.isEmpty ||
        numberController.text.isEmpty ||
        majorController.text.isEmpty) {
      showToast("모든 항목을 입력해주세요.");
      return;
    }

    showToast("예약이 완료되었습니다.");

    // 필드 초기화 후 화면 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(
          date: currentDate,
          room: widget.room,
          time: widget.time,
        ),
      ),
    );

    nameController.clear();
    numberController.clear();
    majorController.clear();

    String formattedDate = DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(DateTime.now());

    reservationHistory.add({
      'room': widget.room,
      'time': widget.time,
      'date': formattedDate,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('예약'),
        backgroundColor: Color(0xFF9C2C38),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              '${widget.room} / ${widget.time} 예약',
              style: TextStyle(fontSize: 22, color: Color(0xFF9C2C38)),
            ),
            SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: '이름',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: numberController,
              decoration: InputDecoration(
                labelText: '학번',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: majorController,
              decoration: InputDecoration(
                labelText: '학과',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 24),
            Text(
              '예약 안내문: 예약 후 5분 이내 미입실 시 자동취소됩니다.',
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: handleReservation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9C2C38),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                '예약 확정',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
