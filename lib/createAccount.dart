import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> _createUser(String email, String password, String name, String surname, String username, String age, String phoneNumber) async {

    // Kullanıcıdan alınan bilgilerin boş olup olmadığını kontrol ediyoruz
    if (email.isEmpty || password.isEmpty || name.isEmpty || surname.isEmpty || username.isEmpty || age.isEmpty || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen tüm bilgileri doldurun.')),
      );
      return false;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Kullanıcı başarıyla oluşturuldu: ${userCredential.user}");

      // Kullanıcı oluşturulduktan sonra, kullanıcının bilgilerini Firestore'a ekliyoruz
      try {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'surname': surname,
          'username': username,
          'age': age,
          'phoneNumber': phoneNumber,
        });return true;
      } catch (e) {
        print("Firestore'a veri eklenirken bir hata oluştu: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Firestore\'a veri eklenirken bir hata oluştu: $e')),
        );return false;
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Şifre çok zayıf.')),
        );
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bu e-posta adresiyle zaten bir hesap var.')),
        );
      }return true;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );return false;
    }
  }
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  Icon visibilityIcon = Icon(Icons.visibility, color: Colors.white,);
  Icon confirmVisibilityIcon = Icon(Icons.visibility, color: Colors.white,);
  bool _showPassword = true;
  bool _confirmShowPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white, size: 48),
        title: Text('Hesap Oluştur', style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
        backgroundColor: Color.fromARGB(255, 40, 39, 81),
      ),
      backgroundColor: Color.fromARGB(255, 40, 39, 81),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /*Text('Create Account', style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),),*/
            Padding(padding: const EdgeInsets.only(left: 20,right: 20),
            child: TextField(
              controller: nameController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'İsim',
                hintStyle: TextStyle(
                  color: Colors.white54,
                ),
                prefixIcon: Icon(Icons.person, color: Colors.white,),
              ),
            ),),
            Padding(padding: const EdgeInsets.only(left: 20,right: 20),
              child: TextField(
                controller: surnameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Soyisim',
                  hintStyle: TextStyle(
                    color: Colors.white54,
                  ),
                  prefixIcon: Icon(Icons.person, color: Colors.white,),
                ),
              ),),
            Padding(padding: const EdgeInsets.only(left: 20,right: 20),
              child: TextField(
                controller: usernameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Kullanıcı Adı',
                  hintStyle: TextStyle(
                    color: Colors.white54,
                  ),
                  prefixIcon: Icon(Icons.person, color: Colors.white,),
                ),
              ),),
            Padding(padding: const EdgeInsets.only(left: 20,right: 20),
              child: TextField(
                controller: ageController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Yaş',
                  hintStyle: TextStyle(
                    color: Colors.white54,
                  ),
                  prefixIcon: Icon(Icons.person, color: Colors.white,),
                ),
              ),),
            Padding(padding: const EdgeInsets.only(left: 20,right: 20),
              child: TextField(
                controller: phoneNumberController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Telefon Numarası',
                  hintStyle: TextStyle(
                    color: Colors.white54,
                  ),
                  prefixIcon: Icon(Icons.phone, color: Colors.white,),
                ),
              ),),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'E-posta',
                  hintStyle: TextStyle(
                    color: Colors.white54,
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.white,),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: passwordController,
                obscureText: _showPassword,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Şifre',
                  hintStyle: TextStyle(
                    color: Colors.white54,
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.white,),
                  suffixIcon: IconButton(
                    icon: visibilityIcon,
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                        if (_showPassword) {
                          visibilityIcon = Icon(Icons.visibility, color: Colors.white,);
                        } else {
                          visibilityIcon = Icon(Icons.visibility_off, color: Colors.white,);
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: confirmPasswordController,
                obscureText: _confirmShowPassword,
                textInputAction: TextInputAction.done,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Şifreyi Onayla',
                  hintStyle: TextStyle(
                    color: Colors.white54,
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.white,),
                  suffixIcon: IconButton(
                    icon: confirmVisibilityIcon,
                    onPressed: () {
                      setState(() {
                        _confirmShowPassword = !_confirmShowPassword;
                        if (_confirmShowPassword) {
                          confirmVisibilityIcon = Icon(Icons.visibility, color: Colors.white,);
                        } else {
                          confirmVisibilityIcon = Icon(Icons.visibility_off, color: Colors.white,);
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(37, 20, 63, 1)),
                ),
                onPressed: () async {
                  if (passwordController.text != confirmPasswordController.text) {
                    // Şifreler aynı değilse, bir hata mesajı gösteririz
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Şifreler aynı değil!')),
                    );
                  } else {
                    // Şifreler aynıysa, kullanıcı oluşturma işlemi gerçekleştirilir
                    bool success = await _createUser(
                      emailController.text,
                      passwordController.text,
                      nameController.text,
                      surnameController.text,
                      usernameController.text,
                      ageController.text,
                      phoneNumberController.text,
                    );
                    if (success) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Hesap Oluştur', style: TextStyle(color: Colors.white),
                ),),
            ),
          ],
        )
      )
    );
  }
}
