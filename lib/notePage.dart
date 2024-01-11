import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class notePage extends StatefulWidget {
  const notePage({super.key});

  @override
  State<notePage> createState() => _notePageState();
}

class _notePageState extends State<notePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white, size: 52)),
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
                  DateTime
                      .now()
                      .day
                      .toString() +
                      ' ' +
                      ayHesaplama() +
                      ' ' +
                      DateTime
                          .now()
                          .year
                          .toString() +
                      ' ' +
                      gunHesaplama(),
                  style: TextStyle(fontSize: 24, color: Colors.white),
                  textAlign: TextAlign.left),
            ),
            Column(
              children: [
                TextField(),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
                  child: TextField(
                    cursorRadius: Radius.circular(50),
                    cursorColor: Colors.white30,
                    maxLines: 12,
                    style: TextStyle(color: Colors.white),
                    // maxLength: 500,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30)),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(37, 20, 63, 1))),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30)),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(37, 20, 63, 1))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30)),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(37, 20, 63, 1))),
                        hintText: 'Bugün neler yaşadın? Hemen kaydet!',
                        hintStyle: TextStyle(color: Colors.white30),
                        fillColor: Color.fromRGBO(37, 20, 63, 1),
                        filled: true),
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
                    // color: Color.fromRGBO(37, 20, 63, 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: FaIcon(
                            FontAwesomeIcons.faceGrinSquint,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        FaIcon(FontAwesomeIcons.image,
                            size: 40, color: Colors.white),
                        SizedBox(
                          width: 10,
                        ),
                        FaIcon(FontAwesomeIcons.tag,
                            size: 40, color: Colors.white),
                        SizedBox(
                          width: 10,
                          height: 50,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
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
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  heartFace = FaIcon(
                                    FontAwesomeIcons.faceGrinHearts,
                                    color: Colors.black,
                                    size: 35,
                                  );
                                });
                              },
                              onTapCancel: () {
                                setState(() {
                                  heartFace = FaIcon(
                                    FontAwesomeIcons.faceGrinHearts,
                                    color: Colors.white,
                                    size: 35,
                                  );
                                });
                              },
                              child: heartFace),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  grinFace = FaIcon(
                                    FontAwesomeIcons.faceGrinHearts,
                                    color: Colors.black,
                                    size: 35,
                                  );
                                });
                              },
                              child: grinFace),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                mehFace = FaIcon(
                                  FontAwesomeIcons.faceGrinHearts,
                                  color: Colors.black,
                                  size: 35,
                                );
                              });
                            },
                            child: mehFace,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                frownFace = FaIcon(
                                  FontAwesomeIcons.faceGrinHearts,
                                  color: Colors.black,
                                  size: 35,
                                );
                              });
                            },
                            child: frownFace,),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                deadFace = FaIcon(
                                  FontAwesomeIcons.faceGrinHearts,
                                  color: Colors.black,
                                  size: 35,
                                );
                              });
                            },
                            child: deadFace,),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ]),
    );

  }
}


String ayHesaplama() {
  String ay = '';
  switch (DateTime
      .now()
      .month) {
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

String gunHesaplama() {
  String gun = '';
  switch (DateTime
      .now()
      .weekday) {
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
