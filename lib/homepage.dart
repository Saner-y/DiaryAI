import 'package:diaryai/calendarPage.dart';
import 'package:diaryai/menuPage.dart';
import 'package:flutter/material.dart';
import 'package:diaryai/notePage.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
// import 'package:flutter/services.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  late final LocalAuthentication auth;

  bool _supportState = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
            (bool isSupported) => setState(() => _supportState = isSupported)
    );
    _getAvailableBiometrics();
    _authenticate();

  }
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

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
    print(availableBiometrics);
    if (!mounted) {
      return;
    }
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
          localizedReason: 'Parmak izinizi taratın',
          options: const AuthenticationOptions(
              stickyAuth: true,
              biometricOnly: true
          )
      );
      print(authenticated);
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
