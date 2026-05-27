import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad/screen/forget_password_screen.dart';
import 'package:mad/screen/main_screen.dart';
import 'package:mad/screen/register_screen.dart';
import 'package:mad/widgets/app_logo.dart' as appLogo;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool _isEmailValid = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _onEmailChangeHandler(String email) {
    if (email.isNotEmpty && email.contains("@")) {
      setState(() {
        _isEmailValid = true;
      });
    } else {
      setState(() {
        _isEmailValid = false;
      });
    }
  }

  final _keyForm = GlobalKey<FormState>();

  Future<void> _onLoginSubmitHandler() async {
    if (_keyForm.currentState!.validate()) {
      String user = emailController.text;
      String pass = passwordController.text;
      
      final pref = await SharedPreferences.getInstance();
      String username = pref.getString("username") ?? "mad@gmail.com";
      String password = pref.getString("password") ?? "123456";

      if (user == username && pass == password) {
        // SAVE USER NAME UPON SUCCESS
        await pref.setString("fullName", "Somnang"); 
        
        Get.snackbar("Success", "Login successful", backgroundColor: Colors.green, colorText: Colors.white);
        
        // Navigate to MainScreen
        Get.offAll(() => MainScreen());
      } else {
        Get.snackbar("Error", "Invalid Username or Password", backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final customLogo = SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: appLogo.logo,
    );

    final usernameTextField = Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: emailController,
        onChanged: _onEmailChangeHandler,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          suffixIcon: _isEmailValid
              ? Icon(Icons.check_circle, color: Colors.green)
              : Icon(Icons.check_circle),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          hintText: "Email",
        ),
        validator: (v) {
          if (v!.isEmpty) return "Email could not be blank.";
          return null;
        },
      ),
    );

    final passwordTextField = Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: passwordController,
        obscureText: _obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            onPressed: () => setState(() => _obscureText = !_obscureText),
            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          hintText: "Password",
        ),
        validator: (v) {
          if (v!.isEmpty) return "Password could not be blank.";
          return null;
        },
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 16),
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3051A0)),
          onPressed: _onLoginSubmitHandler,
          child: Text("ចូលប្រើ", style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    final _skipButton = TextButton(
      onPressed: () => Get.offAll(MainScreen()),
      child: Text("រំលង", style: TextStyle(color: Colors.blue)),
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              customLogo,
              Form(
                key: _keyForm,
                child: Column(
                  children: [usernameTextField, passwordTextField],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.to(ForgetPasswordScreen()),
                  child: Text("ភ្លេចលេខសង្ងាត់"),
                ),
              ),
              loginButton,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("មិនមានគណនីទេ?"),
                  TextButton(
                    onPressed: () => Get.to(RegisterScreen()),
                    child: Text("ចុះឈ្មោះ", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              _skipButton,
            ],
          ),
        ),
      ),
    );
  }
}
