import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_bite/service/widget_support.dart';
import 'package:lottie/lottie.dart' as lottie;

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: 50, left: 40, right: 20),
        child: Column(
          children: [
            lottie.Lottie.asset(
              'images/pizza_animation.json', // Ensure this path matches your assets
              width: 350,
              height: 350,
            ),
            SizedBox(height: 20),
            Text(
              'The Fastest \n Food Delivery',
              style:
                  AppWidget.onboarding_heading_textstyle(), // Using the text style from AppWidget
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Craving something delicious?\n Order now and get it delivered to your doorstep in on time!',
              style: AppWidget.onboarding_simple_textstyle(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Container(
              height: Get.height * 0.07, //for responsive height
              width: Get.width * .7, //for responsive width
              decoration: BoxDecoration(
                color: Color(0xff8c592a),
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
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
          ],
        ),
      ),
    );
  }
}
