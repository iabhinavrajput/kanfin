import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class JwtService {
  /// Decode JWT token and extract user information
  static Map<String, dynamic>? decodeToken(String token) {
    try {
      if (token.isEmpty) return null;

      // Check if token is expired
      if (JwtDecoder.isExpired(token)) {
        print('Token is expired');
        return null;
      }

      // Decode the token
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken;
    } catch (e) {
      print('Error decoding token: $e');
      return null;
    }
  }

  /// Extract user name from token - try multiple possible field names
  static String? getUserNameFromToken(String token) {
    try {
      final decodedToken = decodeToken(token);
      if (decodedToken == null) return null;

      // Print all available fields for debugging
      print('=== ALL TOKEN FIELDS ===');
      decodedToken.forEach((key, value) {
        print('$key: $value');
      });
      print('========================');

      // Try different possible fields for name in order of preference
      String? name = decodedToken['name'] ??
          decodedToken['full_name'] ??
          decodedToken['fullName'] ??
          decodedToken['display_name'] ??
          decodedToken['displayName'] ??
          decodedToken['username'] ??
          decodedToken['user_name'] ??
          decodedToken['firstName'] ??
          decodedToken['first_name'] ??
          decodedToken['userName'] ??
          decodedToken['user']?['name'] ?? // If user is nested object
          decodedToken['user']?['full_name'] ??
          decodedToken['user']?['firstName'];

      print('Extracted name from token: $name');
      return name;
    } catch (e) {
      print('Error extracting name from token: $e');
      return null;
    }
  }

  /// Extract user email from token
  static String? getUserEmailFromToken(String token) {
    try {
      final decodedToken = decodeToken(token);
      if (decodedToken == null) return null;

      String? email = decodedToken['email'] ??
          decodedToken['user_email'] ??
          decodedToken['userEmail'] ??
          decodedToken['user']?['email'];

      print('Extracted email from token: $email');
      return email;
    } catch (e) {
      print('Error extracting email from token: $e');
      return null;
    }
  }

  /// Extract user ID from token
  static String? getUserIdFromToken(String token) {
    try {
      final decodedToken = decodeToken(token);
      if (decodedToken == null) return null;

      String? id = decodedToken['id']?.toString() ??
          decodedToken['user_id']?.toString() ??
          decodedToken['userId']?.toString() ??
          decodedToken['sub']?.toString() ??
          decodedToken['user']?['id']?.toString();

      print('Extracted ID from token: $id');
      return id;
    } catch (e) {
      print('Error extracting user ID from token: $e');
      return null;
    }
  }

  /// Extract user role from token
  static String? getUserRoleFromToken(String token) {
    try {
      final decodedToken = decodeToken(token);
      if (decodedToken == null) return null;

      String? role = decodedToken['role'] ??
          decodedToken['user_role'] ??
          decodedToken['userRole'] ??
          decodedToken['roles']?.first ?? // If roles is an array
          decodedToken['user']?['role'];

      print('Extracted role from token: $role');
      return role;
    } catch (e) {
      print('Error extracting role from token: $e');
      return null;
    }
  }

  /// Extract all user information from token
  static Map<String, String?> getAllUserInfoFromToken(String token) {
    print('=== EXTRACTING USER INFO FROM TOKEN ===');
    final result = {
      'name': getUserNameFromToken(token),
      'email': getUserEmailFromToken(token),
      'id': getUserIdFromToken(token),
      'role': getUserRoleFromToken(token),
    };
    print('Final extracted info: $result');
    print('=====================================');
    return result;
  }

  /// Check if token is valid and not expired
  static bool isTokenValid(String token) {
    try {
      if (token.isEmpty) return false;
      return !JwtDecoder.isExpired(token);
    } catch (e) {
      return false;
    }
  }

  /// Get token expiration date
  static DateTime? getTokenExpirationDate(String token) {
    try {
      return JwtDecoder.getExpirationDate(token);
    } catch (e) {
      return null;
    }
  }

  /// Debug: Print all token contents with better formatting
  static void debugPrintToken(String token) {
    try {
      final decoded = decodeToken(token);
      if (decoded != null) {
        print('=== JWT TOKEN CONTENTS ===');
        print('Raw token: ${token.substring(0, 50)}...');
        decoded.forEach((key, value) {
          if (value is Map) {
            print('$key: (nested object)');
            value.forEach((nestedKey, nestedValue) {
              print('  $nestedKey: $nestedValue');
            });
          } else {
            print('$key: $value');
          }
        });
        print('========================');
      }
    } catch (e) {
      print('Error debugging token: $e');
    }
  }
}
