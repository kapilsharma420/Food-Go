import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hot_bite/admin/admin_loin.dart';
import 'package:hot_bite/admin/allorder.dart';
import 'package:hot_bite/admin/homeAdminPage.dart';
import 'package:hot_bite/admin/manage_users.dart';
import 'package:hot_bite/screen/bottomnav.dart';
import 'package:hot_bite/screen/detail_page.dart';
import 'package:hot_bite/screen/home.dart';
import 'package:hot_bite/screen/login_page.dart';
import 'package:hot_bite/screen/order.dart';
import 'package:hot_bite/screen/signup.dart';
import 'package:hot_bite/screen/splashscreen.dart';
import 'package:hot_bite/screen/wallet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp();
 // यहाँ दोबारा immersive mode सेट करो
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // notch के नीचे content
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Go',
      theme: ThemeData(
        useMaterial3: true, // better edge-to-edge rendering
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: Splashscreen(),
      home: LoginPage(),
    );
  }
}
