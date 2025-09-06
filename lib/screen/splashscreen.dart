import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hot_bite/screen/onboarding.dart';
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

       //  Hide system UI for immersive sticky mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    //delay and navigate to Onboarding page
    Future.delayed(Duration(seconds: 3), () {
      Get.off(() => Onboarding()); // get off matlab onboarding per ja ker back spalash per nahi ayega
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: 120, left: 40, right: 20),
        child: Column(
          children: [
            Lottie.asset(
              'images/splash_s.json', // this is the animation path for splash screen
              width: 300,
              height: 300,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 20),
            Text(
              "Welcome to Kapil's FoodGo",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
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
