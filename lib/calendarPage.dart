import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'utils.dart';

// import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
// final FlutterLocalization localization = FlutterLocalization.instance;

class calendarPage extends StatefulWidget {
  const calendarPage({super.key});

  @override
  State<calendarPage> createState() => _calendarPageState();
}

class _calendarPageState extends State<calendarPage> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 40, 39, 81),
        iconTheme: IconThemeData(color: Colors.white, size: 52),
        title: Text(
          'Takvim',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 40, 39, 81),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 100),
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                      blurRadius: 4,
                      blurStyle: BlurStyle.inner),
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 100),
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                      blurRadius: 4,
                      blurStyle: BlurStyle.outer)
                ],
                color: Color.fromARGB(255, 21, 20, 63),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TableCalendar<Event>(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat,
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerStyle: HeaderStyle(
                  formatButtonShowsNext: false,
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                  titleTextStyle: TextStyle(color: Colors.white),
                  formatButtonDecoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(45),
                  ),
                  formatButtonTextStyle: TextStyle(color: Colors.white),
                ),
                daysOfWeekHeight: 50,
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.white),
                  weekendStyle: TextStyle(color: Colors.white),
                ),
                calendarStyle: CalendarStyle(
                  markerDecoration: BoxDecoration(
                      color: Color.fromRGBO(78, 116, 184, 1),
                      shape: BoxShape.circle),
                  weekendTextStyle: TextStyle(color: Colors.red[300]),
                  outsideTextStyle: TextStyle(color: Colors.white38),
                  defaultTextStyle: TextStyle(color: Colors.white),
                  defaultDecoration: BoxDecoration(
                    color: Color.fromRGBO(46, 68, 108, 100),
                    shape: BoxShape.circle,
                  ),
                  weekendDecoration: BoxDecoration(
                    color: Color.fromRGBO(24, 35, 56, 100),
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                      color: Colors.red[300], shape: BoxShape.circle),
                  selectedDecoration: BoxDecoration(
                      color: Color.fromRGBO(40, 6, 152, 100),
                      shape: BoxShape.circle),
                  tableBorder:
                      TableBorder(borderRadius: BorderRadius.circular(50)),
                  outsideDaysVisible: true,
                ),
                onDaySelected: _onDaySelected,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              left: 12.0,
                              right: 12,
                              top: 4.0,
                            ),
                            decoration: BoxDecoration(
                                border: Border.fromBorderSide(BorderSide(
                                    color: Color.fromRGBO(46, 68, 108, 1))),
                                color: Color.fromRGBO(46, 68, 108, 1),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(45),
                                    topRight: Radius.circular(45))),
                            child: ListTile(
                            shape: RoundedRectangleBorder(side: BorderSide()),
                              visualDensity: VisualDensity(vertical: -4),
                              subtitle: Text(
                                '' +
                                    _selectedDay!.day.toString() +
                                    ' ' +
                                    ayHesaplama(_selectedDay!) +
                                    ' ' +
                                    _selectedDay!.year.toString() +
                                    '     ',
                                style: TextStyle(color: Colors.white),
                              ),

                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 12.0,
                              right: 12,
                              bottom: 4.0,
                            ),
                            decoration: BoxDecoration(
                                // border: Border.all(),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                                color: Color.fromRGBO(37, 29, 63, 1)),
                            child: ListTile(
                              onTap: () => print('${value[index]}'),
                              title: Text('${value[index]}'),
                              titleTextStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String ayHesaplama(DateTime day){
  String ay = '';
  switch(day.month){
    case 1:
      ay='Ocak';
      break;
    case 2:
      ay='Şubat';
      break;
    case 3:
      ay='Mart';
      break;
    case 4:
      ay='Nisan';
      break;
    case 5:
      ay='Mayıs';
      break;
    case 6:
      ay='Haziran';
      break;
    case 7:
      ay='Temmuz';
      break;
    case 8:
      ay='Ağustos';
      break;
    case 9:
      ay='Eylül';
      break;
    case 10:
      ay='Ekim';
      break;
    case 11:
      ay='Kasım';
      break;
    case 12:
      ay='Aralık';
      break;
  }
  return ay;
}