import 'package:get_storage/get_storage.dart';
import '../models/application_model.dart';
import '../models/loan_types_model.dart';
import '../models/vendor_model.dart';
import '../models/vehicle_model.dart';

class ApplicationStorageService {
  static const String _applicationsKey = 'loan_applications';
  static final GetStorage _box = GetStorage();

  // Save a new application
  Future<void> saveApplication(LoanApplication application) async {
    final applications = await getAllApplications();
    applications.add(application);
    await _saveApplications(applications);
  }

  // Get all applications
  Future<List<LoanApplication>> getAllApplications() async {
    final data = _box.read<List>(_applicationsKey) ?? [];
    return data
        .map(
            (json) => LoanApplication.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  // Get applications by status
  Future<List<LoanApplication>> getApplicationsByStatus(String status) async {
    final applications = await getAllApplications();
    return applications.where((app) => app.status == status).toList();
  }

  // Update application status
  Future<void> updateApplicationStatus(
    String applicationId,
    String newStatus, {
    DateTime? reviewDate,
    DateTime? approvalDate,
    double? loanAmount,
    double? interestRate,
  }) async {
    final applications = await getAllApplications();
    final index = applications.indexWhere((app) => app.id == applicationId);

    if (index != -1) {
      applications[index] = applications[index].copyWith(
        status: newStatus,
        reviewDate: reviewDate,
        approvalDate: approvalDate,
        loanAmount: loanAmount,
        interestRate: interestRate,
      );
      await _saveApplications(applications);
    }
  }

  // Get application by ID
  Future<LoanApplication?> getApplicationById(String id) async {
    final applications = await getAllApplications();
    try {
      return applications.firstWhere((app) => app.id == id);
    } catch (e) {
      return null;
    }
  }

  // Delete application
  Future<void> deleteApplication(String applicationId) async {
    final applications = await getAllApplications();
    applications.removeWhere((app) => app.id == applicationId);
    await _saveApplications(applications);
  }

  // Get application statistics
  Future<Map<String, int>> getApplicationStats() async {
    final applications = await getAllApplications();
    return {
      'total': applications.length,
      'submitted':
          applications.where((app) => app.status == 'submitted').length,
      'under_review':
          applications.where((app) => app.status == 'under_review').length,
      'approved': applications.where((app) => app.status == 'approved').length,
      'disbursed':
          applications.where((app) => app.status == 'disbursed').length,
      'rejected': applications.where((app) => app.status == 'rejected').length,
    };
  }

  // Private method to save applications
  Future<void> _saveApplications(List<LoanApplication> applications) async {
    final jsonList = applications.map((app) => app.toJson()).toList();
    await _box.write(_applicationsKey, jsonList);
  }

  // Clear all applications (for testing)
  Future<void> clearAllApplications() async {
    await _box.remove(_applicationsKey);
  }

  // Add sample data for testing
  Future<void> addSampleData() async {
    final sampleApplications = [
      LoanApplication(
        id: 'app_001',
        loanType: 'EV Loan',
        status: 'disbursed',
        submissionDate: DateTime.now().subtract(const Duration(days: 30)),
        applicantName: 'John Doe',
        email: 'john@example.com',
        mobile: '9876543210',
        address: '123 Main St, City',
        loanDetails: {
          'vendor': 'Mahindra Treo',
          'vehicle': 'Treo Zor',
          'amount': 150000,
        },
        references: {
          'reference1': {
            'name': 'Jane Smith',
            'phone': '9876543211',
            'relation': 'Friend'
          },
          'reference2': {
            'name': 'Bob Wilson',
            'phone': '9876543212',
            'relation': 'Colleague'
          },
        },
        documents: {
          'bankStatement': 'uploaded',
          'electricityBill': 'uploaded',
        },
        reviewDate: DateTime.now().subtract(const Duration(days: 25)),
        approvalDate: DateTime.now().subtract(const Duration(days: 20)),
        loanAmount: 150000,
        interestRate: 8.5,
      ),
      LoanApplication(
        id: 'app_002',
        loanType: 'Gold Loan',
        status: 'approved',
        submissionDate: DateTime.now().subtract(const Duration(days: 15)),
        applicantName: 'Alice Johnson',
        email: 'alice@example.com',
        mobile: '9876543213',
        address: '456 Oak Ave, Town',
        loanDetails: {
          'vendor': 'Local Jeweler',
          'item': 'Gold Necklace',
          'weight': '50g',
          'purity': '22K',
          'amount': 80000,
        },
        references: {
          'reference1': {
            'name': 'Mike Brown',
            'phone': '9876543214',
            'relation': 'Brother'
          },
          'reference2': {
            'name': 'Lisa Davis',
            'phone': '9876543215',
            'relation': 'Sister'
          },
        },
        documents: {
          'goldCertificate': 'uploaded',
          'identityProof': 'uploaded',
        },
        reviewDate: DateTime.now().subtract(const Duration(days: 10)),
        approvalDate: DateTime.now().subtract(const Duration(days: 5)),
        loanAmount: 80000,
        interestRate: 10.0,
      ),
      LoanApplication(
        id: 'app_003',
        loanType: 'EV Loan',
        status: 'under_review',
        submissionDate: DateTime.now().subtract(const Duration(days: 5)),
        applicantName: 'Robert Garcia',
        email: 'robert@example.com',
        mobile: '9876543216',
        address: '789 Pine Rd, Village',
        loanDetails: {
          'vendor': 'Bajaj RE',
          'vehicle': 'RE Maxima',
          'amount': 120000,
        },
        references: {
          'reference1': {
            'name': 'Sarah Wilson',
            'phone': '9876543217',
            'relation': 'Friend'
          },
          'reference2': {
            'name': 'Tom Anderson',
            'phone': '9876543218',
            'relation': 'Neighbor'
          },
        },
        documents: {
          'bankStatement': 'uploaded',
          'electricityBill': 'uploaded',
        },
        reviewDate: DateTime.now().subtract(const Duration(days: 2)),
        loanAmount: 120000,
        interestRate: 9.0,
      ),
    ];

    for (final app in sampleApplications) {
      await saveApplication(app);
    }
  }

  // Application ID Storage
  static void storeApplicationId(int applicationId) {
    _box.write('applicationId', applicationId);
    print('📦 Stored Application ID: $applicationId');
  }

  static int? getApplicationId() {
    return _box.read('applicationId');
  }

  // Loan Type Storage
  static void storeSelectedLoanType(LoanTypeData loanType) {
    _box.write('selectedLoanTypeId', loanType.id);
    _box.write('selectedLoanType', loanType.loanType);
    _box.write('selectedLoanTypeData', loanType.toJson());
    print('📦 Stored Loan Type: ${loanType.loanType} (ID: ${loanType.id})');
  }

  static LoanTypeData? getSelectedLoanType() {
    try {
      final loanTypeData = _box.read('selectedLoanTypeData');
      if (loanTypeData != null) {
        return LoanTypeData.fromJson(Map<String, dynamic>.from(loanTypeData));
      }
      return null;
    } catch (e) {
      print('❌ Error getting loan type: $e');
      return null;
    }
  }

  static int? getSelectedLoanTypeId() {
    return _box.read('selectedLoanTypeId');
  }

  static String? getSelectedLoanTypeString() {
    return _box.read('selectedLoanType');
  }

  // Vendor Storage
  static void storeSelectedVendor(VendorData vendor) {
    _box.write('selectedVendorId', vendor.id);
    _box.write('selectedVendorData', vendor.toJson());
    print('📦 Stored Vendor: ${vendor.companyName} (ID: ${vendor.id})');
  }

  static VendorData? getSelectedVendor() {
    try {
      final vendorData = _box.read('selectedVendorData');
      if (vendorData != null) {
        return VendorData.fromJson(Map<String, dynamic>.from(vendorData));
      }
      return null;
    } catch (e) {
      print('❌ Error getting vendor: $e');
      return null;
    }
  }

  static int? getSelectedVendorId() {
    return _box.read('selectedVendorId');
  }

  // Vehicle Storage
  static void storeSelectedVehicle(VehicleData vehicle) {
    _box.write('selectedVehicleId', vehicle.id);
    _box.write('selectedVehicleData', vehicle.toJson());
    print('📦 Stored Vehicle: ${vehicle.vehicleName} (ID: ${vehicle.id})');
  }

  static VehicleData? getSelectedVehicle() {
    try {
      final vehicleData = _box.read('selectedVehicleData');
      if (vehicleData != null) {
        return VehicleData.fromJson(Map<String, dynamic>.from(vehicleData));
      }
      return null;
    } catch (e) {
      print('❌ Error getting vehicle: $e');
      return null;
    }
  }

  static int? getSelectedVehicleId() {
    return _box.read('selectedVehicleId');
  }

  // Clear application data
  static void clearApplicationData() {
    _box.remove('selectedLoanTypeId');
    _box.remove('selectedLoanType');
    _box.remove('selectedLoanTypeData');
    _box.remove('selectedVendorId');
    _box.remove('selectedVendorData');
    _box.remove('selectedVehicleId');
    _box.remove('selectedVehicleData');
    _box.remove('applicationId');
    print('📦 Cleared application data');
  }

  // Get application summary
  static Map<String, dynamic> getApplicationSummary() {
    return {
      'loanType': getSelectedLoanType(),
      'vendor': getSelectedVendor(),
      'vehicle': getSelectedVehicle(),
      'loanTypeId': getSelectedLoanTypeId(),
      'vendorId': getSelectedVendorId(),
      'vehicleId': getSelectedVehicleId(),
      'applicationId': getApplicationId(),
    };
  }
}
