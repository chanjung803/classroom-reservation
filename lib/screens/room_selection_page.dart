import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/reservation_page.dart';
import 'package:intl/intl.dart';

class RoomSelectionPage extends StatefulWidget {
  const RoomSelectionPage({Key? key}) : super(key: key);

  @override
  State<RoomSelectionPage> createState() => _RoomSelectionPageState();
}

class _RoomSelectionPageState extends State<RoomSelectionPage> {
  final List<String> rooms = List.generate(10, (i) => 'D42${i + 1}');
  final List<String> times = [
    '09:00', '10:00', '11:00', '12:00',
    '13:00', '14:00', '15:00', '16:00',
    '17:00', '18:00'
  ];

  DateTime _selectedDate = DateTime.now(); // 선택된 날짜 (기본값: 오늘)

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 6)),
      helpText: '예약 날짜 선택',
      cancelText: '취소',
      confirmText: '선택',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF9C2C38),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF9C2C38),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 주어진 시간 문자열이 현재 시간보다 지났는지 확인하는 헬퍼 함수
  // 수정된 로직: 해당 시간대 '시작 시간'을 기준으로 판단합니다.
  bool _isTimePast(String time) {
    final now = DateTime.now();
    // 현재 시간은 년, 월, 일, 시, 분까지 고려합니다.
    final currentTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);

    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    // final minute = int.parse(timeParts[1]); // 이 부분은 이제 사용하지 않습니다.

    // 선택된 날짜와 비교하려는 시간의 '시작' 시간 (분은 00으로 설정)
    final targetStartOfHour = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      hour,
      0, // 해당 시간대의 시작 분을 기준으로 비교
    );

    // 선택된 날짜가 오늘인 경우
    if (_selectedDate.year == now.year && _selectedDate.month == now.month && _selectedDate.day == now.day) {
      // 현재 시간이 해당 시간대의 '시작' 시간 이후이거나 같으면, 즉 이미 시간대가 시작했으면
      // 이 로직은 `targetStartOfHour.isBefore(currentTime)`로 바뀌어야 합니다.
      // 13:00 이 13:59까지 활성화되려면, 14:00 (다음 시간대 시작) 부터 비활성화 되어야 합니다.
      // 따라서, 현재 시간이 해당 시간대의 다음 시간대 시작 시간보다 같거나 클 경우 비활성화
      final nextHourDateTime = targetStartOfHour.add(const Duration(hours: 1));
      return currentTime.isAtSameMomentAs(nextHourDateTime) || currentTime.isAfter(nextHourDateTime);
    }
    // 선택된 날짜가 오늘보다 이전인 경우 모든 시간은 지났다고 판단하여 비활성화
    else if (_selectedDate.isBefore(DateTime(now.year, now.month, now.day))) {
      return true;
    }
    // 그 외의 경우 (미래 날짜) 활성화
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '강의실 선택',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF9C2C38),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '선택된 날짜: ${DateFormat('yyyy년 MM월 dd일 (E)', 'ko_KR').format(_selectedDate)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C2C38),
                  ),
                  child: const Text(
                    '날짜 선택',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
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
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: times.map((time) {
                                // 현재 시간보다 지났는지 확인
                                final bool isTimeSlotPast = _isTimePast(time);

                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ElevatedButton(
                                    // isTimeSlotPast가 true이면 onPressed를 null로 설정하여 버튼 비활성화
                                    onPressed: isTimeSlotPast ? null : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReservationPage(
                                            room: rooms[roomIndex],
                                            time: time,
                                            selectedDate: _selectedDate,
                                            isDetailView: false,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isTimeSlotPast ? Colors.grey : const Color(0xFF9C2C38), // 비활성화 시 색상 변경
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    ),
                                    child: Text(
                                      time,
                                      style: TextStyle(color: isTimeSlotPast ? Colors.black54 : Colors.white), // 비활성화 시 텍스트 색상 변경
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
          ),
        ],
      ),
    );
  }
}