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

      // The AuthService.verifyLoginOtp already stores the user data
      // So we don't need to manually store it again
      // Just verify that the data was stored correctly
      final storedUserId = UserStorageService.getUserId();
      final storedUserData = UserStorageService.getUserData();

      print('📋 Login Success - Stored User Data:');
      print('📋 User ID: $storedUserId');
      print('📋 User Data: ${storedUserData?.toJson()}');
      print('📋 Token: ${response.token.substring(0, 20)}...');

      if (storedUserId == null) {
        throw Exception('Failed to store user data. Please try again.');
      }

      Get.snackbar('Success', response.message);
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
