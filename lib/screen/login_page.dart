import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_bite/admin/admin_login.dart';
import 'package:hot_bite/controller/logincontroller.dart';
import 'package:hot_bite/screen/forgotpassword.dart';
import 'package:hot_bite/screen/signup.dart';
import 'package:hot_bite/service/widget_support.dart';
import 'package:lottie/lottie.dart' as lottie;

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginController controller = Get.put(LoginController(), permanent: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// Header
              Container(
                height: Get.height / 3.5,
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
                    lottie.Lottie.asset('images/Cooking.json',
                        width: 220, height: 180, fit: BoxFit.fill),
                    Image.asset('images/name_logo.png',
                        width: 150, height: 50, fit: BoxFit.cover),
                  ],
                ),
              ),

              const SizedBox(height: 5),
              const Text("LogIn",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54)),
              const SizedBox(height: 10),
              Text("Welcome back! Please login to continue",
                  style: AppWidget.form_text_style()),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
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
                          if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value))
                            return "Please enter a valid email";
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      /// Password
                      Obx(() => TextFormField(
                            controller: controller.passwordController,
                            focusNode: controller.passwordFocus,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) =>
                                controller.loginWithFirebase(),
                            obscureText: controller.obscurePassword.value,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(controller.obscurePassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () => controller.obscurePassword
                                    .value = !controller.obscurePassword.value,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return "Please enter your password";
                              return null;
                            },
                          )),

                      /// Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Get.to(() => ForgotPasswordPage()),
                          child: const Text("Forgot Password?",
                              style: TextStyle(color: Colors.blue)),
                        ),
                      ),

                      const SizedBox(height: 5),

                      // 🔹 Error message — snackbar ki jagah yahan dikhega
                      Obx(() => controller.errorMessage.value.isEmpty
                          ? const SizedBox.shrink()
                          : Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.red.shade200),
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

                      /// Login Button
                      Obx(() => SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffffefbf),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              onPressed: controller.isLoading.value
                                  ? null
                                  : controller.loginWithFirebase,
                              child: controller.isLoading.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.black, strokeWidth: 2.5)
                                  : const Text("Login",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                            ),
                          )),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () => Get.offAll(SignupPage()),
                            child: const Text("SignUp",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                       const SizedBox(height: 20),
                           // 🔹 Admin login — small subtle link
                      GestureDetector(
                        onTap: () => Get.to(() => const AdminLoginPage()),
                        child: Text(
                          'Admin Login',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.grey.shade400,
                          ),
                        ),
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
    );
  }
}