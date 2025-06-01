import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/reservation_page.dart';

class RoomSelectionPage extends StatelessWidget {
  final List<String> rooms = List.generate(10, (i) => 'D42${i + 1}');
  final List<String> times = [
    '09:00', '10:00', '11:00', '12:00',
    '13:00', '14:00', '15:00', '16:00',
    '17:00', '18:00'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '강의실 선택',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF9C2C38),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, roomIndex) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rooms[roomIndex],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),

                    // 시간 버튼 수평 슬라이드로 변경
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: times.map((time) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReservationPage(
                                      room: rooms[roomIndex],
                                      time: time,
                                      isDetailView: false, // 새 예약 모드
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF9C2C38),
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              child: Text(
                                time,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}