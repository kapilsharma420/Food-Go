import 'dart:convert';
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
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  // 🔹 Netlify version.json URL
  static const String _versionUrl =
      'https://foodgodownloadlink.netlify.app/version.json';

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Future.delayed(const Duration(seconds: 3), _checkVersionThenNavigate);
  }

  Future<void> _checkVersionThenNavigate() async {
    try {
      // Current app ka version code
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersionCode = int.tryParse(packageInfo.buildNumber) ?? 1;

      // Netlify se latest version fetch karo
      final response = await http
          .get(Uri.parse(_versionUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final latestVersionCode = data['version_code'] as int;
        final latestVersionName = data['version_name'] as String;
        final apkUrl = data['apk_url'] as String;
        final releaseNotes = data['release_notes'] as String? ?? '';

        if (latestVersionCode > currentVersionCode) {
          // 🔹 New version available — popup dikhao
          if (mounted) {
            await _showUpdateDialog(latestVersionName, apkUrl, releaseNotes);
            return;
          }
        }
      }
    } catch (e) {
      // Network error — silently ignore, normal navigate
    }

    await _navigate();
  }

  // 🔹 Update popup
  Future<void> _showUpdateDialog(
      String newVersion, String apkUrl, String releaseNotes) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.system_update_rounded,
                  color: Colors.red.shade600, size: 28),
            ),
            const SizedBox(width: 12),
            const Text('Update Available!',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Text(
                'New Version: $newVersion',
                style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600),
              ),
            ),
            if (releaseNotes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(releaseNotes,
                  style: const TextStyle(
                      fontSize: 13, color: Colors.black54)),
            ],
            const SizedBox(height: 12),
            const Text(
              'Please update to get latest features and bug fixes.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          // Skip — purane version pe chal jaao
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _navigate();
            },
            child:
                const Text('Skip', style: TextStyle(color: Colors.grey)),
          ),
          // Download — Netlify APK
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              final uri = Uri.parse(apkUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri,
                    mode: LaunchMode.externalApplication);
              }
            },
            child: const Text('Download Update',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _navigate() async {
    final pref = SharedPrefHelper();

    // Step 1: Admin check
    bool isAdminLoggedIn = await pref.getAdminLoggedIn();
    if (isAdminLoggedIn) {
      Get.off(() => const HomeAdminPage());
      return;
    }

    // Step 2: Onboarding check
    bool onboardingSeen = await pref.getOnboardingSeen() ?? false;
    if (!onboardingSeen) {
      Get.off(() => const Onboarding());
      return;
    }

    // Step 3: Firebase Auth check
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      Get.off(() => LoginPage());
      return;
    }

    // Step 4: isDisabled check
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