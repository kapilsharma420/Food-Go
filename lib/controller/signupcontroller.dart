import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hot_bite/screen/login_page.dart';
import 'package:hot_bite/service/daatabase.dart';
import 'package:hot_bite/service/share_pref.dart';
import 'package:random_string/random_string.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final nameFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final confirmPasswordFocus = FocusNode();

  var obscurePassword = true.obs;
  var obscureConfirmPassword = true.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  void togglePassword() => obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPassword() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;
  void unfocusAll() => FocusManager.instance.primaryFocus?.unfocus();

  Future<void> signupWithFirebase() async {
    if (!formKey.currentState!.validate()) return;

    unfocusAll();
    errorMessage.value = '';
    isLoading.value = true;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String id = randomAlphaNumeric(10);
      Map<String, dynamic> userInfoMap = {
        "Id": id,
        "Name": nameController.text.trim(),
        "Email": emailController.text.trim(),
        "Wallet": "0",
        "isDisabled": false, // 🔹 Default — naya user active hoga
      };

      await Future.wait([
        SharedPrefHelper().saveUserEmail(emailController.text.trim()),
        SharedPrefHelper().saveUserName(nameController.text.trim()),
        SharedPrefHelper().saveUserId(id),
        Database().addUserDetails(userInfoMap, id),
      ]);

      isLoading.value = false;
      Get.offAll(() => LoginPage());

    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      errorMessage.value = _getErrorMessage(e.code);
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Something went wrong. Please try again.';
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered. Please login.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'network-request-failed':
        return 'No internet connection. Please try again.';
      default:
        return 'Signup failed. Please try again.';
    }
  }
}