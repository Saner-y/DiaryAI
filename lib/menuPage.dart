import 'package:diaryai/homepage.dart';
import 'package:flutter/material.dart';

class menuPage extends StatelessWidget {
  const menuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 40, 39, 81),
        iconTheme: IconThemeData(color: Colors.white, size: 52),
      ),
      body: Container(
        color: Color.fromARGB(255, 40, 39, 81),
        child: ListView(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45)
              ),
              margin: EdgeInsets.only(top: 20),
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => homePage(),));
                },
                title: Text('User'),
                leading: CircleAvatar(
                  child: Icon(Icons.account_circle),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.only(top: 20),
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => homePage(),));
                },
                title: Text('User'),
                leading: CircleAvatar(
                  child: Icon(Icons.account_circle),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.only(top: 20),
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => homePage(),));
                },
                title: Text('User'),
                leading: CircleAvatar(
                  child: Icon(Icons.account_circle),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.only(top: 20),
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => homePage(),));
                },
                title: Text('User'),
                leading: CircleAvatar(
                  child: Icon(Icons.account_circle),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.only(top: 20),
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => homePage(),));
                },
                title: Text('User'),
                leading: CircleAvatar(
                  child: Icon(Icons.account_circle),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.only(top: 20),
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => homePage(),));
                },
                title: Text('User'),
                leading: CircleAvatar(
                  child: Icon(Icons.account_circle),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
