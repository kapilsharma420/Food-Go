import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hot_bite/controller/signupcontroller.dart';
import 'package:hot_bite/service/widget_support.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'login_page.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.unfocusAll,
      child: Scaffold(
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
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
                        child: lottie.Lottie.asset(
                          'images/Cooking.json',
                          width: 220,
                          height: 180,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Image.asset(
                        'images/name_logo.png',
                        width: 150,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                /// Title
                const Text(
                  "SignUp",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Create your account to get started",
                  style: AppWidget.form_text_style(),
                ),
                const SizedBox(height: 20),

                /// Form
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
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(controller.emailFocus),
                          decoration: InputDecoration(
                            labelText: "Full Name",
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? "Please enter your name" : null,
                        ),
                        const SizedBox(height: 15),

                        /// Email
                        TextFormField(
                          controller: controller.emailController,
                          focusNode: controller.emailFocus,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(controller.passwordFocus),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) {
                              return "Please enter a valid email";
                            }
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
                                  .requestFocus(controller.confirmPasswordFocus),
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
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a password";
                                }
                                if (value.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
                              },
                            )),
                        const SizedBox(height: 15),

                        /// Confirm Password
                        Obx(() => TextFormField(
                              controller: controller.confirmPasswordController,
                              focusNode: controller.confirmPasswordFocus,
                              textInputAction: TextInputAction.done,
                              obscureText: controller.obscureConfirmPassword.value,
                              decoration: InputDecoration(
                                labelText: "Confirm Password",
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(controller.obscureConfirmPassword.value
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: controller.toggleConfirmPassword,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {
                                if (value != controller.passwordController.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                            )),
                        const SizedBox(height: 25),

                        /// Signup Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffffefbf),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: controller.signupWithFirebase,
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        /// Already have account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account? "),
                            GestureDetector(
                              onTap: () => Get.offAll(() => LoginPage()),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
