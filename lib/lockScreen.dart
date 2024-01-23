import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';

import 'homepage.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
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
    _getAvailableBiometrics;
    _authenticate;

  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 40, 39, 81),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              FaIcon(FontAwesomeIcons.lock, size: 52,color: Colors.white,),
              SizedBox(height: 20,),
              Text('Kilit Ekranı', style: TextStyle(color: Colors.white, fontSize: 32),),
              SizedBox(height: 20,),
              Text('Devam etmek için kimliğinizi doğrulayın', style: TextStyle(color: Colors.white, fontSize: 16),),
              SizedBox(height: 20,),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(37, 20, 63, 1)),
                ),
                onPressed: _authenticate,
                child: const Text('Kilidi Aç', style: TextStyle(color: Colors.white),
              ),)
            ]

        ),
      ),
    );
  }
  Future<void> isBiometricAvailable() async {
    if (_supportState)
      const Text('This device is supported');
    else {
      const Text('This device is not supported');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => homePage(),));
  }
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
          localizedReason: 'Biometric Doğrulamayı kullanarak giriş yapın',
          options: const AuthenticationOptions(
              stickyAuth: true,
              biometricOnly: true
          )
          );
      if (authenticated){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => homePage(),));
      }else{
        print('Not authenticated');
      }
      print(authenticated);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
    print(availableBiometrics);
    if (!mounted) {
      return;
    }
  }
}
