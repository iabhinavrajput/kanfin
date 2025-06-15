import 'package:get_storage/get_storage.dart';
import '../models/application_model.dart';

class ApplicationStorageService {
  static const String _applicationsKey = 'loan_applications';
  final GetStorage _box = GetStorage();

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
}
