import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad/controller/order_controller.dart';
import 'package:mad/data/db_manager.dart';
import 'package:mad/screen/startup_screen.dart';
import 'package:mad/widgets/app_color.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/file_storage_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Sqflite DB
  await DbManager.instance.database;

  // Initialize Global Controllers - Set to permanent to prevent disposal
  Get.put(OrderController(), permanent: true);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MAD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: app_background),
      ),
      home: const StartupScreen(),
    );
  }
}
