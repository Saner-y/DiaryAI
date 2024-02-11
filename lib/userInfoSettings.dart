import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class UserInfoSettings extends StatefulWidget {
  const UserInfoSettings({super.key});

  @override
  State<UserInfoSettings> createState() => _UserInfoSettingsState();
}

class _UserInfoSettingsState extends State<UserInfoSettings> {
  TextEditingController emailController = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;
  getInfo() async {
    if (currentUser != null) {
      String userId = currentUser!.uid;
      emailController.text = currentUser!.email!;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          print('Document data: ${documentSnapshot.data()}');
          print('Email: ${currentUser!.email}');
        } else {
          print('Document does not exist on the database');
        }
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(size: 48,color: Colors.white),
        backgroundColor: Color.fromARGB(255, 40, 39, 81),
        title: Text('Kullanıcı Bilgileri',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24),),
      ),
      backgroundColor: Color.fromARGB(255, 40, 39, 81),

      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'E-posta',
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.email,color: Colors.white,),
                  suffix: TextButton(onPressed: (){
                    // currentUser!.sendEmailVerification()
                  }, child: Icon(Icons.edit,color: Colors.white,),),
                ),

                style: TextStyle(color: Colors.white),
                readOnly: true,
                controller: emailController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
