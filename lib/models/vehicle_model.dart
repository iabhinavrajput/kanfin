class VehicleResponse {
  final String message;
  final List<VehicleData> data;

  VehicleResponse({
    required this.message,
    required this.data,
  });

  factory VehicleResponse.fromJson(Map<String, dynamic> json) {
    return VehicleResponse(
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => VehicleData.fromJson(item))
              .toList()
          : [],
    );
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
