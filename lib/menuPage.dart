import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryai/galleryPage.dart';
import 'package:diaryai/homepage.dart';
import 'package:diaryai/loginPage.dart';
import 'package:diaryai/statistics.dart';
import 'package:diaryai/userInfoSettings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class menuPage extends StatelessWidget {
  const menuPage({super.key});

  void deleteAllNotes() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String userId = currentUser.uid;

      // Get the notes collection
      CollectionReference notesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('notes');

      // Get all the notes
      QuerySnapshot snapshot = await notesCollection.get();

      // Delete each note
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        // Delete the images from Firebase Storage
        List<String> imageUrls = List<String>.from(doc['imageUrls']);
        for (String imageUrl in imageUrls) {
          Reference ref = FirebaseStorage.instance.refFromURL(imageUrl);
          await ref.delete();
        }

        // Delete the note from Firestore
        await doc.reference.delete();
      }
    }
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: Text('Emin misiniz?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tüm verilerinizi silmek istediğinize emin misiniz? Temizlemek istiyorsanız "Verilerim Temizlensin" yazın.'),
              TextField(
                controller: controller,
                decoration: InputDecoration(hintText: 'Verilerim Temizlensin'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sil'),
              onPressed: () {
                if (controller.text == 'Verilerim Temizlensin') {
                  deleteAllNotes();
                  Navigator.of(context).pop();
                } else {
                  // Show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Yanlış metin girdiniz.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> getUserName() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final DocumentSnapshot user =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final String username = user.get('username');
    print(username);
    return username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 40, 39, 81),
      appBar: AppBar(
        title: const Text(
          'Menü',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 40, 39, 81),
        iconTheme: const IconThemeData(color: Colors.white, size: 48),
      ),
      body: ListView(
        children: [
          Card(
            color: const Color.fromRGBO(37, 20, 63, 1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserInfoSettings(),
                    ));
              },
              title: FutureBuilder<String>(
                future: getUserName(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  // Eğer veri henüz gelmediyse bir yükleniyor belirtisi göster
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    // Eğer hata oluştuysa bir hata mesajı göster
                    if (snapshot.hasError) {
                      return Text(
                          'Kullanıcı Adı alınamadı \n Hata: ${snapshot.error}');
                    } else {
                      // Veri geldiyse, kullanıcı adını göster
                      return Text(
                        '${snapshot.data}',
                        style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      );
                    }
                  }
                },
              ),
              leading: const CircleAvatar(
                backgroundColor: Colors.transparent,
                child: FaIcon(
                  FontAwesomeIcons.solidUser,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Card(
            color: const Color.fromRGBO(37, 20, 63, 1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GalleryPage(),
                    ));
              },
              title: const Text(
                'Galeri',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              leading: const CircleAvatar(
                backgroundColor: Colors.transparent,
                child: FaIcon(
                  FontAwesomeIcons.solidImages,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Card(
            color: const Color.fromRGBO(37, 20, 63, 1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MoodChartPage()),
                );
              },
              title: const Text(
                'Istatistik',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              leading: const CircleAvatar(
                backgroundColor: Colors.transparent,
                child: FaIcon(
                  FontAwesomeIcons.chartColumn,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Card(
            color: const Color.fromRGBO(37, 20, 63, 1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: ListTile(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Veriler Yedeklendi')),
                );
              },
              title: const Text(
                'Verileri Yedekle',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              leading: const CircleAvatar(
                backgroundColor: Colors.transparent,
                child: FaIcon(
                  FontAwesomeIcons.cloudArrowUp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Card(
            color: const Color.fromRGBO(37, 20, 63, 1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: ListTile(
              onTap: () {
                showDeleteConfirmationDialog(context);
              },
              title: const Text(
                'Verileri Temizle',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              leading: const CircleAvatar(
                backgroundColor: Colors.transparent,
                child: FaIcon(
                  FontAwesomeIcons.trash,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Card(
            color: const Color.fromRGBO(37, 20, 63, 1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: ListTile(
              onTap: () {
                logoutUser();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
              },
              title: const Text(
                'Çıkış Yap',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              leading: const CircleAvatar(
                backgroundColor: Colors.transparent,
                child: FaIcon(
                  FontAwesomeIcons.rightFromBracket,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void logoutUser() async {
    await FirebaseAuth.instance.signOut();
  }
}
