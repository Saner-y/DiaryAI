import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();


  Future<String?> fetchNoteForSelectedDay(DateTime selectedDay) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;
      String formattedDate = "${selectedDay.day.toString()} ${ayHesaplama(selectedDay).toString()} ${selectedDay.year.toString()}";

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('notes')
          .where('timestamp', isEqualTo: formattedDate)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Eğer not varsa, notun detaylarını döndür
        DocumentSnapshot noteDocument = snapshot.docs.first;
        Map<String, dynamic> noteData = noteDocument.data() as Map<String, dynamic>;
        String noteDetails =
            "Tarih: ${noteData['timestamp']}\n"
            "Başlık: ${noteData['title']}\n"
            "İçerik: ${noteData['body']}";
        return noteDetails;
      }
    }
    // Eğer not yoksa, null döndür
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Takvim'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Expanded(
            child: FutureBuilder<String?>(
              future: fetchNoteForSelectedDay(_selectedDay),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
                } else {
                  String? noteDetails = snapshot.data;
                  if (noteDetails == null) {
                    return Center(child: Text('Seçili güne ait not bulunamadı.'));
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(noteDetails),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),

    );
  }
}

String ayHesaplama(day) {
  String ay = '';
  switch (day.month) {
    case 1:
      ay = 'Ocak';
      break;
    case 2:
      ay = 'Şubat';
      break;
    case 3:
      ay = 'Mart';
      break;
    case 4:
      ay = 'Nisan';
      break;
    case 5:
      ay = 'Mayıs';
      break;
    case 6:
      ay = 'Haziran';
      break;
    case 7:
      ay = 'Temmuz';
      break;
    case 8:
      ay = 'Ağustos';
      break;
    case 9:
      ay = 'Eylül';
      break;
    case 10:
      ay = 'Ekim';
      break;
    case 11:
      ay = 'Kasım';
      break;
    case 12:
      ay = 'Aralık';
      break;
  }
  return ay;
}