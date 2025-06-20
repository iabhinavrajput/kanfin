import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kifinserv/constants/app_colors.dart';
import 'package:kifinserv/models/user_counts_model.dart';
import 'package:kifinserv/services/application_service.dart';

class TrackApplicationsScreen extends StatefulWidget {
  const TrackApplicationsScreen({super.key});

  @override
  State<TrackApplicationsScreen> createState() =>
      _TrackApplicationsScreenState();
}

class _TrackApplicationsScreenState extends State<TrackApplicationsScreen> {
  UserCountsResponse? userCountsResponse;
  List<ApplicationData> applications = [];
  Map<String, int> stats = {};
  bool isLoading = true;
  String selectedFilter = 'all';

  final List<Map<String, dynamic>> filterOptions = [
    {'value': 'all', 'label': 'All Applications', 'icon': Icons.list},
    {'value': 'pending', 'label': 'Pending', 'icon': Icons.hourglass_empty},
    {'value': 'approved', 'label': 'Approved', 'icon': Icons.check_circle},
    {
      'value': 'disbursed',
      'label': 'Disbursed',
      'icon': Icons.account_balance_wallet
    },
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
      final response = await ApplicationService.getUserCounts();

      setState(() {
        userCountsResponse = response;
        applications = selectedFilter == 'all'
            ? response.applications
            : response.applications
                .where((app) => app.status == selectedFilter)
                .toList();

        // Calculate stats from the response
        stats = {
          'total': response.pagination.totalApplications,
          'pending': response.statusCounts.pending,
          'approved': response.statusCounts.approved,
          'rejected': response.statusCounts.rejected,
          'disbursed': response.statusCounts.disbursed,
        };
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
          icon: Icon(Icons.arrow_back,
              color: Colors.white, size: screenWidth * 0.064),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadApplications,
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
                      _buildStatCard('Total', stats['total'] ?? 0, Icons.apps,
                          Colors.white, screenWidth),
                      _buildStatCard('Pending', stats['pending'] ?? 0,
                          Icons.pending, Colors.orange, screenWidth),
                      _buildStatCard(
                          'Approved',
                          (stats['approved'] ?? 0) + (stats['disbursed'] ?? 0),
                          Icons.check_circle,
                          Colors.green,
                          screenWidth),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Filter Dropdown
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedFilter,
                        dropdownColor: AppColors.royalBlue,
                        style: GoogleFonts.poppins(color: Colors.white),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
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
                                Icon(option['icon'],
                                    color: Colors.white,
                                    size: screenWidth * 0.05),
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
                            return _buildApplicationCard(
                                application, screenWidth, screenHeight);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, int count, IconData icon, Color color, double screenWidth) {
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

  Widget _buildApplicationCard(
      ApplicationData application, double screenWidth, double screenHeight) {
    Color statusColor = _getStatusColor(application.status);
    IconData statusIcon = _getStatusIcon(application.status);

    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.015),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        border: Border.all(color: statusColor.withOpacity(0.3)),
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
                        application.loanTypeName,
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
                      Text(
                        'Vendor: ${application.vendor.companyName}',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.03,
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
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusIcon,
                        size: screenWidth * 0.04,
                        color: statusColor,
                      ),
                      SizedBox(width: screenWidth * 0.015),
                      Text(
                        application.statusDisplayName,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.032,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.015),

            // Application Details
            Row(
              children: [
                Icon(Icons.badge,
                    color: Colors.grey[600], size: screenWidth * 0.04),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  'KYC: ${application.kycStatus.toUpperCase()}',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.037,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                Icon(Icons.account_balance,
                    color: Colors.grey[600], size: screenWidth * 0.04),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  'CIBIL: ${application.cibilStatus.replaceAll('_', ' ').toUpperCase()}',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.037,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),

            // Submission Date
            Row(
              children: [
                Icon(Icons.schedule,
                    color: Colors.grey[600], size: screenWidth * 0.04),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  'Created: ${_formatApiDate(application.createdAt)}',
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
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.012),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                if (application.status == 'pending') ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          Get.snackbar('Info', 'Status updates coming soon!'),
                      icon: Icon(Icons.info, size: screenWidth * 0.04),
                      label: Text('Track Status'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: statusColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.012),
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

  void _showApplicationDetails(ApplicationData application) {
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
                  _buildDetailRow('Application ID', application.id.toString()),
                  _buildDetailRow('Loan Type', application.loanTypeName),
                  _buildDetailRow('Applicant Name', application.applicant.name),
                  _buildDetailRow('Email', application.applicant.email),
                  _buildDetailRow('Vendor', application.vendor.companyName),
                  _buildDetailRow('Vehicle',
                      '${application.vehicle.vehicleName} (${application.vehicle.model})'),
                  _buildDetailRow(
                      'Registration', application.vehicle.registrationNumber),
                  _buildDetailRow('Status', application.statusDisplayName),
                  _buildDetailRow(
                      'KYC Status', application.kycStatus.toUpperCase()),
                  _buildDetailRow(
                      'CIBIL Status',
                      application.cibilStatus
                          .replaceAll('_', ' ')
                          .toUpperCase()),
                  if (application.cibilScore != null)
                    _buildDetailRow(
                        'CIBIL Score', application.cibilScore.toString()),
                  _buildDetailRow(
                      'Created Date', _formatApiDate(application.createdAt)),
                  _buildDetailRow(
                      'Updated Date', _formatApiDate(application.updatedAt)),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'disbursed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'disbursed':
        return Icons.account_balance;
      default:
        return Icons.info;
    }
  }

  String _formatApiDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
