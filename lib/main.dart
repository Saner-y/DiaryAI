import 'package:diaryai/loginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'firebase_options.dart';
import 'lockScreen.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'homepage.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(DiaryAI());
}

class DiaryAI extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(textTheme).copyWith(
            bodyMedium: GoogleFonts.poppins(textStyle: textTheme.bodyMedium)),
      ),
      title: 'Material App',
      home: LoginPage(),
    );
  }
}
