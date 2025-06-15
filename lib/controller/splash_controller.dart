import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../routes/app_routes.dart';

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
      Timer(const Duration(seconds: 1), checkLoginStatus);
    }
  }

  void checkLoginStatus() {
    bool isLoggedIn = box.read('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Get.offNamed(AppRoutes.HOME);
    } else {
      Get.offNamed(AppRoutes.LOGIN);
    }
  }
}
