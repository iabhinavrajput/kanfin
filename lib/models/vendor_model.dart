class VendorResponse {
  final String message;
  final List<VendorData> data;
  final int total;

  VendorResponse({
    required this.message,
    required this.data,
    required this.total,
  });

  factory VendorResponse.fromJson(Map<String, dynamic> json) {
    return VendorResponse(
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => VendorData.fromJson(item))
              .toList()
          : [],
      total: json['total'] ?? 0,
    );
  }
}

class VendorData {
  final int id;
  final int userId;
  final int loanTypeId;
  final String companyName;
  final String panNumber;
  final String aadharNumber;
  final String cinNumber;
  final String location;
  final String createdAt;
  final String updatedAt;
  final VendorUser user;
  final LoanTypeInfo loanType;

  VendorData({
    required this.id,
    required this.userId,
    required this.loanTypeId,
    required this.companyName,
    required this.panNumber,
    required this.aadharNumber,
    required this.cinNumber,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.loanType,
  });

  factory VendorData.fromJson(Map<String, dynamic> json) {
    return VendorData(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      loanTypeId: json['loan_type_id'] ?? 0,
      companyName: json['company_name'] ?? '',
      panNumber: json['pan_number'] ?? '',
      aadharNumber: json['aadhar_number'] ?? '',
      cinNumber: json['cin_number'] ?? '',
      location: json['location'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      user: VendorUser.fromJson(json['user'] ?? {}),
      loanType: LoanTypeInfo.fromJson(json['loanType'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'loan_type_id': loanTypeId,
      'company_name': companyName,
      'pan_number': panNumber,
      'aadhar_number': aadharNumber,
      'cin_number': cinNumber,
      'location': location,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'user': user.toJson(),
      'loanType': loanType.toJson(),
    };
  }
}

class VendorUser {
  final String name;
  final String email;
  final String mobile;

  VendorUser({
    required this.name,
    required this.email,
    required this.mobile,
  });

  factory VendorUser.fromJson(Map<String, dynamic> json) {
    return VendorUser(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
    };
  }
}

class LoanTypeInfo {
  final int id;
  final String loanType;
  final String createdAt;
  final String updatedAt;

  LoanTypeInfo({
    required this.id,
    required this.loanType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LoanTypeInfo.fromJson(Map<String, dynamic> json) {
    return LoanTypeInfo(
      id: json['id'] ?? 0,
      loanType: json['loan_type'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loan_type': loanType,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
