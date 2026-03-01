import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_bite/screen/login_page.dart';
import 'package:hot_bite/service/share_pref.dart';
import 'package:hot_bite/service/widget_support.dart';
import 'package:lottie/lottie.dart' as lottie;

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 40, right: 20),
        child: Column(
          children: [
            lottie.Lottie.asset(
              'images/pizza_animation.json',
              width: 350,
              height: 350,
            ),
            const SizedBox(height: 20),
            Text(
              'The Fastest \n Food Delivery',
              style: AppWidget.onboarding_heading_textstyle(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Craving something delicious?\n Order now and get it delivered to your doorstep in on time!',
              style: AppWidget.onboarding_simple_textstyle(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () async {
                // 🔹 Flag save karo — dobara onboarding nahi dikhegi
                await SharedPrefHelper().saveOnboardingSeen(true);
                Get.off(() => LoginPage());
              },
              child: Container(
                height: Get.height * 0.07,
                width: Get.width * .7,
                decoration: BoxDecoration(
                  color: const Color(0xff8c592a),
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}