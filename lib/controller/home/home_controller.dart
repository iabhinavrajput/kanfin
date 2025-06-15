import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kifinserv/routes/app_routes.dart';
import 'package:flutter/material.dart';
import '../../services/jwt_service.dart';

class HomeController extends GetxController {
  final box = GetStorage();

  // Make these reactive variables
  var userName = 'User'.obs;
  var userEmail = ''.obs;
  var userRole = 'User'.obs;
  var userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Load user info when controller initializes
    _loadUserInfo();
  }

  void _loadUserInfo() {
    try {
      print('=== LOADING USER INFO ===');

      // Get token
      String? token = box.read('authToken');
      print('Token exists: ${token != null}');

      if (token != null && JwtService.isTokenValid(token)) {
        print('Token is valid, extracting info...');

        // Extract from token
        final userInfo = JwtService.getAllUserInfoFromToken(token);
        print('Info from token: $userInfo');

        // Update reactive variables
        userName.value = userInfo['name'] ?? _getStoredName();
        userEmail.value = userInfo['email'] ?? _getStoredEmail();
        userRole.value = userInfo['role'] ?? _getStoredRole();
        userId.value = userInfo['id'] ?? _getStoredId();
      } else {
        // Load from storage
        userName.value = _getStoredName();
        userEmail.value = _getStoredEmail();
        userRole.value = _getStoredRole();
        userId.value = _getStoredId();
      }

      // If still no name, extract from email
      if (userName.value == 'User' && userEmail.value.isNotEmpty) {
        userName.value = _extractNameFromEmail(userEmail.value);
        // Save for next time (but not during build)
        Future.delayed(Duration.zero, () {
          box.write('userName', userName.value);
        });
      }

      print('Final user info loaded:');
      print('Name: ${userName.value}');
      print('Email: ${userEmail.value}');
      print('Role: ${userRole.value}');
      print('ID: ${userId.value}');
      print('========================');
    } catch (e) {
      print('Error loading user info: $e');
      // Set defaults
      userName.value = 'User';
      userEmail.value = '';
      userRole.value = 'User';
      userId.value = '';
    }
  }

  String _getStoredName() {
    return box.read('userName') ?? 'User';
  }

  String _getStoredEmail() {
    return box.read('userEmail') ?? '';
  }

  String _getStoredRole() {
    return box.read('userRole') ?? 'User';
  }

  String _getStoredId() {
    return box.read('userId') ?? '';
  }

  /// Extract a readable name from email
  String _extractNameFromEmail(String email) {
    try {
      if (email.isEmpty) return 'User';

      String username = email.split('@')[0];

      // Handle common email patterns
      if (username.contains('.')) {
        // john.doe -> John Doe
        return username
            .split('.')
            .map((part) => part.isNotEmpty
                ? part[0].toUpperCase() + part.substring(1).toLowerCase()
                : '')
            .join(' ')
            .trim();
      } else if (username.contains('_')) {
        // john_doe -> John Doe
        return username
            .split('_')
            .map((part) => part.isNotEmpty
                ? part[0].toUpperCase() + part.substring(1).toLowerCase()
                : '')
            .join(' ')
            .trim();
      } else {
        // johndoe -> Johndoe
        return username.isNotEmpty
            ? username[0].toUpperCase() + username.substring(1).toLowerCase()
            : 'User';
      }
    } catch (e) {
      print('Error extracting name from email: $e');
      return 'User';
    }
  }

  // Getter methods that return reactive values
  String getUserName() => userName.value;
  String getUserEmail() => userEmail.value;
  String getUserRole() => userRole.value;
  String getUserId() => userId.value;

  String getFirstName() {
    String fullName = getUserName();
    return fullName.split(' ').first;
  }

  Map<String, String> getUserInfo() {
    return {
      'name': getUserName(),
      'email': getUserEmail(),
      'firstName': getFirstName(),
      'role': getUserRole(),
      'id': getUserId(),
    };
  }

  bool isUserLoggedIn() {
    bool isLoggedIn = box.read('isLoggedIn') ?? false;
    String? token = box.read('authToken');

    if (isLoggedIn && token != null) {
      return JwtService.isTokenValid(token);
    }

    return false;
  }

  void refreshUserInfo() {
    _loadUserInfo();
  }

  void logout() async {
    try {
      bool? confirmLogout = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      );

      if (confirmLogout == true) {
        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        await _clearAllData();
        Get.back();

        Get.snackbar(
          'Success',
          'Logged out successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offAllNamed(AppRoutes.LOGIN);
      }
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'Logout failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _clearAllData() async {
    // Clear reactive variables
    userName.value = 'User';
    userEmail.value = '';
    userRole.value = 'User';
    userId.value = '';

    // Clear storage
    box.remove('authToken');
    box.remove('isLoggedIn');
    box.remove('userEmail');
    box.remove('userName');
    box.remove('userId');
    box.remove('userRole');
    box.remove('userMobile');
    box.remove('lastLoginTime');
    box.remove('registrationToken');
    box.remove('tempToken');
    box.remove('tempUserName');
    box.remove('tempUserEmail');
    box.remove('tempUserMobile');
    box.remove('applicationData');
    box.remove('loanApplications');
    box.remove('cacheData');

    await Future.delayed(const Duration(milliseconds: 500));
  }
}
