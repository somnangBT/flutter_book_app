import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  // File Storage
  // final fileStorageManager = FileStorageManager();
  // await fileStorageManager.initFileStorage();
  // await fileStorageManager.saveFileStorage();
  // await fileStorageManager.readFileStorage();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAD',
      theme: ThemeData(
        // fontFamily: 'NotoSansKhmer',
        // fontFamily: 'Hanuman',
        // fontFamily: 'KantumruyPro',
        colorScheme: ColorScheme.fromSeed(seedColor: app_background),
        // primarySwatch: ColorScheme.fromSeed(seedColor: Colors.green),
        // Google Font
        // textTheme: TextTheme(
        //   labelLarge: GoogleFonts.notoSansKhmer(),
        //   labelMedium: GoogleFonts.notoSansKhmer(),
        //   labelSmall: GoogleFonts.notoSansKhmer(),
        // ),
      ),
      home: StartupScreen(),
    );
  }
}