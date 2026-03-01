import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hot_bite/screen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Firebase initialize — try/catch se crash nahi hoga
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  // System UI settings
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
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
      title: 'Hot Bite',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins', // agar use kar rahe ho toh
      ),
      // 🔹 GetX snackbar ke liye defaultSnackbarDecoration
      defaultTransition: Transition.fadeIn,
      home: const Splashscreen(),
    );
  }
}