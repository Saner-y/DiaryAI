import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as path;
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddNotePage extends StatefulWidget {
  final DateTime selectedDate;
  

  AddNotePage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  List<File> _imageList = [];
  File? _image;
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  late List<String> _imageUrls;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
    _imageUrls = [];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
  /*Future<double> analyzeSentiment(String noteBody) async {
    // API endpoint
    String apiUrl = 'http://sentiment-api-url.com/analyze';

    // API'ye gönderilecek veri
    Map<String, String> body = {
      'text': noteBody,
    };

    // HTTP POST isteği oluştur
    http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    // Yanıtı işle
    if (response.statusCode == 200) {
      Map<String, dynamic> apiResponse = jsonDecode(response.body);
      double sentimentScore = apiResponse['score'];
      return sentimentScore;
    } else {
      throw Exception('Failed to analyze sentiment');
    }
  }*/

  Future<String> uploadImage(File imageFile, String userId) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child("images/$userId/$fileName.jpg");

    UploadTask uploadTask = reference.putFile(imageFile);
    TaskSnapshot storageTaskSnapshot = await uploadTask;

    // Check if the upload is successful
    if (storageTaskSnapshot.state == TaskState.success) {
      print('Upload is successful');
    } else {
      print('Upload failed with state: ${storageTaskSnapshot.state}');
    }

    // Try getting the download URL
    try {
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Failed to get download URL: $e');
      throw e;
    }
  }

  Future<void> saveNote(String title, String body, List<File> imageFiles) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      CollectionReference notes = FirebaseFirestore.instance.collection('users')
          .doc(currentUser.uid)
          .collection('notes');

      List<String> imageUrls = [];
      for (File imageFile in imageFiles) {
        String imageUrl = await uploadImage(imageFile, currentUser.uid);
        imageUrls.add(imageUrl);
      }


      return notes
          .add({
        'title': title,
        'body': body,
        'imageUrls': imageUrls,
        // 'sentimentScore': await analyzeSentiment(body),
        'timestamp': '${widget.selectedDate.day} ${ayHesaplama(widget.selectedDate)} ${widget.selectedDate.year}',
      })
          .then((value) => print("Note Added"))
          .catchError((error) => print("Failed to add note: $error"));
    }
  }

  Future<void> addImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final File file = File(pickedFile.path);
        final Reference ref = FirebaseStorage.instance.ref().child('images').child(path.basename(file.path));
        final UploadTask uploadTask = ref.putFile(file);
        final TaskSnapshot taskSnapshot = await uploadTask;
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        setState(() {
          _imageUrls.add(downloadUrl);
        });
      }
    } catch (e) {
      print('An error occurred while adding the image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 48),
        backgroundColor: Color.fromRGBO(40, 39, 81, 1),
        title: Text('Yeni Not Ekle',style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        color: Color.fromRGBO(40, 39, 81, 1),
        child: ListView(
          children:[ Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    top: 20,
                    bottom: 20,
                  ),
                  child: Text(
                      '${widget.selectedDate.day} ${ayHesaplama(widget.selectedDate)} ${widget.selectedDate.year} ${gunHesaplama(widget.selectedDate)}',
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                      textAlign: TextAlign.left),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
                  child: TextField(
                    controller: _titleController,
                    maxLines: 1,
                    maxLength: 20,
                    cursorRadius: const Radius.circular(50),
                    cursorColor: Colors.white30,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
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
                    cursorRadius: const Radius.circular(50),
                    cursorColor: Colors.white30,
                    minLines: 12,
                    maxLines: 1000,
                    textInputAction: TextInputAction.newline,
                    style: const TextStyle(color: Colors.white),
                    // maxLength: 500,
                    decoration: const InputDecoration(
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
                        color: const Color.fromRGBO(37, 20, 63, 1),
                        border:
                        Border.all(color: const Color.fromRGBO(37, 20, 63, 1))),
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
                                const BorderRadius.all(Radius.circular(30)),
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
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Container(
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
                              _pickImage();
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.image,
                              size: 35,
                              color: Colors.white,
                            )),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _imageList;
                            });
                            _bodyController.clear();
                            _imageList.clear();
                            _titleController.clear();
                          },
                          icon: const Icon(
                            Icons.clear,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(onPressed: () {
                        if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
                          Toast.show('Lütfen tüm alanları doldurun', duration: Toast.lengthLong, gravity: Toast.bottom);
                          return;
                        }
                        else{
                          saveNote(_titleController.text, _bodyController.text, _imageList);
                          Navigator.pop(context);
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
              ],
            ),
          ),
          ],
        ),
      ),
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
