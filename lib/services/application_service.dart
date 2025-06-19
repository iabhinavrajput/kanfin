import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../constants/api_constants.dart';
import '../models/application_model.dart';

class ApplicationService {
  static final GetStorage _box = GetStorage();

  static Future<ApplicationResponse> submitApplication(
      ApplicationRequest request) async {
    try {
      // Get auth token
      String? token = _box.read('authToken');
      print('📤 Token: $token');
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found. Please login again.');
      }

      print(
          '📤 Application Submission Request to: ${ApiConstants.submitApplication}');
      print('📤 Request Body: ${json.encode(request.toJson())}');
      print('📤 Token: ${token.substring(0, 20)}...');

      final response = await http
          .post(
        Uri.parse(ApiConstants.submitApplication),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApplicationResponse.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('Access denied. Please contact support.');
      } else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Invalid application data.');
      } else if (response.statusCode == 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ??
            'Failed to submit application with status: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      print('❌ Network Error: $e');
      throw Exception(
          'Network connection failed. Please check your internet connection.');
    } on FormatException catch (e) {
      print('❌ JSON Parse Error: $e');
      throw Exception('Invalid server response format.');
    } catch (e) {
      print('❌ Application Submission Error: $e');
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Network error: failed to submit application');
    }
  }
}
