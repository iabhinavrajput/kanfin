import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kifinserv/constants/app_colors.dart';
import 'package:kifinserv/models/application_model.dart';
import 'package:kifinserv/services/application_storage_service.dart';


class TrackApplicationsScreen extends StatefulWidget {
  const TrackApplicationsScreen({super.key});

  @override
  State<TrackApplicationsScreen> createState() => _TrackApplicationsScreenState();
}

class _TrackApplicationsScreenState extends State<TrackApplicationsScreen> {
  final ApplicationStorageService _storageService = ApplicationStorageService();
  List<LoanApplication> applications = [];
  Map<String, int> stats = {};
  bool isLoading = true;
  String selectedFilter = 'all';

  final List<Map<String, dynamic>> filterOptions = [
    {'value': 'all', 'label': 'All Applications', 'icon': Icons.list},
    {'value': 'submitted', 'label': 'Submitted', 'icon': Icons.send},
    {'value': 'under_review', 'label': 'Under Review', 'icon': Icons.hourglass_empty},
    {'value': 'approved', 'label': 'Approved', 'icon': Icons.check_circle},
    {'value': 'disbursed', 'label': 'Disbursed', 'icon': Icons.account_balance_wallet},
    {'value': 'rejected', 'label': 'Rejected', 'icon': Icons.cancel},
  ];

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() => isLoading = true);
    
    try {
      final allApps = await _storageService.getAllApplications();
      final appStats = await _storageService.getApplicationStats();
      
      setState(() {
        applications = selectedFilter == 'all' 
            ? allApps 
            : allApps.where((app) => app.status == selectedFilter).toList();
        stats = appStats;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar('Error', 'Failed to load applications');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Track Applications',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: screenWidth * 0.048,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.royalBlue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: screenWidth * 0.064),
          onPressed: () => Get.back(),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) async {
              if (value == 'add_sample') {
                await _storageService.addSampleData();
                _loadApplications();
                Get.snackbar('Success', 'Sample data added');
              } else if (value == 'clear_all') {
                _showClearConfirmation();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'add_sample',
                child: Text('Add Sample Data'),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Text('Clear All Data'),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadApplications,
        child: Column(
          children: [
            // Header with Stats
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.royalBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(screenWidth * 0.08),
                  bottomRight: Radius.circular(screenWidth * 0.08),
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.064,
                0,
                screenWidth * 0.064,
                screenHeight * 0.03,
              ),
              child: Column(
                children: [
                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard('Total', stats['total'] ?? 0, Icons.apps, Colors.white, screenWidth),
                      _buildStatCard('Pending', (stats['submitted'] ?? 0) + (stats['under_review'] ?? 0), Icons.pending, Colors.orange, screenWidth),
                      _buildStatCard('Approved', (stats['approved'] ?? 0) + (stats['disbursed'] ?? 0), Icons.check_circle, Colors.green, screenWidth),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  
                  // Filter Dropdown
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedFilter,
                        dropdownColor: AppColors.royalBlue,
                        style: GoogleFonts.poppins(color: Colors.white),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        onChanged: (value) {
                          setState(() {
                            selectedFilter = value!;
                          });
                          _loadApplications();
                        },
                        items: filterOptions.map((option) {
                          return DropdownMenuItem<String>(
                            value: option['value'],
                            child: Row(
                              children: [
                                Icon(option['icon'], color: Colors.white, size: screenWidth * 0.05),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  option['label'],
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.037,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Applications List
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : applications.isEmpty
                      ? _buildEmptyState(screenWidth, screenHeight)
                      : ListView.builder(
                          padding: EdgeInsets.all(screenWidth * 0.064),
                          itemCount: applications.length,
                          itemBuilder: (context, index) {
                            final application = applications[index];
                            return _buildApplicationCard(application, screenWidth, screenHeight);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon, Color color, double screenWidth) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.025),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: screenWidth * 0.06),
        ),
        SizedBox(height: screenWidth * 0.02),
        Text(
          count.toString(),
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.053,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.032,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildApplicationCard(LoanApplication application, double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.015),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        border: Border.all(color: application.statusColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: screenWidth * 0.02,
            offset: Offset(0, screenHeight * 0.005),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application.loanType,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.043,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        'ID: ${application.id}',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.032,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.032,
                    vertical: screenHeight * 0.008,
                  ),
                  decoration: BoxDecoration(
                    color: application.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        application.statusIcon,
                        size: screenWidth * 0.04,
                        color: application.statusColor,
                      ),
                      SizedBox(width: screenWidth * 0.015),
                      Text(
                        application.statusDisplayName,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.032,
                          fontWeight: FontWeight.w600,
                          color: application.statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.015),

            // Application Details
            if (application.loanAmount != null) ...[
              Row(
                children: [
                  Icon(Icons.currency_rupee, color: Colors.grey[600], size: screenWidth * 0.04),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    'Amount: ₹${application.loanAmount!.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.037,
                      color: Colors.grey[700],
                    ),
                  ),
                  if (application.interestRate != null) ...[
                    SizedBox(width: screenWidth * 0.04),
                    Text(
                      '@ ${application.interestRate}%',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.037,
                        color: Colors.green[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
            ],

            // Submission Date
            Row(
              children: [
                Icon(Icons.schedule, color: Colors.grey[600], size: screenWidth * 0.04),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  'Submitted: ${_formatDate(application.submissionDate)}',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.015),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showApplicationDetails(application),
                    icon: Icon(Icons.visibility, size: screenWidth * 0.04),
                    label: Text('View Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.royalBlue,
                      side: BorderSide(color: AppColors.royalBlue),
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.012),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                if (application.status == 'submitted' || application.status == 'under_review') ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _simulateStatusUpdate(application),
                      icon: Icon(Icons.update, size: screenWidth * 0.04),
                      label: Text('Update Status'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: application.statusColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.012),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(double screenWidth, double screenHeight) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: screenWidth * 0.2,
            color: Colors.grey[400],
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            selectedFilter == 'all' 
                ? 'No applications found'
                : 'No ${selectedFilter.replaceAll('_', ' ')} applications',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.048,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            selectedFilter == 'all'
                ? 'Start by applying for a loan'
                : 'Try changing the filter or apply for a new loan',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.037,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.03),
          ElevatedButton.icon(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.add),
            label: const Text('Apply for Loan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.royalBlue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.08,
                vertical: screenHeight * 0.015,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showApplicationDetails(LoanApplication application) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  Text(
                    'Application Details',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  _buildDetailRow('Application ID', application.id),
                  _buildDetailRow('Loan Type', application.loanType),
                  _buildDetailRow('Applicant Name', application.applicantName),
                  _buildDetailRow('Email', application.email),
                  _buildDetailRow('Mobile', application.mobile),
                  _buildDetailRow('Address', application.address),
                  _buildDetailRow('Status', application.statusDisplayName),
                  _buildDetailRow('Submission Date', _formatDate(application.submissionDate)),
                  
                  if (application.loanAmount != null)
                    _buildDetailRow('Loan Amount', '₹${application.loanAmount!.toStringAsFixed(0)}'),
                  
                  if (application.interestRate != null)
                    _buildDetailRow('Interest Rate', '${application.interestRate}%'),
                  
                  const SizedBox(height: 20),
                  
                  Text(
                    'Loan Details',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  ...application.loanDetails.entries.map((entry) =>
                    _buildDetailRow(entry.key.toUpperCase(), entry.value?.toString() ?? 'N/A')
                  ).toList(),
                  
                  const SizedBox(height: 20),
                  
                  Text(
                    'References',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  if (application.references['reference1'] != null) ...[
                    Text('Reference 1:', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    _buildDetailRow('Name', application.references['reference1']['name']),
                    _buildDetailRow('Phone', application.references['reference1']['phone']),
                    _buildDetailRow('Relation', application.references['reference1']['relation']),
                    const SizedBox(height: 10),
                  ],
                  
                  if (application.references['reference2'] != null) ...[
                    Text('Reference 2:', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    _buildDetailRow('Name', application.references['reference2']['name']),
                    _buildDetailRow('Phone', application.references['reference2']['phone']),
                    _buildDetailRow('Relation', application.references['reference2']['relation']),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _simulateStatusUpdate(LoanApplication application) async {
    String newStatus;
    switch (application.status) {
      case 'submitted':
        newStatus = 'under_review';
        break;
      case 'under_review':
        newStatus = 'approved';
        break;
      default:
        return;
    }

    await _storageService.updateApplicationStatus(
      application.id,
      newStatus,
      reviewDate: newStatus == 'under_review' ? DateTime.now() : application.reviewDate,
      approvalDate: newStatus == 'approved' ? DateTime.now() : null,
    );

    Get.snackbar(
      'Status Updated',
      'Application ${application.id} is now ${newStatus.replaceAll('_', ' ')}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    _loadApplications();
  }

  void _showClearConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text('Are you sure you want to delete all applications? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _storageService.clearAllApplications();
              Get.back();
              _loadApplications();
              Get.snackbar('Success', 'All applications cleared');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}