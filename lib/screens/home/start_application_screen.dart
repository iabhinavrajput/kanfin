import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kifinserv/constants/app_colors.dart';
import 'package:kifinserv/routes/app_routes.dart';
import 'package:kifinserv/services/application_storage_service.dart';
import 'package:kifinserv/models/loan_types_model.dart';

class StartApplicationScreen extends StatelessWidget {
  const StartApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Start Application',
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
                screenHeight * 0.05,
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
                      Icons.description_outlined,
                      size: screenWidth * 0.133,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  Text(
                    'Choose Your Loan Type',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.064,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Select the loan that best fits your needs',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.037,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Content Section
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.064),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: screenHeight * 0.025),

                  // Gold Loan Card
                  _buildLoanCard(
                    context: context,
                    title: 'Gold Loan',
                    subtitle: 'Quick approval against gold collateral',
                    description:
                        'Get instant loans against your gold jewelry with minimal documentation',
                    icon: Icons.diamond,
                    color: AppColors.royalBlue,
                    features: [
                      'Quick approval in 30 minutes',
                      'Up to 75% of gold value',
                      'Flexible repayment options',
                      'Minimal documentation'
                    ],
                    onTap: () {
                      _selectLoanType(LoanTypeData(id: 2, loanType: 'Gold'));
                    },
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // EV Loan Card
                  _buildLoanCard(
                    context: context,
                    title: 'Electric Vehicle Loan',
                    subtitle: 'Finance your eco-friendly ride',
                    description:
                        'Special rates for electric vehicles with extended tenure options',
                    icon: Icons.electric_car,
                    color: Colors.green,
                    features: [
                      'Special EV loan rates',
                      'Up to 90% financing',
                      'Extended loan tenure',
                      'Green incentives available'
                    ],
                    onTap: () {
                      _selectLoanType(LoanTypeData(id: 1, loanType: 'EV'));
                    },
                  ),

                  SizedBox(height: screenHeight * 0.0375),

                  // Info Section
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.053),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(screenWidth * 0.043),
                      border: Border.all(color: Colors.blue[100]!),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.royalBlue,
                          size: screenWidth * 0.085,
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        Text(
                          'Need Help Choosing?',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.043,
                            fontWeight: FontWeight.w600,
                            color: AppColors.royalBlue,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'Our loan experts are here to help you select the best option for your financial needs.',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.037,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        OutlinedButton.icon(
                          onPressed: () {
                            Get.snackbar(
                              'Contact Support',
                              'Our team will contact you shortly',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppColors.royalBlue,
                              colorText: Colors.white,
                            );
                          },
                          icon: Icon(
                            Icons.phone,
                            size: screenWidth * 0.048,
                            color: AppColors.royalBlue,
                          ),
                          label: Text(
                            'Contact Expert',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.037,
                              color: AppColors.royalBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.royalBlue),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.032),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.064,
                              vertical: screenHeight * 0.015,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectLoanType(LoanTypeData loanType) async {
    try {
      // Show loading
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: AppColors.royalBlue),
        ),
        barrierDismissible: false,
      );

      // Store selected loan type locally (no API call needed)
      ApplicationStorageService.storeSelectedLoanType(loanType);

      // Close loading dialog
      Get.back();

      // Show success message
      Get.snackbar(
        'Loan Type Selected',
        '${loanType.displayName} has been selected',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.royalBlue,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Wait a moment for the snackbar to show
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate to vendor selection screen
      Get.toNamed(AppRoutes.VENDOR_SELECTION);
    } catch (e) {
      // Close loading dialog
      Get.back();

      // Show error
      Get.snackbar(
        'Error',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildLoanCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color color,
    required List<String> features,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.053),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: screenWidth * 0.053,
            offset: Offset(0, screenHeight * 0.01),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(screenWidth * 0.053),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.064),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.032),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.032),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: screenWidth * 0.085,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.043),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.053,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Text(
                            subtitle,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.037,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: color,
                      size: screenWidth * 0.053,
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.025),

                // Description
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.037,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),

                SizedBox(height: screenHeight * 0.025),

                // Features
                Text(
                  'Key Features:',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.043,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),

                ...features.map((feature) => Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.01),
                      child: Row(
                        children: [
                          Container(
                            width: screenWidth * 0.016,
                            height: screenWidth * 0.016,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.032),
                          Expanded(
                            child: Text(
                              feature,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.035,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),

                SizedBox(height: screenHeight * 0.025),

                // Apply Button
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.06,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(screenWidth * 0.032),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(screenWidth * 0.032),
                      child: Center(
                        child: Text(
                          'Apply Now',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
