import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'homepage.dart';

void main() => runApp(DiaryAI());

class DiaryAI extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(textTheme).copyWith(
          bodyMedium: GoogleFonts.poppins(textStyle: textTheme.bodyMedium)
        ),
      ),
      title: 'Material App',
      home: homePage(),
    );
  }
}
