import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hot_bite/admin/homeAdminPage.dart';
import 'package:hot_bite/screen/bottomnav.dart';
import 'package:hot_bite/screen/login_page.dart';
import 'package:hot_bite/screen/onboarding.dart';
import 'package:hot_bite/service/share_pref.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Future.delayed(const Duration(seconds: 3), _navigate);
  }

  Future<void> _navigate() async {
    final pref = SharedPrefHelper();

    // 🔹 Step 1: Admin check — pehle
    bool isAdminLoggedIn = await pref.getAdminLoggedIn();
    if (isAdminLoggedIn) {
      Get.off(() => const HomeAdminPage());
      return;
    }

    // 🔹 Step 2: Onboarding check
    bool onboardingSeen = await pref.getOnboardingSeen() ?? false;
    if (!onboardingSeen) {
      Get.off(() => const Onboarding());
      return;
    }

    // 🔹 Step 3: Firebase Auth check
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      Get.off(() => LoginPage());
      return;
    }

    // 🔹 Step 4: isDisabled check
    try {
      String? userId = await pref.getUserId();

      if (userId == null || userId.isEmpty) {
        await _forceLogout();
        return;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        await _forceLogout();
        return;
      }

      final Map<String, dynamic> userData =
          userDoc.data() as Map<String, dynamic>;
      final bool isDisabled = userData['isDisabled'] ?? false;

      if (isDisabled) {
        await _forceLogout();
        return;
      }

      Get.off(() => const BottomNav());
    } catch (e) {
      Get.off(() => const BottomNav());
    }
  }

  Future<void> _forceLogout() async {
    await SharedPrefHelper().clearUserData();
    await FirebaseAuth.instance.signOut();
    Get.off(() => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(top: 120, left: 40, right: 20),
        child: Column(
          children: [
            Lottie.asset('images/splash_s.json',
                width: 300, height: 300, fit: BoxFit.fill),
            const SizedBox(height: 20),
            const Text(
              "Welcome to Kapil's FoodGo",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your favorite food delivered fast and fresh!',
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}