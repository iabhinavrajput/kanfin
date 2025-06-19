import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kifinserv/constants/app_colors.dart';
import 'package:kifinserv/models/application_model.dart';
import 'package:kifinserv/routes/app_routes.dart';
import 'package:kifinserv/services/application_storage_service.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  bool isTermsAccepted = false;
  bool isPrivacyAccepted = false;
  bool isDeclarationAccepted = false;
  Map<String, dynamic> applicationData = {};

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
          'Terms & Conditions',
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
                      Icons.gavel,
                      size: screenWidth * 0.133,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Terms & Conditions',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.064,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.008),
                  Text(
                    'Please review and accept our terms to proceed',
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
                  // Terms and Conditions Section
                  _buildTermsSection(
                    title: 'Terms and Conditions',
                    content: '''
1. Loan Approval: Loan approval is subject to verification of documents and credit assessment.

2. Interest Rates: Interest rates are subject to change based on market conditions and RBI guidelines.

3. Repayment: Borrower agrees to repay the loan amount with interest as per the agreed schedule.

4. Collateral: The vehicle purchased will serve as collateral for the loan amount.

5. Default: In case of default, the lender has the right to recover the vehicle and outstanding amount.

6. Processing Fees: All processing fees and charges are non-refundable.

7. Legal Action: Any disputes will be subject to the jurisdiction of local courts.
                    ''',
                    isAccepted: isTermsAccepted,
                    onChanged: (value) {
                      setState(() {
                        isTermsAccepted = value ?? false;
                      });
                    },
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Privacy Policy Section
                  _buildTermsSection(
                    title: 'Privacy Policy',
                    content: '''
1. Data Collection: We collect personal and financial information for loan processing.

2. Data Usage: Your information will be used for verification, credit assessment, and loan servicing.

3. Data Sharing: Information may be shared with credit bureaus, banks, and regulatory authorities.

4. Data Security: We implement appropriate security measures to protect your information.

5. Consent: By proceeding, you consent to the collection and use of your information as described.

6. Rights: You have the right to access, update, or request deletion of your personal information.
                    ''',
                    isAccepted: isPrivacyAccepted,
                    onChanged: (value) {
                      setState(() {
                        isPrivacyAccepted = value ?? false;
                      });
                    },
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Declaration Section
                  _buildDeclarationSection(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // Submit Button
                  Container(
                    width: double.infinity,
                    height: screenHeight * 0.065,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: (isTermsAccepted &&
                                isPrivacyAccepted &&
                                isDeclarationAccepted)
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
                        onTap: (isTermsAccepted &&
                                isPrivacyAccepted &&
                                isDeclarationAccepted)
                            ? _submitApplication
                            : null,
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.032),
                        child: Center(
                          child: Text(
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

                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsSection({
    required String title,
    required String content,
    required bool isAccepted,
    required ValueChanged<bool?> onChanged,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        border: Border.all(color: Colors.grey[300]!),
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color: AppColors.royalBlue.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(screenWidth * 0.04),
                topRight: Radius.circular(screenWidth * 0.04),
              ),
            ),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.043,
                fontWeight: FontWeight.w600,
                color: AppColors.royalBlue,
              ),
            ),
          ),
          Container(
            height: screenHeight * 0.2,
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: SingleChildScrollView(
              child: Text(
                content,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Row(
              children: [
                Checkbox(
                  value: isAccepted,
                  onChanged: onChanged,
                  activeColor: AppColors.royalBlue,
                ),
                Expanded(
                  child: Text(
                    'I have read and agree to the $title',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.037,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeclarationSection({
    required double screenWidth,
    required double screenHeight,
  }) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified,
                  color: Colors.green[700], size: screenWidth * 0.06),
              SizedBox(width: screenWidth * 0.032),
              Text(
                'Declaration',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.043,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[800],
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.015),
          Text(
            'I hereby declare that all the information provided in this application is true and accurate to the best of my knowledge. I understand that any false information may result in rejection of my loan application.',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.035,
              color: Colors.green[700],
              height: 1.4,
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          Row(
            children: [
              Checkbox(
                value: isDeclarationAccepted,
                onChanged: (value) {
                  setState(() {
                    isDeclarationAccepted = value ?? false;
                  });
                },
                activeColor: Colors.green,
              ),
              Expanded(
                child: Text(
                  'I agree to the above declaration',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.037,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submitApplication() async {
    final applicationId = 'app_${DateTime.now().millisecondsSinceEpoch}';

    final application = LoanApplication(
      id: applicationId,
      loanType: applicationData['loanType'] ?? 'Unknown',
      status: 'submitted',
      submissionDate: DateTime.now(),
      applicantName: applicationData['name'] ?? '',
      email: applicationData['email'] ?? '',
      mobile: applicationData['mobile'] ?? '',
      address: applicationData['address'] ?? '',
      loanDetails: {
        'vendor': applicationData['vendor'],
        'vehicle': applicationData['vehicle'],
        'item': applicationData['item'],
        'weight': applicationData['weight'],
        'purity': applicationData['purity'],
        'amount': applicationData['amount'],
      },
      references: {
        'reference1': applicationData['reference1'] ?? {},
        'reference2': applicationData['reference2'] ?? {},
      },
      documents: {
        'bankStatement': applicationData['bankStatement'] ?? 'not_uploaded',
        'electricityBill': applicationData['electricityBill'] ?? 'not_uploaded',
        'goldCertificate': applicationData['goldCertificate'] ?? 'not_uploaded',
        'identityProof': applicationData['identityProof'] ?? 'not_uploaded',
      },
    );

    // Save to local storage
    final storageService = ApplicationStorageService();
    await storageService.saveApplication(application);

    // Clear temporary application data
    ApplicationStorageService.clearApplicationData();

    Get.snackbar(
      'Success',
      'Application submitted successfully!\nApplication ID: $applicationId',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );

    // Navigate to home screen (application process complete)
    Get.offAllNamed(AppRoutes.HOME);
  }
}
