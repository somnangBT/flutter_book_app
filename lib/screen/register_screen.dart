import 'package:flutter/material.dart';
import 'package:mad/screen/login_screen.dart';
import 'package:mad/screen/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mad/widgets/app_logo.dart' as appLogo;
class RegisterScreen extends StatefulWidget {

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

    bool _obscureText = true;
    bool _isEmailValid = false;

    final fullNameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    void _onEmailChangeHandler(String email){
      if(email.isNotEmpty && email.contains("@")){
        setState(() {
          _isEmailValid = true;
        });
      }else{
        setState(() {
          _isEmailValid = false;
        });
      }
    }

    final _keyForm = GlobalKey<FormState>();

    Future<void> _onRegisterSubmitHandler() async {
      if (_keyForm.currentState!.validate()) {
        String fullName = fullNameController.text;
        String user = emailController.text;
        String pass = passwordController.text;

        // Save to SharedPreferences
        final pref = await SharedPreferences.getInstance();
        await pref.setString("fullName", fullName);
        await pref.setString("username", user);
        await pref.setString("password", pass);

        // Show Alert Dialog
        if (!mounted) return; // Safety check for async gaps
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("ជោគជ័យ"),
              content: const Text("ការចុះឈ្មោះរបស់អ្នកបានជោគជ័យ!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    // Navigate to Login or Main Screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text("យល់ព្រម"),
                ),
              ],
            );
          },
        );
      }
    }

    @override
    Widget build(BuildContext context) {

      final customLogo = SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        child: appLogo.logo,
      );


      final fullNameTextField = Padding(
          padding: EdgeInsets.all(8),
          child: TextFormField(
            controller: fullNameController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.account_circle),
                suffixIcon: Icon(Icons.check_circle, color: Colors.green,),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)
                ),
                hintText: "Full Name"
            ),
          )
      );


      final usernameTextField = Padding(
          padding: EdgeInsets.all(8),
          child: TextFormField(
            controller: emailController,
            onChanged: _onEmailChangeHandler,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.mail),
                suffixIcon: _isEmailValid ?  Icon(Icons.check_circle, color: Colors.green,) :  Icon(Icons.check_circle),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)
                ),
                hintText: "Email"
            ),
            validator: (v){
              if(v!.isEmpty){
                return "Email could not be blank.";
              }
              return null;
            },
          )
      );

      final passwordTextField = Padding(
          padding: EdgeInsets.all(8),
          child: TextFormField(
            controller: passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              suffixIcon: IconButton(onPressed: (){
                setState(() {
                  _obscureText = !_obscureText;
                });
              }, icon: _obscureText ? Icon(Icons.visibility_off) : Icon(Icons.visibility)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30)
              ),
              hintText: "Password",
            ),
            validator: (v){
              if(v!.isEmpty){
                return "Password could not be blank.";
              }
              return null;
            },
          )
      );

      final registerButton = Padding(padding: EdgeInsets.only(left: 8, right: 8, bottom: 16),
        child: SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3051A0)
              ),
              onPressed: _onRegisterSubmitHandler
              , child: Text("ចុះឈ្មោះ", style: TextStyle(color: Colors.white),)),
        ),);

      final forgetPassword = Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(onPressed: (){

          }, child: Text("ភ្លេចលេខសង្ងាត់"))
        ],
      );

      final noAccount = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("មានគណនី?"),
          TextButton(onPressed: (){
            final route = MaterialPageRoute(builder: (BuildContext context) => LoginScreen());
            Navigator.push(context, route);
          }, child: Text("ចូលប្រើ", style: TextStyle(fontWeight: FontWeight.bold),))
        ],
      );

      final orLineWidget = Row(
        children: [
          Expanded(child: Divider(thickness: 2,)),
          Text("ឬក៏"),
          Expanded(child: Divider(thickness: 2,)),
        ],
      );

      final socialWidget = Padding(
        padding: EdgeInsets.only(top: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.facebook, color: Colors.blue,size: 40,),
            SizedBox(width: 8,),
            Icon(Icons.mail_outlined, color: Colors.red,size: 40,)
          ],
        ),);

      final loginForm = Form(
        key: _keyForm,
        child: Column(
          children: [
            fullNameTextField,
            usernameTextField,
            passwordTextField,
            forgetPassword
          ],
        ),
      );

      final _skipButton = TextButton(onPressed: (){
        final route = MaterialPageRoute(builder: (BuildContext context) => MainScreen());
        Navigator.pushReplacement(context, route);
      }, child: Text("រំលង", style: TextStyle(color: Colors.blue),));

      return Scaffold(
        body: SafeArea(
            child: Column(
              children: [
                customLogo,
                loginForm,
                registerButton,
                noAccount,
                orLineWidget,
                socialWidget,
                SizedBox(height: 40,),
                _skipButton
              ],
            )),
      );
    }
}
