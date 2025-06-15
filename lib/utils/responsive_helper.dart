import 'package:flutter/material.dart';

class ResponsiveHelper {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late Orientation orientation;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;

    // Default size based on iPhone 11 Pro
    defaultSize = orientation == Orientation.landscape
        ? screenHeight * 0.024
        : screenWidth * 0.024;
  }

  // Get proportionate height
  static double getProportionateScreenHeight(double inputHeight) {
    double screenHeight = ResponsiveHelper.screenHeight;
    // 812 is the layout height that designer use
    return (inputHeight / 812.0) * screenHeight;
  }

  // Get proportionate width
  static double getProportionateScreenWidth(double inputWidth) {
    double screenWidth = ResponsiveHelper.screenWidth;
    // 375 is the layout width that designer use
    return (inputWidth / 375.0) * screenWidth;
  }

  // Get responsive font size
  static double getResponsiveFontSize(double fontSize) {
    return getProportionateScreenWidth(fontSize);
  }

  // Get responsive border radius
  static double getResponsiveBorderRadius(double radius) {
    return getProportionateScreenWidth(radius);
  }
}

// Extension for easier usage
extension ResponsiveExtension on num {
  double get w => ResponsiveHelper.getProportionateScreenWidth(toDouble());
  double get h => ResponsiveHelper.getProportionateScreenHeight(toDouble());
  double get sp => ResponsiveHelper.getResponsiveFontSize(toDouble());
  double get r => ResponsiveHelper.getResponsiveBorderRadius(toDouble());
}
