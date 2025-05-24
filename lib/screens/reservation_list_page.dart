import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/screens/room_selection_page.dart';
import 'reservation_page.dart';

class ReservationListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('예약 목록'),
        backgroundColor: Color(0xFF9C2C38),
      ),
      body: reservationHistory.isEmpty
          ? Center(
              child: Text(
                '예약 내역이 없습니다.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: reservationHistory.length,
              itemBuilder: (context, index) {
                final item = reservationHistory[index];
                return ListTile(
                  title: Text('${item['date']} | ${item['room']} | ${item['time']}'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReservationPage(
                          room: item['room']!,
                          time: item['time']!,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
