import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kifinserv/constants/app_colors.dart';
import 'package:kifinserv/routes/app_routes.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  Map<String, dynamic> applicationData = {};
  bool isBankStatementUploaded = false;
  bool isElectricityBillUploaded = false;
  bool isBankStatementUploading = false;
  bool isElectricityBillUploading = false;

  @override
  void initState() {
    super.initState();
    applicationData = Get.arguments ?? {};
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Upload Documents',
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
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
                screenHeight * 0.04,
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.upload_file,
                      size: screenWidth * 0.133,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Upload Required Documents',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.064,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.008),
                  Text(
                    'Please upload the following documents to proceed',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.037,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(screenWidth * 0.064),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Application Summary
                  if (applicationData.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(screenWidth * 0.04),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Application Details',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.043,
                              fontWeight: FontWeight.w600,
                              color: AppColors.royalBlue,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          if (applicationData['name'] != null)
                            _buildSummaryRow(
                                'Name', applicationData['name'], screenWidth),
                          if (applicationData['loanType'] != null)
                            _buildSummaryRow('Loan Type',
                                applicationData['loanType'], screenWidth),
                          if (applicationData['vehicle'] != null)
                            _buildSummaryRow('Vehicle',
                                applicationData['vehicle'], screenWidth),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                  ],

                  // Document Upload Section
                  Text(
                    'Required Documents',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.053,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Bank Statement Upload
                  _buildDocumentCard(
                    title: 'Bank Statement (PDF)',
                    subtitle: 'Upload last 6 months bank statement',
                    icon: Icons.account_balance,
                    color: Colors.green,
                    isUploaded: isBankStatementUploaded,
                    isUploading: isBankStatementUploading,
                    onTap: () => _uploadBankStatement(),
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Electricity Bill Upload
                  _buildDocumentCard(
                    title: 'Electricity Bill',
                    subtitle: 'Upload latest electricity bill as address proof',
                    icon: Icons.electric_bolt,
                    color: Colors.orange,
                    isUploaded: isElectricityBillUploaded,
                    isUploading: isElectricityBillUploading,
                    onTap: () => _uploadElectricityBill(),
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Upload Guidelines
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(screenWidth * 0.04),
                      border: Border.all(color: Colors.amber[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info,
                                color: Colors.amber[700],
                                size: screenWidth * 0.06),
                            SizedBox(width: screenWidth * 0.032),
                            Text(
                              'Upload Guidelines',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.043,
                                fontWeight: FontWeight.w600,
                                color: Colors.amber[800],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        _buildGuidelinePoint(
                            '• Documents should be clear and readable',
                            screenWidth),
                        _buildGuidelinePoint(
                            '• File size should not exceed 5MB', screenWidth),
                        _buildGuidelinePoint(
                            '• Accepted formats: PDF, JPG, PNG', screenWidth),
                        _buildGuidelinePoint(
                            '• Ensure all details are visible', screenWidth),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // Continue Button
                  Container(
                    width: double.infinity,
                    height: screenHeight * 0.065,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: (isBankStatementUploaded &&
                                isElectricityBillUploaded)
                            ? [
                                AppColors.royalBlue,
                                AppColors.royalBlue.withOpacity(0.8)
                              ]
                            : [Colors.grey, Colors.grey.withOpacity(0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(screenWidth * 0.032),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (isBankStatementUploaded &&
                                isElectricityBillUploaded)
                            ? () {
                                final updatedData = {
                                  ...applicationData,
                                  'documentsUploaded': true,
                                  'bankStatement': 'uploaded',
                                  'electricityBill': 'uploaded',
                                };
                                Get.toNamed(AppRoutes.REFERENCE_DETAILS,
                                    arguments: updatedData);
                              }
                            : null,
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.032),
                        child: Center(
                          child: Text(
                            'Continue to References',
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

                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.015),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isUploaded,
    required bool isUploading,
    required VoidCallback onTap,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        border: Border.all(
          color: isUploaded ? color : Colors.grey[300]!,
          width: isUploaded ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isUploaded ? color : Colors.grey).withOpacity(0.1),
            blurRadius: screenWidth * 0.02,
            offset: Offset(0, screenHeight * 0.005),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isUploaded ? null : onTap,
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.053),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: screenWidth * 0.08,
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.043,
                          fontWeight: FontWeight.w600,
                          color: isUploaded ? color : Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isUploading)
                  SizedBox(
                    width: screenWidth * 0.06,
                    height: screenWidth * 0.06,
                    child: CircularProgressIndicator(
                      color: color,
                      strokeWidth: 2,
                    ),
                  )
                else if (isUploaded)
                  Icon(
                    Icons.check_circle,
                    color: color,
                    size: screenWidth * 0.064,
                  )
                else
                  Icon(
                    Icons.upload,
                    color: Colors.grey[400],
                    size: screenWidth * 0.064,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGuidelinePoint(String text, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.01),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: screenWidth * 0.035,
          color: Colors.amber[700],
        ),
      ),
    );
  }

  void _uploadBankStatement() async {
    setState(() => isBankStatementUploading = true);

    // Simulate file upload
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isBankStatementUploading = false;
      isBankStatementUploaded = true;
    });

    Get.snackbar(
      'Success',
      'Bank statement uploaded successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _uploadElectricityBill() async {
    setState(() => isElectricityBillUploading = true);

    // Simulate file upload
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isElectricityBillUploading = false;
      isElectricityBillUploaded = true;
    });

    Get.snackbar(
      'Success',
      'Electricity bill uploaded successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }
}
