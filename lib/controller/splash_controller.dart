import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../routes/app_routes.dart';
import '../services/user_storage_service.dart';
import '../services/auth_service.dart';

class SplashController extends GetxController {
  final box = GetStorage();
  var hasInternet = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkConnectivity();
  }

  void checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      hasInternet.value = false;
    } else {
      hasInternet.value = true;
      Timer(const Duration(seconds: 2),
          checkLoginStatus); // Increased delay for better UX
    }
  }

  void checkLoginStatus() {
    try {
      print('🔍 Splash: Checking login status...');

      // Use UserStorageService for comprehensive authentication check
      final isLoggedIn = UserStorageService.isLoggedIn();
      final authToken = UserStorageService.getAuthToken();
      final userId = UserStorageService.getUserId();
      final userData = UserStorageService.getUserData();

      print('🔍 Splash: Login check results:');
      print('🔍 isLoggedIn: $isLoggedIn');
      print(
          '🔍 authToken: ${authToken != null ? "${authToken.substring(0, 20)}..." : "null"}');
      print('🔍 userId: $userId');
      print('🔍 userName: ${userData?.name ?? "null"}');

      if (isLoggedIn && authToken != null && userId != null) {
        print('✅ Splash: User is logged in, navigating to HOME');

        // Show welcome back message
        Future.delayed(Duration(milliseconds: 500), () {
          Get.snackbar(
            'Welcome Back',
            'Hello ${userData?.name ?? "User"}!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
            duration: Duration(seconds: 2),
          );
        });

        Get.offNamed(AppRoutes.HOME);
      } else {
        print('❌ Splash: User not logged in, navigating to LOGIN');

        // Clear any partial/invalid data
        if (!isLoggedIn) {
          UserStorageService.clearUserData();
        }

        Get.offNamed(AppRoutes.LOGIN);
      }
    } catch (e) {
      print('❌ Splash: Error checking login status: $e');

      // On error, clear data and go to login
      UserStorageService.clearUserData();
      Get.offNamed(AppRoutes.LOGIN);
    }
  }

  // Method to manually refresh connectivity
  void refreshConnectivity() {
    checkConnectivity();
  }
}
