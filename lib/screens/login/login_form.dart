import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../controller/login/login_controller.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back",
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.royalBlue,
              ),
            ),
            Text(
              "Login to your account",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              "Your Email",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.royalBlue,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: loginController.emailController,
              keyboardType: TextInputType.emailAddress,
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                hintText: 'Enter your email',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Password",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.royalBlue,
              ),
            ),
            const SizedBox(height: 6),
            Obx(() => TextField(
                  controller: loginController.passwordController,
                  obscureText: !loginController.isPasswordVisible.value,
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        loginController.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: loginController.togglePasswordVisibility,
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Implement forgot password
                  Get.snackbar('Info', 'Forgot password feature coming soon');
                },
                child: Text(
                  'Forgot password?',
                  style: GoogleFonts.poppins(
                    color: AppColors.royalBlue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => ElevatedButton(
                  onPressed: loginController.isLoading.value
                      ? null
                      : loginController.login,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: AppColors.royalBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: loginController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Continue',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                )),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Or',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () {
                Get.snackbar('Info', 'Apple login coming soon');
              },
              icon: const Icon(Icons.apple),
              label: Text(
                'Login with Apple',
                style: GoogleFonts.poppins(),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Get.snackbar('Info', 'Google login coming soon');
              },
              icon: Image.asset('assets/images/google.png', height: 20),
              label: Text(
                'Login with Google',
                style: GoogleFonts.poppins(),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text.rich(
                TextSpan(
                  text: "Don't have an account? ",
                  style: GoogleFonts.poppins(),
                  children: [
                    TextSpan(
                      text: 'Sign up',
                      style: GoogleFonts.poppins(
                        color: AppColors.royalBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
