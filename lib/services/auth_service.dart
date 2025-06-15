import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/auth_models.dart';

class AuthService {
  // Registration methods
  static Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      print('📤 Registration Request to: ${ApiConstants.register}');
      print('📤 Request Body: ${json.encode(request.toJson())}');

      final response = await http
          .post(
        Uri.parse(ApiConstants.register),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(request.toJson()),
      )
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception(
              'Request timeout. Please check your internet connection.');
        },
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return RegisterResponse.fromJson(json.decode(response.body));
      } else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Invalid registration data');
      } else if (response.statusCode == 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ??
            'Registration failed with status: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      print('❌ Network Error: $e');
      throw Exception(
          'Network connection failed. Please check your internet connection.');
    } on FormatException catch (e) {
      print('❌ JSON Parse Error: $e');
      throw Exception('Invalid server response format.');
    } catch (e) {
      print('❌ Registration Error: $e');
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Network error: registration failed');
    }
  }

  static Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequest request) async {
    try {
      print(
          '📤 OTP Verification Request to: ${ApiConstants.verifyRegistrationOtp}');

      final response = await http
          .post(
            Uri.parse(ApiConstants.verifyRegistrationOtp),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(request.toJson()),
          )
          .timeout(const Duration(seconds: 30));

      print('📥 OTP Response Status: ${response.statusCode}');
      print('📥 OTP Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return VerifyOtpResponse.fromJson(json.decode(response.body));
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'OTP verification failed');
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  static Future<ResendOtpResponse> resendOtp(ResendOtpRequest request) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConstants.resendOtp),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(request.toJson()),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return ResendOtpResponse.fromJson(json.decode(response.body));
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to resend OTP');
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  // Login methods
  static Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConstants.login),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(request.toJson()),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(json.decode(response.body));
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Login failed');
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  static Future<VerifyLoginOtpResponse> verifyLoginOtp(
      VerifyLoginOtpRequest request) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConstants.verifyOtp),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(request.toJson()),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return VerifyLoginOtpResponse.fromJson(json.decode(response.body));
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'OTP verification failed');
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }
}
