import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_bite/pages/bottomnav.dart';
import 'package:hot_bite/pages/detail_page.dart';
import 'package:hot_bite/pages/home.dart';
import 'package:hot_bite/pages/onboarding.dart';
import 'package:hot_bite/pages/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hot Bite',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BottomNav()
    );
  }
}
