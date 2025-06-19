class AddressUpdateRequest {
  final int loanApplicationId;
  final String residentialOwnership;
  final String residentialAddress;
  final String nearestLandmark;
  final String personWithDisability;
  final String permanentAddress;

  AddressUpdateRequest({
    required this.loanApplicationId,
    required this.residentialOwnership,
    required this.residentialAddress,
    required this.nearestLandmark,
    required this.personWithDisability,
    required this.permanentAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'loan_application_id': loanApplicationId,
      'residential_ownership': residentialOwnership,
      'residential_address': residentialAddress,
      'nearest_landmark': nearestLandmark,
      'person_with_disability': personWithDisability,
      'permanent_address': permanentAddress,
    };
  }
}

class AddressUpdateResponse {
  final bool success;
  final String message;
  final UpdatedApplication? updatedApplication;

  AddressUpdateResponse({
    required this.success,
    required this.message,
    this.updatedApplication,
  });

  factory AddressUpdateResponse.fromJson(Map<String, dynamic> json) {
    return AddressUpdateResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      updatedApplication: json['updatedApplication'] != null
          ? UpdatedApplication.fromJson(json['updatedApplication'])
          : null,
    );
  }
}

class UpdatedApplication {
  final int id;
  final String residentialOwnership;
  final String residentialAddress;
  final String nearestLandmark;

  UpdatedApplication({
    required this.id,
    required this.residentialOwnership,
    required this.residentialAddress,
    required this.nearestLandmark,
  });

  factory UpdatedApplication.fromJson(Map<String, dynamic> json) {
    return UpdatedApplication(
      id: json['id'] ?? 0,
      residentialOwnership: json['residential_ownership'] ?? '',
      residentialAddress: json['residential_address'] ?? '',
      nearestLandmark: json['nearest_landmark'] ?? '',
    );
  }
}
