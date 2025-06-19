import 'package:get_storage/get_storage.dart';
import '../models/auth_models.dart';

class UserStorageService {
  static final GetStorage _box = GetStorage();

  // Store user data and token after successful login
  static void storeUserData(UserData user, String token) {
    _box.write('authToken', token);
    _box.write('userId', user.id);
    _box.write('userName', user.name);
    _box.write('userEmail', user.email);
    _box.write('userRole', user.role);
    _box.write('otpVerified', user.otpVerified);
    _box.write('userCreatedAt', user.createdAt);
    _box.write('userUpdatedAt', user.updatedAt);
    _box.write('userData', user.toJson());

    print('📦 Stored User Data:');
    print('📦 User ID: ${user.id}');
    print('📦 Name: ${user.name}');
    print('📦 Email: ${user.email}');
    print('📦 Role: ${user.role}');
    print('📦 Token: ${token.substring(0, 20)}...');
  }

  // Get stored user data
  static UserData? getUserData() {
    try {
      final userData = _box.read('userData');
      if (userData != null) {
        return UserData.fromJson(Map<String, dynamic>.from(userData));
      }
      return null;
    } catch (e) {
      print('❌ Error getting user data: $e');
      return null;
    }
  }

  // Get specific user information
  static String? getAuthToken() {
    return _box.read('authToken');
  }

  static int? getUserId() {
    return _box.read('userId');
  }

  static String? getUserName() {
    return _box.read('userName');
  }

  static String? getUserEmail() {
    return _box.read('userEmail');
  }

  static String? getUserRole() {
    return _box.read('userRole');
  }

  static bool? isOtpVerified() {
    return _box.read('otpVerified');
  }

  // Check if user is logged in
  static bool isLoggedIn() {
    final token = getAuthToken();
    final userId = getUserId();
    return token != null && token.isNotEmpty && userId != null;
  }

  // Clear user data (logout)
  static void clearUserData() {
    _box.remove('authToken');
    _box.remove('userId');
    _box.remove('userName');
    _box.remove('userEmail');
    _box.remove('userRole');
    _box.remove('otpVerified');
    _box.remove('userCreatedAt');
    _box.remove('userUpdatedAt');
    _box.remove('userData');
    print('📦 Cleared user data (logout)');
  }

  // Update user information
  static void updateUserData(UserData user) {
    storeUserData(user, getAuthToken() ?? '');
  }

  // Get user summary for display
  static Map<String, dynamic> getUserSummary() {
    return {
      'user': getUserData(),
      'isLoggedIn': isLoggedIn(),
      'token': getAuthToken(),
      'userId': getUserId(),
      'name': getUserName(),
      'email': getUserEmail(),
      'role': getUserRole(),
      'otpVerified': isOtpVerified(),
    };
  }
}
