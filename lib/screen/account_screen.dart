import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad/data/shared_pref_manager.dart';
import 'package:mad/screen/login_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? _fullName;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final sharedPrefManager = SharedPrefManager();
    try {
      // This reads from the disk
      final name = await sharedPrefManager.getSharedPref("fullName");

      // DEBUG: Check this in your VS Code Console!
      print("STORAGE DATA: Currently saved name is: $name");

      setState(() {
        _fullName = name;
      });
    } catch (e) {
      print("Error loading name: $e");
      setState(() { _fullName = null; });
    }
  }


  Future<void> _onLogoutSubmitHandler() async {
    final sharedPrefManager = SharedPrefManager();
    await sharedPrefManager.removeSharedPref("fullName");
    Get.offAll(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    final authButton = Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: _fullName != null
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD45555)),
                onPressed: _onLogoutSubmitHandler,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("ចាកចេញ", style: TextStyle(color: Colors.white)),
                    SizedBox(width: 4),
                    Icon(Icons.logout_outlined, color: Colors.white)
                  ],
                ),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3051A0)),
                onPressed: () => Get.to(() => const LoginScreen()),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("ចូលប្រើ", style: TextStyle(color: Colors.white)),
                    SizedBox(width: 4),
                    Icon(Icons.login_outlined, color: Colors.white)
                  ],
                ),
              ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: const Text("Account"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.account_circle, size: 48),
                    title: Text(_fullName ?? "Guest"),
                    subtitle: const Text("Full Name"),
                  ),
                  const Divider(),
                  const ListTile(
                    leading: Icon(Icons.mail),
                    title: Text("mad@gmail.com"),
                    subtitle: Text("Email"),
                  ),
                  const Divider(),
                  const ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text("Order"),
                    subtitle: Text("Cart"),
                  ),
                  const Divider()
                ],
              ),
            ),
            authButton
          ],
        ),
      ),
    );
  }
}
