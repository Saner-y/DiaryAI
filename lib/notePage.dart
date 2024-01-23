import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class notePage extends StatefulWidget {
  const notePage({super.key});

  @override
  State<notePage> createState() => _notePageState();
}

class _notePageState extends State<notePage> {
  Future<void> saveNote(String title, String body, String faceEmoji) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      CollectionReference notes = FirebaseFirestore.instance.collection('users')
          .doc(currentUser.uid)
          .collection('notes');

      return notes
          .add({
        'title': title,
        'body': body,
        'faceEmoji': faceEmoji,
        'timestamp': DateTime.now()
      })
          .then((value) => print("Note Added"))
          .catchError((error) => print("Failed to add note: $error"));
    }
  }
  TextEditingController _titleController = TextEditingController();
  DateTime today = DateTime.now();
  List<File> _imageList = [];
  File? _image;
  TextEditingController _bodyController = TextEditingController();
  FaIcon heartFace = FaIcon(
    FontAwesomeIcons.faceGrinHearts,
    size: 35,
    color: Colors.white,
  );
  FaIcon grinFace = FaIcon(
    FontAwesomeIcons.faceGrin,
    size: 35,
    color: Colors.white,
  );
  FaIcon mehFace = FaIcon(
    FontAwesomeIcons.faceMeh,
    size: 35,
    color: Colors.white,
  );
  FaIcon frownFace = FaIcon(
    FontAwesomeIcons.faceFrown,
    size: 35,
    color: Colors.white,
  );
  FaIcon deadFace = FaIcon(
    FontAwesomeIcons.faceDizzy,
    size: 35,
    color: Colors.white,
  );
  FaIcon? selectedFace;

  void initState() {
    super.initState();
    _bodyController = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white, size: 48)),
      backgroundColor: Color.fromRGBO(40, 39, 81, 1),
      body: ListView(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                top: 50,
                bottom: 20,
              ),
              child: Text(
                  today.day.toString() +
                      ' ' +
                      ayHesaplama(today) +
                      ' ' +
                      today.year.toString() +
                      ' ' +
                      gunHesaplama(today),
                  style: TextStyle(fontSize: 24, color: Colors.white),
                  textAlign: TextAlign.left),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
                  child: TextField(
                    controller: _titleController,
                    maxLines: 1,
                    cursorRadius: Radius.circular(50),
                    cursorColor: Colors.white30,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
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
                        hintText: 'Başlık',
                        hintStyle: TextStyle(color: Colors.white30),
                        fillColor: Color.fromRGBO(37, 20, 63, 1),
                        filled: true),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
                  child: TextField(
                    controller: _bodyController,
                    cursorRadius: Radius.circular(50),
                    cursorColor: Colors.white30,
                    minLines: 12,
                    maxLines: 1000,
                    textInputAction: TextInputAction.newline,
                    style: TextStyle(color: Colors.white),
                    // maxLength: 500,
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
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(37, 20, 63, 1),
                        border:
                            Border.all(color: Color.fromRGBO(37, 20, 63, 1))),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _imageList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                image: DecorationImage(
                                    image: FileImage(_imageList[index]),
                                    fit: BoxFit.cover)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30)),
                        color: Color.fromRGBO(37, 20, 63, 1),
                        border:
                            Border.all(color: Color.fromRGBO(37, 20, 63, 1))),
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
                                    config: Config(
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
                                            const CategoryIcons(),
                                        buttonMode: ButtonMode.MATERIAL),
                                  );
                                });
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.faceSmile,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              _pickImage();
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.image,
                              size: 35,
                              color: Colors.white,
                            )),
                        IconButton(
                          onPressed: () {
                            _bodyController.clear();
                            _imageList.clear();
                            _titleController.clear();
                          },
                          icon: Icon(
                            Icons.clear,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(37, 20, 63, 1),
                    borderRadius: BorderRadius.all(Radius.circular(45))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30, top: 10),
                      child: Text(
                        'Gününüz nasıl geçti?',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20, left: 40, right: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ButtonBar(
                            alignment: MainAxisAlignment.spaceEvenly,
                            buttonPadding: EdgeInsets.all(0),
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      heartFace = FaIcon(
                                        FontAwesomeIcons.faceGrinHearts,
                                        size: 35,
                                        color: Colors.greenAccent,
                                      );
                                      grinFace = FaIcon(
                                        FontAwesomeIcons.faceGrin,
                                        size: 35,
                                        color: Colors.white,
                                      );
                                      mehFace = FaIcon(
                                        FontAwesomeIcons.faceMeh,
                                        size: 35,
                                        color: Colors.white,
                                      );
                                      frownFace = FaIcon(
                                        FontAwesomeIcons.faceFrown,
                                        size: 35,
                                        color: Colors.white,
                                      );
                                      deadFace = FaIcon(
                                        FontAwesomeIcons.faceDizzy,
                                        size: 35,
                                        color: Colors.white,
                                      );
                                      selectedFace = heartFace;
                                    });
                                  },
                                  icon: heartFace),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      grinFace = FaIcon(
                                        FontAwesomeIcons.faceGrin,
                                        size: 35,
                                        color: Colors.lightGreenAccent,
                                      );
                                      heartFace = FaIcon(
                                        FontAwesomeIcons.faceGrinHearts,
                                        size: 35,
                                        color: Colors.white,
                                      );
                                      mehFace = FaIcon(
                                        FontAwesomeIcons.faceMeh,
                                        size: 35,
                                        color: Colors.white,
                                      );
                                      frownFace = FaIcon(
                                        FontAwesomeIcons.faceFrown,
                                        size: 35,
                                        color: Colors.white,
                                      );
                                      deadFace = FaIcon(
                                        FontAwesomeIcons.faceDizzy,
                                        size: 35,
                                        color: Colors.white,
                                      );
                                      selectedFace = grinFace;
                                    });
                                  },
                                  icon: grinFace),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      mehFace = FaIcon(
                                        FontAwesomeIcons.faceMeh,
                                        size: 35,
                                        color: Colors.yellowAccent,
                                      );
                                      heartFace = FaIcon(
                                        FontAwesomeIcons.faceGrinHearts,
                                        size: 35,
                                        color: Colors.white,
                                      );
                                      grinFace = FaIcon(
                                        FontAwesomeIcons.faceGrin,
                                        size: 35,
                                        color: Colors.white,
                                      );
                                      frownFace = FaIcon(
                                        FontAwesomeIcons.faceFrown,
                                        size: 35,
                                        color: Colors.white,
                                      );
                                      deadFace = FaIcon(
                                        FontAwesomeIcons.faceDizzy,
                                        size: 35,
                                        color: Colors.white,
                                      );
                                      selectedFace = mehFace;
                                    });
                                  },
                                  icon: mehFace),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      frownFace = FaIcon(
                                        FontAwesomeIcons.faceFrown,
                                        size: 35,
                                        color: Colors.orange,
                                      );
                                      heartFace = FaIcon(
                                        FontAwesomeIcons.faceGrinHearts,
                                        size: 35,
                                        color: Colors.white,
                                      );
                                      grinFace = FaIcon(
                                        FontAwesomeIcons.faceGrin,
                                        size: 35,
                                        color: Colors.white,
                                      );
                                      mehFace = FaIcon(
                                        FontAwesomeIcons.faceMeh,
                                        size: 35,
                                        color: Colors.white,
                                      );
                                      deadFace = FaIcon(
                                        FontAwesomeIcons.faceDizzy,
                                        size: 35,
                                        color: Colors.white,
                                      );
                                      selectedFace = frownFace;
                                    });
                                  },
                                  icon: frownFace),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      deadFace = FaIcon(
                                        FontAwesomeIcons.faceDizzy,
                                        size: 35,
                                        color: Colors.redAccent,
                                      );
                                      heartFace = FaIcon(
                                        FontAwesomeIcons.faceGrinHearts,
                                        size: 35,
                                        color: Colors.white,
                                      );
                                      grinFace = FaIcon(
                                        FontAwesomeIcons.faceGrin,
                                        size: 35,
                                        color: Colors.white,
                                      );
                                      mehFace = FaIcon(
                                        FontAwesomeIcons.faceMeh,
                                        size: 35,
                                        color: Colors.white,
                                      );
                                      frownFace = FaIcon(
                                        FontAwesomeIcons.faceFrown,
                                        size: 35,
                                        color: Colors.white,
                                      );
                                      selectedFace = deadFace;
                                    });
                                  },
                                  icon: deadFace),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(onPressed: () {
                    saveNote(_titleController.text, _bodyController.text, selectedFace.toString());
                    Navigator.pop(context);
                    Toast.show('Kaydedildi', duration: Toast.lengthShort, gravity: Toast.center);
                  },style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(37, 20, 63, 1)),
                  ), child: Text('Kaydet', style: TextStyle(
                    color: Colors.white,
                  ),),),
                ],
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ]),
    );
  }

  Future _pickImage() async {

    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _image = File(returnedImage.path);
      _imageList.insert(0,_image!);
    });
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

  String gunHesaplama(day) {
    String gun = '';
    switch (day.weekday) {
      case 1:
        gun = 'Pazartesi';
        break;
      case 2:
        gun = 'Salı';
        break;
      case 3:
        gun = 'Çarşamba';
        break;
      case 4:
        gun = 'Perşembe';
        break;
      case 5:
        gun = 'Cuma';
        break;
      case 6:
        gun = 'Cumartesi';
        break;
      case 7:
        gun = 'Pazar';
        break;
    }
    return gun;
  }
}

