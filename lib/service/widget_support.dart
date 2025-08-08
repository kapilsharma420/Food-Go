import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppWidget {
  //onboarding heading text style
  static TextStyle onboarding_heading_textstyle() {
    return TextStyle(
      fontSize: 30,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  //onboarding text style
  static TextStyle onboarding_simple_textstyle() {
    return TextStyle(fontSize: 18, color: Colors.black54);
  }
  //white textfield style

  static TextStyle white_text_field_style() {
    return TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle bold_textfield_style() {
    return TextStyle(
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle bold_white_textfield_style() {
    return TextStyle(
      fontSize: 28,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle price_textfield_style() {
    return TextStyle(
      fontSize: 20,
      color: const Color.fromARGB(157, 0, 0, 0),
      fontWeight: FontWeight.bold,
    );
  }

  // main colors

  static Color primary_red_color() {
    return Color(0xffef2b39);
  }

  
}
