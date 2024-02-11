import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toast/toast.dart';
import 'utils.dart';
import 'package:diaryai/addNotePage.dart';

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

  Future<void> deleteNote(String noteId, List<String> imageUrls) async {
    // Delete the images from Firebase Storage
    for (String imageUrl in imageUrls) {
      Reference ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
    }

    // Delete the note from Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notes')
        .doc(noteId) // Use the note id to delete the specific note
        .delete();

    // Trigger a rebuild of the widget tree
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> fetchNotesForSelectedDay(
      DateTime selectedDay) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    List<Map<String, dynamic>> notes = [];

    if (currentUser != null) {
      String userId = currentUser.uid;
      String formattedDate =
          "${selectedDay.day.toString()} ${ayHesaplama(selectedDay).toString()} ${selectedDay.year.toString()}";

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('notes')
          .where('timestamp', isEqualTo: formattedDate)
          .get();

      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        notes.add({
          'id': doc.id, // Add the document ID
          'timestamp': data['timestamp'],
          'title': data['title'],
          'body': data['body'],
          'imageUrls': data['imageUrls'],
        });
      });
    }

    return notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 40, 39, 81),
        iconTheme: IconThemeData(color: Colors.white, size: 48),
        title: Text(
          'Takvim',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
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
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
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
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _selectedDay != null
                    ? fetchNotesForSelectedDay(_selectedDay!)
                    : Future.value([]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return NoteWidget(
                          id: snapshot.data![index]['id'],
                          // Pass the id to the NoteWidget
                          title: snapshot.data![index]['title'],
                          body: snapshot.data![index]['body'],
                          timestamp: snapshot.data![index]['timestamp'],
                          imageUrls: List<String>.from(
                              snapshot.data![index]['imageUrls']),
                          onDelete: () => deleteNote(
                              snapshot.data![index]['id'],
                              List<String>.from(snapshot.data![index][
                                  'imageUrls'])), // Pass the deleteNote function to the NoteWidget
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddNotePage(
                    selectedDate:
                        _selectedDay == null ? DateTime.now() : _selectedDay!)),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 21, 20, 63),
      ),
    );
  }
}

class NoteWidget extends StatelessWidget {
  final String id; // Add an id parameter
  final String title;
  final String body;
  final String timestamp;
  final List<String> imageUrls;
  final VoidCallback onDelete;

  NoteWidget(
      {required this.id,
      required this.title,
      required this.body,
      required this.timestamp,
      required this.imageUrls,
      required this.onDelete});

