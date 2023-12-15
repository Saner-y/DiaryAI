import 'package:flutter/material.dart';

class homePage extends StatelessWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/homePageBackground.jpg'),
                fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Günlüğüne hoşgeldin \n User',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Bugün neler yaşadın \n Hemen anılarını kaydet!',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            Row(

              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                ButtonBar(

                  children: [
                    IconButton(
                      constraints: BoxConstraints(
                        maxHeight: 50,

                      ),
                      padding: EdgeInsets.all(20),
                        onPressed: () {},
                        icon: Icon(
                          Icons.calendar_month,
                          size: 64,
                          color: Colors.white,
                        )),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.add_circle_outline,
                        size: 96,
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      style: ButtonStyle(),
                    ),
                    IconButton(
                      padding: EdgeInsets.all(20),
                        onPressed: () {},
                        icon: Icon(
                          Icons.account_circle,
                          size: 64,
                          color: Colors.white,
                        ))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
