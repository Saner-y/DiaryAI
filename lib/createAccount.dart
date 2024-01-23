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
        title: Text('Create Account', style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
        backgroundColor: Color.fromARGB(255, 40, 39, 81),
      ),
      backgroundColor: Color.fromARGB(255, 40, 39, 81),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TextField'lar ve butonlar için dolgulu bir stiller belirler, yuvarlak köşeli bir sınır ekler ve padding ve margin değerlerini ayarlar.
              _buildTextField(nameController, 'Name', Icons.person),
              SizedBox(height: 10),
              _buildTextField(surnameController, 'Surname', Icons.person),
              SizedBox(height: 10),
              _buildTextField(usernameController, 'Username', Icons.person),
              SizedBox(height: 10),
              _buildTextField(ageController, 'Age', Icons.person),
              SizedBox(height: 10),
              _buildTextField(phoneNumberController, 'Phone Number', Icons.phone),
              SizedBox(height: 10),
              _buildTextField(emailController, 'Email', Icons.email),
              SizedBox(height: 10),
              _buildPasswordField(passwordController, 'Password', Icons.lock),
              SizedBox(height: 10),
              _buildPasswordField(confirmPasswordController, 'Confirm Password', Icons.lock),
              SizedBox(height: 10),
              ElevatedButton(
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
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(37, 20, 63, 1)),
                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Text('Create Account', style: TextStyle(
                  color: Colors.white,
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, IconData icon) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.next,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white24,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white54,
        ),
        prefixIcon: Icon(icon, color: Colors.white,),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hintText, IconData icon) {
    return TextField(
      controller: controller,
      obscureText: _showPassword,
      textInputAction: TextInputAction.next,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white24,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white54,
        ),
        prefixIcon: Icon(icon, color: Colors.white,),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
