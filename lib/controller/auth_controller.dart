import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/auth_models.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();

  final box = GetStorage();
  var isLoading = false.obs;
  var currentToken = ''.obs;

  // Validation methods
  String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return "Name is required";
    }
    if (name.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if (name.length > 50) {
      return "Name must be less than 50 characters";
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      return "Name can only contain letters and spaces";
    }
    return null;
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Email is required";
    }
    if (!GetUtils.isEmail(email)) {
      return "Please enter a valid email address";
    }
    if (email.length > 100) {
      return "Email must be less than 100 characters";
    }
    return null;
  }

  String? validateMobile(String? mobile) {
    if (mobile == null || mobile.isEmpty) {
      return "Mobile number is required";
    }
    // Remove any non-digit characters for validation
    final cleanMobile = mobile.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanMobile.length != 10) {
      return "Mobile number must be exactly 10 digits";
    }
    if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(cleanMobile)) {
      return "Please enter a valid Indian mobile number";
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Password is required";
    }
    if (password.length < 6) {
      return "Password must be at least 6 characters long";
    }
    if (password.length > 50) {
      return "Password must be less than 50 characters";
    }
    // Check for at least one letter and one number
    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])').hasMatch(password)) {
      return "Password must contain at least one letter and one number";
    }
    return null;
  }

  String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "Please confirm your password";
    }
    if (password != confirmPassword) {
      return "Passwords do not match";
    }
    return null;
  }

  // Enhanced signup with comprehensive validation
  void signUp() async {
    final name = fullNameController.text.trim();
    final email = emailController.text.trim();
    final mobile = mobileController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    // Comprehensive validation
    final nameError = validateName(name);
    if (nameError != null) {
      Get.snackbar(
        "Validation Error",
        nameError,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final emailError = validateEmail(email);
    if (emailError != null) {
      Get.snackbar(
        "Validation Error",
        emailError,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final mobileError = validateMobile(mobile);
    if (mobileError != null) {
      Get.snackbar(
        "Validation Error",
        mobileError,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final passwordError = validatePassword(password);
    if (passwordError != null) {
      Get.snackbar(
        "Validation Error",
        passwordError,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final confirmPasswordError = validateConfirmPassword(password, confirm);
    if (confirmPasswordError != null) {
      Get.snackbar(
        "Validation Error",
        confirmPasswordError,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Clean mobile number (remove any spaces or special characters)
      final cleanMobile = mobile.replaceAll(RegExp(r'[^0-9]'), '');

      final request = RegisterRequest(
        name: name,
        email: email.toLowerCase(), // Ensure email is lowercase
        mobile: cleanMobile,
        password: password,
        confirmPassword: confirm,
      );

      print('🚀 Starting registration for: $email');
      final response = await AuthService.register(request);
      currentToken.value = response.token;

      Get.snackbar(
        "Success",
        response.message,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
        snackPosition: SnackPosition.TOP,
      );

      Get.toNamed('/otp-verification');
    } catch (e) {
      String errorMessage = e.toString().replaceAll('Exception: ', '');

      // Parse server validation errors
      if (errorMessage.contains('errors')) {
        try {
          // Extract more readable error message
          if (errorMessage.contains('Password must be at least 6 characters')) {
            errorMessage = 'Password must be at least 6 characters long';
          } else if (errorMessage.contains('Email')) {
            errorMessage = 'Please check your email format';
          } else if (errorMessage.contains('Mobile') ||
              errorMessage.contains('mobile')) {
            errorMessage = 'Please check your mobile number format';
          }
        } catch (e) {
          // Keep original error message if parsing fails
        }
      }

      Get.snackbar(
        "Registration Failed",
        errorMessage,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Enhanced OTP validation
  void verifyOtp() async {
    final email = emailController.text.trim();
    final otp = otpController.text.trim();
    final token = currentToken.value;

    if (otp.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please enter the OTP",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (otp.length != 6) {
      Get.snackbar(
        "Validation Error",
        "OTP must be exactly 6 digits",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (!RegExp(r'^[0-9]{6}$').hasMatch(otp)) {
      Get.snackbar(
        "Validation Error",
        "OTP can only contain numbers",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;

    try {
      final request = VerifyOtpRequest(
        email: email.toLowerCase(),
        otp: otp,
        token: token,
      );

      final response = await AuthService.verifyOtp(request);

      // Store auth token
      box.write('authToken', response.token);
      box.write('isLoggedIn', true);
      box.write('userEmail', email.toLowerCase());

      Get.snackbar(
        "Success",
        response.message,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
        snackPosition: SnackPosition.TOP,
      );

      Get.offAllNamed(AppRoutes.HOME);
    } catch (e) {
      Get.snackbar(
        "Verification Failed",
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resendOtp() async {
    final email = emailController.text.trim();
    final token = currentToken.value;

    if (email.isEmpty || token.isEmpty) {
      Get.snackbar(
        "Session Error",
        "Invalid session. Please register again.",
        backgroundColor: Colors.orange[100],
        colorText: Colors.orange[800],
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;

    try {
      final request = ResendOtpRequest(
        email: email.toLowerCase(),
        token: token,
      );

      final response = await AuthService.resendOtp(request);
      currentToken.value = response.token;

      Get.snackbar(
        "Success",
        response.message,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        "Resend Failed",
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
