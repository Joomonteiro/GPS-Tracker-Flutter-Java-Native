import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gps_tracker/db/database.dart';
import 'pages/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(
      db: await $FloorAppDatabase.databaseBuilder('app_database.db').build()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.db}) : super(key: key);
  final AppDatabase db;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(
      db: db,
    ));
  }
}

