import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_bite/controller/signupcontroller.dart';
import 'package:hot_bite/service/widget_support.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:url_launcher/url_launcher.dart';
import 'login_page.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final SignupController controller =
      Get.put(SignupController(), permanent: false);

  // 🔹 Privacy policy URL
  static const String _privacyUrl =
      'https://sites.google.com/view/foodgoprivacypolicy/home';

  Future<void> _launchPrivacy() async {
    final uri = Uri.parse(_privacyUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.unfocusAll,
      child: Scaffold(
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: Column(
              children: [
                /// Header
                Container(
                  height: Get.height / 3.4,
                  padding: const EdgeInsets.only(bottom: 8),
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: AppWidget.form_yellow_color(),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    children: [
                      Flexible(
                        child: lottie.Lottie.asset('images/Cooking.json',
                            width: 220, height: 180, fit: BoxFit.fill),
                      ),
                      Image.asset('images/name_logo.png',
                          width: 150, height: 50, fit: BoxFit.cover),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                const Text("SignUp",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
                const SizedBox(height: 10),
                Text("Create your account to get started",
                    style: AppWidget.form_text_style()),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        /// Name
                        TextFormField(
                          controller: controller.nameController,
                          focusNode: controller.nameFocus,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(controller.emailFocus),
                          decoration: InputDecoration(
                            labelText: "Full Name",
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? "Please enter your name"
                                  : null,
                        ),
                        const SizedBox(height: 15),

                        /// Email
                        TextFormField(
                          controller: controller.emailController,
                          focusNode: controller.emailFocus,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(controller.passwordFocus),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return "Please enter your email";
                            if (!RegExp(r"^[^@]+@[^@]+\.[^@]+")
                                .hasMatch(value))
                              return "Please enter a valid email";
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        /// Password
                        Obx(() => TextFormField(
                              controller: controller.passwordController,
                              focusNode: controller.passwordFocus,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(
                                      controller.confirmPasswordFocus),
                              obscureText: controller.obscurePassword.value,
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(controller.obscurePassword.value
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: controller.togglePassword,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return "Please enter a password";
                                if (value.length < 6)
                                  return "Password must be at least 6 characters";
                                return null;
                              },
                            )),
                        const SizedBox(height: 15),

                        /// Confirm Password
                        Obx(() => TextFormField(
                              controller: controller.confirmPasswordController,
                              focusNode: controller.confirmPasswordFocus,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) =>
                                  controller.signupWithFirebase(),
                              obscureText:
                                  controller.obscureConfirmPassword.value,
                              decoration: InputDecoration(
                                labelText: "Confirm Password",
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                      controller.obscureConfirmPassword.value
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                  onPressed: controller.toggleConfirmPassword,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return "Please confirm your password";
                                if (value != controller.passwordController.text)
                                  return "Passwords do not match";
                                return null;
                              },
                            )),

                        const SizedBox(height: 25),

                        // 🔹 Privacy Policy Checkbox
                        Obx(() => Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Checkbox(
                                    value: controller.isPrivacyAccepted.value,
                                    onChanged: (_) =>
                                        controller.togglePrivacy(),
                                    activeColor:
                                        AppWidget.primary_red_color(),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4)),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black54),
                                      children: [
                                        const TextSpan(
                                            text: 'I agree to the '),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: TextStyle(
                                            color: AppWidget
                                                .primary_red_color(),
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = _launchPrivacy,
                                        ),
                                        const TextSpan(
                                            text:
                                                ' and consent to the collection and use of my personal data.'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),

                        const SizedBox(height: 15),

                        // Error message
                        Obx(() => controller.errorMessage.value.isEmpty
                            ? const SizedBox.shrink()
                            : Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.red.shade200),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.error_outline,
                                        color: Colors.red.shade700, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        controller.errorMessage.value,
                                        style: TextStyle(
                                            color: Colors.red.shade700,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              )),

                        const SizedBox(height: 15),

                        // 🔹 Signup Button — checkbox check hone pe hi active
                        Obx(() => SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      controller.isPrivacyAccepted.value
                                          ? const Color(0xffffefbf)
                                          : Colors.grey.shade300,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15)),
                                ),
                                // 🔹 Checkbox checked + loading nahi = button active
                                onPressed: controller.isLoading.value ||
                                        !controller.isPrivacyAccepted.value
                                    ? null
                                    : controller.signupWithFirebase,
                                child: controller.isLoading.value
                                    ? const CircularProgressIndicator(
                                        color: Colors.black, strokeWidth: 2.5)
                                    : Text(
                                        "Sign Up",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: controller
                                                    .isPrivacyAccepted.value
                                                ? Colors.black
                                                : Colors.grey.shade500),
                                      ),
                              ),
                            )),
                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account? "),
                            GestureDetector(
                              onTap: () => Get.offAll(() => LoginPage()),
                              child: const Text("Login",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}