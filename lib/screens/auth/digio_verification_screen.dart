import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kifinserv/constants/app_colors.dart';
import 'package:kifinserv/routes/app_routes.dart';

class DigioVerificationScreen extends StatefulWidget {
  const DigioVerificationScreen({super.key});

  @override
  State<DigioVerificationScreen> createState() =>
      _DigioVerificationScreenState();
}

class _DigioVerificationScreenState extends State<DigioVerificationScreen> {
  bool isPanVerified = false;
  bool isAadhaarVerified = false;
  bool isPanVerifying = false;
  bool isAadhaarVerifying = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final arguments = Get.arguments ?? {};

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Document Verification',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: screenWidth * 0.048,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.royalBlue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
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
                    padding: EdgeInsets.all(screenWidth * 0.053),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.verified_user,
                      size: screenWidth * 0.133,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Secure Verification',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.064,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.008),
                  Text(
                    'Verify your identity with PAN & Aadhaar',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.037,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.008,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                    child: Text(
                      '🔒 Powered by Digio',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.032,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Application Summary
            if (arguments.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.064),
                child: Container(
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
                        'Application Summary',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.043,
                          fontWeight: FontWeight.w600,
                          color: AppColors.royalBlue,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      _buildSummaryRow('Loan Type', arguments['loanType'] ?? '',
                          screenWidth),
                      if (arguments['vendor'] != null)
                        _buildSummaryRow(
                            'Vendor', arguments['vendor'], screenWidth),
                      if (arguments['vehicle'] != null)
                        _buildSummaryRow(
                            'Vehicle', arguments['vehicle'], screenWidth),
                      if (arguments['item'] != null)
                        _buildSummaryRow(
                            'Item', arguments['item'], screenWidth),
                    ],
                  ),
                ),
              ),
            ],

            // Verification Cards
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.064),
              child: Column(
                children: [
                  // PAN Verification
                  _buildVerificationCard(
                    context: context,
                    title: 'PAN Card Verification',
                    subtitle: 'Verify your PAN card details',
                    icon: Icons.credit_card,
                    color: Colors.orange,
                    isVerified: isPanVerified,
                    isVerifying: isPanVerifying,
                    onTap: () => _verifyPAN(),
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Aadhaar Verification
                  _buildVerificationCard(
                    context: context,
                    title: 'Aadhaar Card Verification',
                    subtitle: 'Verify your Aadhaar card details',
                    icon: Icons.fingerprint,
                    color: Colors.green,
                    isVerified: isAadhaarVerified,
                    isVerifying: isAadhaarVerifying,
                    onTap: () => _verifyAadhaar(),
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Security Info
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(screenWidth * 0.04),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.security,
                          color: Colors.green,
                          size: screenWidth * 0.06,
                        ),
                        SizedBox(width: screenWidth * 0.032),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your data is secure',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.037,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green[800],
                                ),
                              ),
                              Text(
                                'All verification is done through secure Digio platform with end-to-end encryption.',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.032,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        ),
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
                        colors: (isPanVerified && isAadhaarVerified)
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
                        onTap: (isPanVerified && isAadhaarVerified)
                            ? () {
                                // Get current arguments
                                final arguments = Get.arguments ?? {};

                                Get.snackbar(
                                  'Verification Complete',
                                  'Document verification completed successfully!',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );

                                // Navigate to Reference Details with application data
                                Get.toNamed(
                                  AppRoutes.REFERENCE_DETAILS,
                                  arguments: arguments,
                                );
                              }
                            : null,
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.032),
                        child: Center(
                          child: Text(
                            'Complete Application',
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

                  SizedBox(height: screenHeight * 0.03),
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

  Widget _buildVerificationCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isVerified,
    required bool isVerifying,
    required VoidCallback onTap,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        border: Border.all(
          color: isVerified ? color : Colors.grey[300]!,
          width: isVerified ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isVerified ? color : Colors.grey).withOpacity(0.1),
            blurRadius: screenWidth * 0.02,
            offset: Offset(0, screenHeight * 0.005),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isVerified ? null : onTap,
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
                          color: isVerified ? color : Colors.grey[800],
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
                if (isVerifying)
                  SizedBox(
                    width: screenWidth * 0.06,
                    height: screenWidth * 0.06,
                    child: CircularProgressIndicator(
                      color: color,
                      strokeWidth: 2,
                    ),
                  )
                else if (isVerified)
                  Icon(
                    Icons.check_circle,
                    color: color,
                    size: screenWidth * 0.064,
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[400],
                    size: screenWidth * 0.05,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _verifyPAN() async {
    setState(() => isPanVerifying = true);

    // Simulate verification process
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      isPanVerifying = false;
      isPanVerified = true;
    });

    Get.snackbar(
      'PAN Verified',
      'Your PAN card has been successfully verified',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void _verifyAadhaar() async {
    setState(() => isAadhaarVerifying = true);

    // Simulate verification process
    await Future.delayed(const Duration(seconds: 4));

    setState(() {
      isAadhaarVerifying = false;
      isAadhaarVerified = true;
    });

    Get.snackbar(
      'Aadhaar Verified',
      'Your Aadhaar card has been successfully verified',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
