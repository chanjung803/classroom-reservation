import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart'; // main.dart의 전역 함수와 변수 사용
import 'package:flutter_application_1/screens/main_page.dart';
import 'package:flutter_application_1/models/reservation.dart'; // Reservation 모델 임포트
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ReservationPage extends StatefulWidget {
  final String room;
  final String time;
  // 예약 상세 보기 시 사용할 선택적 매개변수들
  final String? name;
  final String? studentId;
  final String? major;
  final String? date;
  final bool isDetailView; // 이 페이지가 예약 상세를 보여주는 용도인지, 새 예약을 위한 용도인지 구분

  ReservationPage({
    required this.room,
    required this.time,
    this.name,
    this.studentId,
    this.major,
    this.date,
    this.isDetailView = false, // 기본값은 새 예약
  });

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController(); // 학번 컨트롤러
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

    // 상세 보기 모드일 경우 기존 데이터로 채움
    if (widget.isDetailView) {
      nameController.text = widget.name ?? '';
      studentIdController.text = widget.studentId ?? '';
      majorController.text = widget.major ?? '';
    }
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
        studentIdController.text.isEmpty || // 학번 검사
        majorController.text.isEmpty) {
      showToast("모든 항목을 입력해주세요.");
      return;
    }

    // 새로운 Reservation 객체 생성
    final newReservation = Reservation(
      date: currentDate,
      room: widget.room,
      time: widget.time,
      name: nameController.text,
      studentId: studentIdController.text, // 학번 저장
      major: majorController.text,
    );

    addReservation(newReservation); // main.dart의 addReservation 함수 호출

    showToast("예약이 완료되었습니다.");

    // 필드 초기화 (필요하다면)
    nameController.clear();
    studentIdController.clear();
    majorController.clear();

    // MainPage로 이동 (이전 페이지 스택 제거)
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(), // MainPage는 이제 초기값을 받지 않음
      ),
      (Route<dynamic> route) => false, // 모든 이전 라우트 제거
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isDetailView ? '예약 상세' : '예약', // 타이틀 변경
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF9C2C38),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              '${widget.room} / ${widget.time} ${widget.isDetailView ? '(예약 상세)' : '예약'}', // 상세 보기 표시
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
              readOnly: widget.isDetailView, // 상세 보기 모드에서는 읽기 전용
            ),
            SizedBox(height: 16),
            TextField(
              controller: studentIdController, // 학번 필드
              decoration: InputDecoration(
                labelText: '학번',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              readOnly: widget.isDetailView, // 상세 보기 모드에서는 읽기 전용
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
              readOnly: widget.isDetailView, // 상세 보기 모드에서는 읽기 전용
            ),
            SizedBox(height: 24),
            Text(
              '예약 안내문: 예약 후 5분 이내 미입실 시 자동취소됩니다.',
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
            SizedBox(height: 24),
            if (!widget.isDetailView) // 새 예약 모드일 때만 '예약 확정' 버튼 표시
              ElevatedButton(
                onPressed: handleReservation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9C2C38),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  '예약 확정',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}