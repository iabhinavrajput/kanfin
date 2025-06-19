import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kifinserv/routes/app_routes.dart';
import '../../models/auth_models.dart';
import '../../services/auth_service.dart';
import '../../services/user_storage_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();
  final box = GetStorage();

  var isLoading = false.obs;
  var currentToken = ''.obs;
  var isPasswordVisible = false.obs;

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Please enter a valid email');
      return;
    }

    isLoading.value = true;

    try {
      final request = LoginRequest(
        email: email,
        password: password,
      );

      final response = await AuthService.login(request);
      currentToken.value = response.token;

      Get.snackbar('Success', response.message);
      Get.toNamed('/login-otp-verification');
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  void verifyLoginOtp() async {
    final email = emailController.text.trim();
    final otp = otpController.text.trim();
    final token = currentToken.value;

    if (otp.isEmpty || otp.length != 6) {
      Get.snackbar('Error', 'Please enter a valid 6-digit OTP');
      return;
    }

    isLoading.value = true;

    try {
      final request = VerifyLoginOtpRequest(
        email: email,
        otp: otp,
        token: token,
      );

      final response = await AuthService.verifyLoginOtp(request);

      // Store user data using UserStorageService
      UserStorageService.storeUserData(response.user, response.token);

      // Verify storage worked
      final storedUserId = UserStorageService.getUserId();
      final isLoggedIn = UserStorageService.isLoggedIn();

      print('📋 Login Success Verification:');
      print('📋 Stored User ID: $storedUserId');
      print('📋 Is Logged In: $isLoggedIn');
      print('📋 User Data: ${UserStorageService.getUserData()?.toJson()}');

      if (!isLoggedIn || storedUserId == null) {
        throw Exception(
            'Failed to store user data properly. Please try again.');
      }

      // Clear form data
      clearFields();

      Get.snackbar(
        'Success',
        'Welcome back ${response.user.name}!',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );

      Get.offAllNamed(AppRoutes.HOME);
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    otpController.clear();
    currentToken.value = '';
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
