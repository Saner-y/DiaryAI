import 'package:diaryai/lockScreen.dart';
import 'package:diaryai/resetPassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:diaryai/createAccount.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'firebase_options.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _signIn() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => homePage()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'Bu e-posta adresi ile bir kullanıcı bulunamadı.';
      } else if (e.code == 'wrong-password') {
        message = 'Yanlış şifre girdiniz.';
      } else if (e.code == 'invalid-email') {
        message = 'Geçersiz e-posta adresi girdiniz.';
      } else {
        message = 'Bir hata oluştu: $e';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    }
  }
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Icon visibilityIcon = Icon(Icons.visibility, color: Colors.white,);
  bool _showPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 40, 39, 81),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('DiaryAI',style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white24,
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    color: Colors.white54,
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.white,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: _showPassword,
                textInputAction: TextInputAction.done,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white24,
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    color: Colors.white54,
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          visibilityIcon = _showPassword ? Icon(Icons.visibility_off, color: Colors.white,) : Icon(Icons.visibility, color: Colors.white,);
                          _showPassword = !_showPassword;
                        });
                      },
                      icon: visibilityIcon),
                  prefixIcon: Icon(Icons.lock, color: Colors.white,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordPage(),));
                  }, child: Text('Reset Password', style: TextStyle(
                    color: Colors.white,
                  ),)),
                ],
              ),
              ElevatedButton(
                onPressed: _signIn,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(37, 20, 63, 1)),
                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Text('Giris Yap', style: TextStyle(
                  color: Colors.white,
                ),),
              ),
              SizedBox(height: 100),
              Text('Hala bir hesabın yok mu?', style: TextStyle(
                color: Colors.white,
              ),),
              ElevatedButton(style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(37, 20, 63, 1)),
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount(),));
                }, child: Text('Mail Ile Kayit Ol', style: TextStyle(
                  color: Colors.white,
                ),),),
            ],
          ),
        ),
      ),
    );
  }
}

