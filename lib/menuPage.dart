import 'package:diaryai/homepage.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class menuPage extends StatelessWidget {
  const menuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 40, 39, 81),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 40, 39, 81),
        iconTheme: IconThemeData(color: Colors.white, size: 52),
      ),
      body: ListView(
        children: [
          Card(
            color: Color.fromRGBO(37, 20, 63, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45)
            ),

            margin: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => homePage(),));
              },
              title: Text('User',style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),),
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: FaIcon(FontAwesomeIcons.solidUser, color: Colors.white,),
              ),
            ),
          ),
          Card(
            color: Color.fromRGBO(37, 20, 63, 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45)
            ),
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => homePage(),));
              },
              title: Text('Galeri',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: FaIcon(FontAwesomeIcons.solidImages, color: Colors.white,),
              ),
            ),
          ),
          Card(
            color: Color.fromRGBO(37, 20, 63, 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45)
            ),
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => homePage(),));
              },
              title: Text('Istatistik',style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),),
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: FaIcon(FontAwesomeIcons.chartColumn, color: Colors.white,),
              ),
            ),
          ),
          Card(
            color: Color.fromRGBO(37, 20, 63, 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45)
            ),
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => homePage(),));
              },
              title: Text('Verileri Yedekle',style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),),
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: FaIcon(FontAwesomeIcons.cloudArrowUp, color: Colors.white,),
              ),
            ),
          ),
          Card(
            color: Color.fromRGBO(37, 20, 63, 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45)
            ),
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => homePage(),));
              },
              title: Text('Verileri Temizle',style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),),
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: FaIcon(FontAwesomeIcons.trash, color: Colors.white,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
