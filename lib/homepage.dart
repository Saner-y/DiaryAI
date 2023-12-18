import 'package:diaryai/menuPage.dart';
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
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          primary: false,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: Text(
                    'Günlüğüne hoşgeldin \n User',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
                                onPressed: () {},
                                icon: Icon(
                                  Icons.calendar_month,
                                  size: 64,
                                  color: Colors.white,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: IconButton(
                              onPressed: () {},
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
