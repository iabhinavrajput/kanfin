class RegisterRequest {
  final String name;
  final String email;
  final String mobile;
  final String password;
  final String confirmPassword;
  final String? role;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.mobile,
    required this.password,
    required this.confirmPassword,
    this.role = 'User',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
      'password': password,
      'confirmPassword': confirmPassword,
      'role': role,
    };
  }
}

class RegisterResponse {
  final String message;
  final String token;

  RegisterResponse({
    required this.message,
    required this.token,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'],
      token: json['token'],
    );
  }
}

// Login Models
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class LoginResponse {
  final String message;
  final String token;

  LoginResponse({
    required this.message,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      token: json['token'],
    );
  }
}

class VerifyLoginOtpRequest {
  final String email;
  final String otp;
  final String token;

  VerifyLoginOtpRequest({
    required this.email,
    required this.otp,
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'token': token,
    };
  }
}

class VerifyLoginOtpResponse {
  final String message;
  final String token;

  VerifyLoginOtpResponse({
    required this.message,
    required this.token,
  });

  factory VerifyLoginOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyLoginOtpResponse(
      message: json['message'],
      token: json['token'],
    );
  }
}

// Registration OTP Models
class VerifyOtpRequest {
  final String email;
  final String otp;
  final String token;

  VerifyOtpRequest({
    required this.email,
    required this.otp,
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'token': token,
    };
  }
}

class VerifyOtpResponse {
  final String message;
  final String token;

  VerifyOtpResponse({
    required this.message,
    required this.token,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      message: json['message'],
      token: json['token'],
    );
  }
}

class ResendOtpRequest {
  final String email;
  final String token;

  ResendOtpRequest({
    required this.email,
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'token': token,
    };
  }
}

class ResendOtpResponse {
  final String message;
  final String token;

  ResendOtpResponse({
    required this.message,
    required this.token,
  });

  factory ResendOtpResponse.fromJson(Map<String, dynamic> json) {
    return ResendOtpResponse(
      message: json['message'],
      token: json['token'],
    );
  }
}
