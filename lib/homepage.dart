import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryai/calendarPage.dart';
import 'package:diaryai/menuPage.dart';
import 'package:diaryai/takvimDeneme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:diaryai/notePage.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
// import 'package:flutter/services.dart';

class homePage extends StatefulWidget {
   homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {

  Future <String> getUserName() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final DocumentSnapshot user = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final String username = user.get('username');
    print(username);
    return username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/homePageBackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          primary: false,
          children: [Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: FutureBuilder<String>(
                  future: getUserName(),
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    // Eğer veri henüz gelmediyse bir yükleniyor belirtisi göster
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      // Eğer hata oluştuysa bir hata mesajı göster
                      if (snapshot.hasError) {
                        return Text('Günlüğüne Hoşgeldin \n Hata: ${snapshot.error}');
                      } else {
                        // Veri geldiyse, kullanıcı adını göster
                        return Text(
                          'Günlüğüne Hoşgeldin \n ${snapshot.data}',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        );
                      }
                    }
                  },
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 300),
                child: Text(
                  'Bugün neler yaşadın? \n Hemen anılarını kaydet!',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: ButtonBar(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: IconButton(
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.all(20),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => calendarPage(),));
                              },
                              icon: Icon(
                                Icons.calendar_month,
                                size: 64,
                                color: Colors.white,
                              ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => notePage()));
                            },
                            icon: Icon(
                              Icons.add_circle_outline,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: IconButton(
                            padding: EdgeInsets.all(20),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => menuPage(),
                                  ));
                            },
                            icon: Icon(
                              Icons.account_circle,
                              size: 64,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          ],
        ),
      ),
    );
  }
}
