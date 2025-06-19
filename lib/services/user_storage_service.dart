import 'package:get_storage/get_storage.dart';
import '../models/auth_models.dart';

class UserStorageService {
  static final GetStorage _box = GetStorage();

  // Store user data and token after successful login
  static void storeUserData(UserData user, String token) {
    try {
      _box.write('authToken', token);
      _box.write('userId', user.id);
      _box.write('userName', user.name);
      _box.write('userEmail', user.email);
      _box.write('userRole', user.role);
      _box.write('otpVerified', user.otpVerified);
      _box.write('userCreatedAt', user.createdAt);
      _box.write('userUpdatedAt', user.updatedAt);
      _box.write('userData', user.toJson());
      _box.write('isLoggedIn', true); // Explicit login flag
      _box.write('loginTimestamp',
          DateTime.now().millisecondsSinceEpoch); // Track when user logged in

      print('📦 Stored User Data:');
      print('📦 User ID: ${user.id}');
      print('📦 Name: ${user.name}');
      print('📦 Email: ${user.email}');
      print('📦 Role: ${user.role}');
      print('📦 Token: ${token.substring(0, 20)}...');
      print('📦 Login Timestamp: ${DateTime.now()}');

      // Verify storage immediately
      final storedId = _box.read('userId');
      final storedUserData = _box.read('userData');
      print('📦 Verification - Stored ID: $storedId');
      print('📦 Verification - Login Flag: ${_box.read('isLoggedIn')}');
    } catch (e) {
      print('❌ Error storing user data: $e');
      throw Exception('Failed to store user data');
    }
  }

  // Get stored user data
  static UserData? getUserData() {
    try {
      final userData = _box.read('userData');
      if (userData != null) {
        final user = UserData.fromJson(Map<String, dynamic>.from(userData));
        return user;
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
    // Try multiple ways to get the user ID
    int? userId = _box.read('userId');

    if (userId == null) {
      // Fallback: try to get from userData object
      final userData = getUserData();
      if (userData != null) {
        userId = userData.id;
        // Store it directly for future use
        _box.write('userId', userId);
      }
    }

    return userId;
  }

  static String? getUserName() {
    String? name = _box.read('userName');
    if (name == null) {
      final userData = getUserData();
      if (userData != null) {
        name = userData.name;
        _box.write('userName', name);
      }
    }
    return name;
  }

  static String? getUserEmail() {
    String? email = _box.read('userEmail');
    if (email == null) {
      final userData = getUserData();
      if (userData != null) {
        email = userData.email;
        _box.write('userEmail', email);
      }
    }
    return email;
  }

  static String? getUserRole() {
    String? role = _box.read('userRole');
    if (role == null) {
      final userData = getUserData();
      if (userData != null) {
        role = userData.role;
        _box.write('userRole', role);
      }
    }
    return role;
  }

  static bool? isOtpVerified() {
    bool? verified = _box.read('otpVerified');
    if (verified == null) {
      final userData = getUserData();
      if (userData != null) {
        verified = userData.otpVerified;
        _box.write('otpVerified', verified);
      }
    }
    return verified;
  }

  // Enhanced login check
  static bool isLoggedIn() {
    try {
      final token = getAuthToken();
      final userId = getUserId();
      final isLoggedInFlag = _box.read('isLoggedIn') ?? false;
      final loginTimestamp = _box.read('loginTimestamp');

      print('📦 isLoggedIn check:');
      print('📦 - Token: ${token != null ? "Present" : "Null"}');
      print('📦 - User ID: $userId');
      print('📦 - Login Flag: $isLoggedInFlag');
      print('📦 - Login Timestamp: $loginTimestamp');

      // Check if login is valid
      final hasValidToken = token != null && token.isNotEmpty;
      final hasValidUserId = userId != null && userId > 0;
      final hasLoginFlag = isLoggedInFlag == true;

      // Optional: Check if login is not too old (e.g., 30 days)
      bool isLoginFresh = true;
      if (loginTimestamp != null) {
        final loginTime = DateTime.fromMillisecondsSinceEpoch(loginTimestamp);
        final daysSinceLogin = DateTime.now().difference(loginTime).inDays;
        isLoginFresh = daysSinceLogin < 30; // 30 days session validity
        print('📦 - Days since login: $daysSinceLogin');
        print('📦 - Login fresh: $isLoginFresh');
      }

      final isValid =
          hasValidToken && hasValidUserId && hasLoginFlag && isLoginFresh;
      print('📦 - Final result: $isValid');

      return isValid;
    } catch (e) {
      print('❌ Error checking login status: $e');
      return false;
    }
  }

  // Clear user data (logout)
  static void clearUserData() {
    try {
      _box.remove('authToken');
      _box.remove('userId');
      _box.remove('userName');
      _box.remove('userEmail');
      _box.remove('userRole');
      _box.remove('otpVerified');
      _box.remove('userCreatedAt');
      _box.remove('userUpdatedAt');
      _box.remove('userData');
      _box.remove('isLoggedIn');
      _box.remove('loginTimestamp');
      print('📦 Cleared user data (logout)');
    } catch (e) {
      print('❌ Error clearing user data: $e');
    }
  }

  // Update user information
  static void updateUserData(UserData user) {
    final currentToken = getAuthToken();
    if (currentToken != null) {
      storeUserData(user, currentToken);
    }
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
      'loginTimestamp': _box.read('loginTimestamp'),
    };
  }

  // Method to check if session is expired and handle it
  static bool isSessionExpired() {
    final loginTimestamp = _box.read('loginTimestamp');
    if (loginTimestamp == null) return true;

    final loginTime = DateTime.fromMillisecondsSinceEpoch(loginTimestamp);
    final daysSinceLogin = DateTime.now().difference(loginTime).inDays;

    return daysSinceLogin >= 30; // 30 days session validity
  }

  // Refresh session timestamp
  static void refreshSession() {
    if (isLoggedIn()) {
      _box.write('loginTimestamp', DateTime.now().millisecondsSinceEpoch);
      print('📦 Session refreshed');
    }
  }

  // Debug method to print all stored data
  static void debugPrintAllData() {
    print('🔍 DEBUG: All stored user data:');
    print('🔍 authToken: ${_box.read('authToken')}');
    print('🔍 userId: ${_box.read('userId')}');
    print('🔍 userName: ${_box.read('userName')}');
    print('🔍 userEmail: ${_box.read('userEmail')}');
    print('🔍 userRole: ${_box.read('userRole')}');
    print('🔍 otpVerified: ${_box.read('otpVerified')}');
    print('🔍 userData: ${_box.read('userData')}');
    print('🔍 isLoggedIn: ${_box.read('isLoggedIn')}');
    print('🔍 loginTimestamp: ${_box.read('loginTimestamp')}');
  }
}
