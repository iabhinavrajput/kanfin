import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kifinserv/constants/app_colors.dart';
import '../../../controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          return controller.hasInternet.value
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo/logo.png',
                      // height: 500,
                      width: 250,
                    ),
                    const SizedBox(height: 20),
                    SpinKitRing(
                      color: AppColors.royalBlue,
                      size: 50.0,
                    ),
                  ],
                )
              : const Text(
                  'No Internet Available',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                );
        }),
      ),
    );
  }
}