  void editNote(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNotePage(
            id: id, title: title, body: body, imageUrls: imageUrls),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Düzenle'),
                onTap: () {
                  Navigator.pop(context);
                  editNote(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Sil'),
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
            ],
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Color.fromRGBO(46, 68, 108, 100),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Text(
                      timestamp,
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 10,
              color: Color.fromRGBO(37, 20, 63, 100),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(37, 20, 63, 100),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Column(
                  children: [
                    Text(
                      body,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      // to prevent the GridView from scrolling
                      physics: NeverScrollableScrollPhysics(),
                      // to prevent the GridView from scrolling
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Adjust as needed
                        mainAxisSpacing: 8.0, // Ana eksen boyunca boşluk
                        crossAxisSpacing: 8.0, // Çapraz eksen boyunca boşluk
                      ),
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle, // Kare şekli
                            borderRadius:
                                BorderRadius.circular(10), // Yuvarlak köşeler
                          ),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Image.network(imageUrls[index]),
                                ),
                              );
                            },
                            child: Image.network(
                              imageUrls[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditNotePage extends StatefulWidget {
  final String id;
  final String title;
  final String body;
  final List<String> imageUrls;

  EditNotePage(
      {required this.id,
      required this.title,
      required this.body,
      required this.imageUrls});

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  late List<String> _imageUrls;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _bodyController = TextEditingController(text: widget.body);
    _imageUrls = List<String>.from(widget.imageUrls);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> saveNote() async {
    // Update the note in Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notes')
        .doc(widget.id) // Use the note id to update the specific note
        .update({
      'title': _titleController.text,
      'body': _bodyController.text,
      'imageUrls': _imageUrls, // Update the imageUrls
    });

    // Navigate back to the previous page
    Navigator.pop(context);
  }

  Future<void> deleteImage(String imageUrl) async {
    // Delete the image from Firebase Storage
    Reference ref = FirebaseStorage.instance.refFromURL(imageUrl);
    await ref.delete();

    // Remove the image URL from the list
    setState(() {
      _imageUrls.remove(imageUrl);
    });
  }

  Future<void> addImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      try {
        // Create a reference to the location you want to upload to in Firebase Storage
        String uid = FirebaseAuth.instance.currentUser!.uid;
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref = FirebaseStorage.instance.ref('images/$uid/$fileName');

        // Upload the file to Firebase Storage
        await ref.putFile(imageFile);

        // Retrieve the URL of the uploaded image
        String imageUrl = await ref.getDownloadURL();

        // Update _imageUrls list
        setState(() {
          _imageUrls.add(imageUrl);
        });
      } catch (e) {
        print('addImage error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white, size: 48),
        backgroundColor: Color.fromARGB(255, 40, 39, 81),
        title: Text(
          'Düzenleme',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 40, 39, 81),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: ListView(
              children: [Column(
                children: [
                  TextField(
                    controller: _titleController,
                    maxLength: 20,
                    maxLines: 1,
                    cursorRadius: const Radius.circular(50),
                    cursorColor: Colors.white30,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: 'Başlık',
                        hintStyle: TextStyle(color: Colors.white),
                        counterText: '',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                        ),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(37, 20, 63, 1),
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                        ),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(37, 20, 63, 1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                        ),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(37, 20, 63, 1),
                        ),
                      ),
                        fillColor: Color.fromRGBO(37, 20, 63, 1),
                        filled: true,
                    ),
                  ),
                  TextField(
                    controller: _bodyController,
                    cursorRadius: const Radius.circular(50),
                    cursorColor: Colors.white30,
                    minLines: 12,
                    maxLines: 1000,
                    textInputAction: TextInputAction.newline,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(0),
                            bottomLeft: Radius.circular(0),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(37, 20, 63, 1),
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(0),
                            bottomLeft: Radius.circular(0),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(37, 20, 63, 1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(0),
                            bottomLeft: Radius.circular(0),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(37, 20, 63, 1),
                          ),
                        ),
                        hintText: 'Bugün neler yaşadın? Hemen kaydet!',
                        hintStyle: TextStyle(color: Colors.white30),
                        fillColor: Color.fromRGBO(37, 20, 63, 1),
                        filled: true,
                        ),
                  ),
                  Container(height: 200,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(37, 20, 63, 1),
                        border:
                        Border.all(color: const Color.fromRGBO(37, 20, 63, 1))),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _imageUrls.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                                image: DecorationImage(
                                    image: NetworkImage(_imageUrls[index]),
                                    fit: BoxFit.cover)),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    child: Image.network(_imageUrls[index]),
                                  ),
                                );
                              },
                              onLongPress: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Wrap(
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text('Sil'),
                                        onTap: () async {
                                          // Firebase Storage'dan fotoğrafı sil
                                          await deleteImage(_imageUrls[index]);
                                          // ModalBottomSheet'i kapat
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30)),
                        color: const Color.fromRGBO(37, 20, 63, 1),
                        border:
                        Border.all(color: const Color.fromRGBO(37, 20, 63, 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return EmojiPicker(
                                    onEmojiSelected: (category, emoji) {
                                      _bodyController.text += emoji.emoji;
                                    },
                                    onBackspacePressed: () {
                                      _bodyController.text =
                                          _bodyController.text.substring(
                                              0,
                                              _bodyController.text.isNotEmpty
                                                  ? _bodyController.text.length - 2
                                                  : 0);
                                    },
                                    config: const Config(
                                        backspaceColor: Colors.white,
                                        columns: 7,
                                        emojiSizeMax: 32.0,
                                        verticalSpacing: 0,
                                        horizontalSpacing: 0,
                                        initCategory: Category.RECENT,
                                        bgColor:
                                        Color.fromRGBO(37, 20, 63, 1),
                                        indicatorColor: Colors.blue,
                                        iconColor: Colors.white,
                                        iconColorSelected: Colors.blue,
                                        recentsLimit: 28,
                                        tabIndicatorAnimDuration:
                                        kTabScrollDuration,
                                        categoryIcons:
                                        CategoryIcons(),
                                        buttonMode: ButtonMode.MATERIAL),
                                  );
                                });
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.faceSmile,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              addImage();
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.image,
                              size: 35,
                              color: Colors.white,
                            )),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(onPressed: () {
                          if (_titleController.text.isEmpty || _bodyController.text.isEmpty ) {
                            Toast.show('Lütfen tüm alanları doldurun', duration: Toast.lengthLong, gravity: Toast.bottom);
                            return;
                          }
                          else{
                            saveNote();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Kaydedildi')),
                            );
                          }},style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(37, 20, 63, 1)),
                        ), child: const Text('Kaydet', style: TextStyle(
                          color: Colors.white,
                        ),),),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                ],
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String ayHesaplama(DateTime day) {
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
