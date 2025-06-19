class ApiConstants {
  static const String baseUrl = 'https://admin.kanfin.com/api';
  // Authentication endpoints
  static const String login = '$baseUrl/auth/login';
  static const String verifyOtp = '$baseUrl/auth/verify-login-otp';

  // Registration endpoints
  static const String register = '$baseUrl/auth/register';
  static const String verifyRegistrationOtp = '$baseUrl/auth/verify-otp';
  static const String resendOtp = '$baseUrl/auth/resend-otp';

  // Loan endpoints
  static const String loanTypes = '$baseUrl/auth/loan-types';

  // Vendor endpoints
  static const String vendors = '$baseUrl/auth/vendor';
  static const String vendorVehicles = '$baseUrl/auth/vendors';

  // Application endpoints
  static const String submitApplication = '$baseUrl/auth/submit-application';
}
