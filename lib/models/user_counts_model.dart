class UserCountsResponse {
  final bool success;
  final int userId;
  final PaginationData pagination;
  final StatusCounts statusCounts;
  final List<ApplicationData> applications;

  UserCountsResponse({
    required this.success,
    required this.userId,
    required this.pagination,
    required this.statusCounts,
    required this.applications,
  });

  factory UserCountsResponse.fromJson(Map<String, dynamic> json) {
    return UserCountsResponse(
      success: json['success'] ?? false,
      userId: json['user_id'] ?? 0,
      pagination: PaginationData.fromJson(json['pagination'] ?? {}),
      statusCounts: StatusCounts.fromJson(json['statusCounts'] ?? {}),
      applications: (json['applications'] as List?)
              ?.map((app) => ApplicationData.fromJson(app))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'user_id': userId,
      'pagination': pagination.toJson(),
      'statusCounts': statusCounts.toJson(),
      'applications': applications.map((app) => app.toJson()).toList(),
    };
  }
}

class PaginationData {
  final int totalApplications;
  final int currentPage;
  final int pageSize;
  final int totalPages;

  PaginationData({
    required this.totalApplications,
    required this.currentPage,
    required this.pageSize,
    required this.totalPages,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      totalApplications: json['totalApplications'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalApplications': totalApplications,
      'currentPage': currentPage,
      'pageSize': pageSize,
      'totalPages': totalPages,
    };
  }
}

class StatusCounts {
  final int pending;
  final int approved;
  final int rejected;
  final int disbursed;

  StatusCounts({
    required this.pending,
    required this.approved,
    required this.rejected,
    required this.disbursed,
  });

  factory StatusCounts.fromJson(Map<String, dynamic> json) {
    return StatusCounts(
      pending: json['pending'] ?? 0,
      approved: json['approved'] ?? 0,
      rejected: json['rejected'] ?? 0,
      disbursed: json['disbursed'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pending': pending,
      'approved': approved,
      'rejected': rejected,
      'disbursed': disbursed,
    };
  }

  // Helper getters
  int get totalApproved => approved + disbursed;
  int get totalPending => pending;
}

class ApplicationData {
  final int id;
  final int userId;
  final int loanTypeId;
  final int confirmedLoanType;
  final int vendorId;
  final int vehicleId;
  final String kycStatus;
  final int? cibilScore;
  final String cibilStatus;
  final String status;
  final String createdAt;
  final String updatedAt;
  final int? goldLoanDataId;
  final ApplicantData applicant;
  final VendorData vendor;
  final VehicleData vehicle;
  final LoanTypeData loanType;
  final dynamic goldLoanData;

  ApplicationData({
    required this.id,
    required this.userId,
    required this.loanTypeId,
    required this.confirmedLoanType,
    required this.vendorId,
    required this.vehicleId,
    required this.kycStatus,
    this.cibilScore,
    required this.cibilStatus,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.goldLoanDataId,
    required this.applicant,
    required this.vendor,
    required this.vehicle,
    required this.loanType,
    this.goldLoanData,
  });

  factory ApplicationData.fromJson(Map<String, dynamic> json) {
    return ApplicationData(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      loanTypeId: json['loan_type'] ?? 0,
      confirmedLoanType: json['confirmed_loan_type'] ?? 0,
      vendorId: json['vendor_id'] ?? 0,
      vehicleId: json['vehicle_id'] ?? 0,
      kycStatus: json['kyc_status'] ?? '',
      cibilScore: json['cibil_score'],
      cibilStatus: json['cibil_status'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      goldLoanDataId: json['gold_loan_data_id'],
      applicant: ApplicantData.fromJson(json['applicant'] ?? {}),
      vendor: VendorData.fromJson(json['vendor'] ?? {}),
      vehicle: VehicleData.fromJson(json['vehicle'] ?? {}),
      loanType: LoanTypeData.fromJson(json['loanType'] ?? {}),
      goldLoanData: json['goldLoanData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'loan_type': loanTypeId,
      'confirmed_loan_type': confirmedLoanType,
      'vendor_id': vendorId,
      'vehicle_id': vehicleId,
      'kyc_status': kycStatus,
      'cibil_score': cibilScore,
      'cibil_status': cibilStatus,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'gold_loan_data_id': goldLoanDataId,
      'applicant': applicant.toJson(),
      'vendor': vendor.toJson(),
      'vehicle': vehicle.toJson(),
      'loanType': loanType.toJson(),
      'goldLoanData': goldLoanData,
    };
  }

  // Helper methods
  String get loanTypeName => loanType.loanType;
  bool get isEVLoan => loanType.loanType.toUpperCase() == 'EV';
  bool get isGoldLoan => loanType.loanType.toUpperCase() == 'GOLD';
  String get statusDisplayName {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending Review';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'disbursed':
        return 'Disbursed';
      default:
        return status;
    }
  }
}

class ApplicantData {
  final int id;
  final String name;
  final String email;

  ApplicantData({
    required this.id,
    required this.name,
    required this.email,
  });

  factory ApplicantData.fromJson(Map<String, dynamic> json) {
    return ApplicantData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

class VendorData {
  final int id;
  final String companyName;

  VendorData({
    required this.id,
    required this.companyName,
  });

  factory VendorData.fromJson(Map<String, dynamic> json) {
    return VendorData(
      id: json['id'] ?? 0,
      companyName: json['company_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_name': companyName,
    };
  }
}

class VehicleData {
  final int id;
  final String vehicleName;
  final String model;
  final String registrationNumber;
  final int vendorId;
  final String createdAt;
  final String updatedAt;

  VehicleData({
    required this.id,
    required this.vehicleName,
    required this.model,
    required this.registrationNumber,
    required this.vendorId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VehicleData.fromJson(Map<String, dynamic> json) {
    return VehicleData(
      id: json['id'] ?? 0,
      vehicleName: json['vehicle_name'] ?? '',
      model: json['model'] ?? '',
      registrationNumber: json['registration_number'] ?? '',
      vendorId: json['vendor_id'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_name': vehicleName,
      'model': model,
      'registration_number': registrationNumber,
      'vendor_id': vendorId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class LoanTypeData {
  final int id;
  final String loanType;
  final String createdAt;
  final String updatedAt;

  LoanTypeData({
    required this.id,
    required this.loanType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LoanTypeData.fromJson(Map<String, dynamic> json) {
    return LoanTypeData(
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
