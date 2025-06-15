import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kifinserv/constants/app_colors.dart';

class ApplicationReviewScreen extends StatefulWidget {
  const ApplicationReviewScreen({super.key});

  @override
  State<ApplicationReviewScreen> createState() =>
      _ApplicationReviewScreenState();
}

class _ApplicationReviewScreenState extends State<ApplicationReviewScreen> {
  bool isSubmitting = false;

  // Get all the data passed from previous screens
  Map<String, dynamic> get applicationData => Get.arguments ?? {};

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Review Application',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: screenWidth * 0.048,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.white, size: screenWidth * 0.064),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.green,
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
                Icon(
                  Icons.assignment_turned_in,
                  size: screenWidth * 0.16,
                  color: Colors.white,
                ),
                SizedBox(height: screenHeight * 0.015),
                Text(
                  'Review Your Application',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  'Please review all details before submitting',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Application Details
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(screenWidth * 0.064),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Loan Type Section
                  _buildSectionCard(
                    screenWidth,
                    screenHeight,
                    'Loan Type',
                    Icons.account_balance,
                    Colors.blue,
                    [
                      _buildDetailRow('Type',
                          applicationData['loanType'] ?? 'Not Selected'),
                      if (applicationData['loanType'] == 'EV Loan') ...[
                        _buildDetailRow('Vendor',
                            applicationData['vendor'] ?? 'Not Selected'),
                        _buildDetailRow('Vehicle Model',
                            applicationData['vehicleModel'] ?? 'Not Selected'),
                      ],
                      if (applicationData['loanType'] == 'Gold Loan') ...[
                        _buildDetailRow('Vendor',
                            applicationData['goldVendor'] ?? 'Not Selected'),
                        _buildDetailRow('Item Type',
                            applicationData['itemType'] ?? 'Not Selected'),
                        _buildDetailRow('Gold Purity',
                            applicationData['goldPurity'] ?? 'Not Selected'),
                        _buildDetailRow('Weight',
                            applicationData['weight'] ?? 'Not Selected'),
                        _buildDetailRow('Bill Date',
                            applicationData['billDate'] ?? 'Not Selected'),
                      ],
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Personal Information
                  _buildSectionCard(
                    screenWidth,
                    screenHeight,
                    'Personal Information',
                    Icons.person,
                    Colors.orange,
                    [
                      _buildDetailRow('Name',
                          applicationData['userName'] ?? 'Not Available'),
                      _buildDetailRow('Email',
                          applicationData['userEmail'] ?? 'Not Available'),
                      _buildDetailRow('Mobile',
                          applicationData['userMobile'] ?? 'Not Available'),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Verification Status
                  _buildSectionCard(
                    screenWidth,
                    screenHeight,
                    'Document Verification',
                    Icons.verified_user,
                    Colors.green,
                    [
                      _buildVerificationRow(
                          'PAN Card', applicationData['panVerified'] ?? false),
                      _buildVerificationRow('Aadhaar Card',
                          applicationData['aadhaarVerified'] ?? false),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Application ID Preview
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(screenWidth * 0.048),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(screenWidth * 0.032),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.confirmation_number,
                            color: Colors.grey[600], size: screenWidth * 0.08),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'Application ID will be generated',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          'After successful submission',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Submit Button
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.064),
            child: Container(
              width: double.infinity,
              height: screenHeight * 0.065,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.green.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(screenWidth * 0.032),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isSubmitting ? null : _submitApplication,
                  borderRadius: BorderRadius.circular(screenWidth * 0.032),
                  child: Center(
                    child: isSubmitting
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: screenWidth * 0.05,
                                height: screenWidth * 0.05,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.032),
                              Text(
                                'Submitting...',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.043,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Submit Application',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.043,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    double screenWidth,
    double screenHeight,
    String title,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.048),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.032),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: screenWidth * 0.02,
            offset: Offset(0, screenHeight * 0.005),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.024),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                ),
                child: Icon(icon, color: color, size: screenWidth * 0.06),
              ),
              SizedBox(width: screenWidth * 0.032),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.038,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Text(': ', style: GoogleFonts.poppins(color: Colors.grey[600])),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.038,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationRow(String label, bool isVerified) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.038,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Text(': ', style: GoogleFonts.poppins(color: Colors.grey[600])),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Icon(
                  isVerified ? Icons.check_circle : Icons.cancel,
                  color: isVerified ? Colors.green : Colors.red,
                  size: MediaQuery.of(context).size.width * 0.05,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.016),
                Text(
                  isVerified ? 'Verified' : 'Not Verified',
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width * 0.038,
                    fontWeight: FontWeight.w600,
                    color: isVerified ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitApplication() async {
    setState(() {
      isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    // Generate application ID
    String applicationId =
        'KFN${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    // Create complete application data
    Map<String, dynamic> completeApplication = {
      ...applicationData,
      'applicationId': applicationId,
      'submissionDate': DateTime.now().toIso8601String(),
      'status': 'Submitted',
      'statusColor': Colors.orange.value,
    };

    // Store in GetStorage (you can replace this with API call)
    final box = GetStorage();
    List<dynamic> applications = box.read('applications') ?? [];
    applications.add(completeApplication);
    box.write('applications', applications);

    setState(() {
      isSubmitting = false;
    });

    // Show success dialog
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle,
                color: Colors.green,
                size: MediaQuery.of(context).size.width * 0.16),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              'Application Submitted!',
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              'Application ID: $applicationId',
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.offAllNamed(
                  '/track-applications'); // Navigate to track screen
            },
            child: Text('Track Application'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
