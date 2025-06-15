import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kifinserv/constants/app_colors.dart';
import 'package:kifinserv/routes/app_routes.dart';

class UserDetailsFormScreen extends StatefulWidget {
  const UserDetailsFormScreen({super.key});

  @override
  State<UserDetailsFormScreen> createState() => _UserDetailsFormScreenState();
}

class _UserDetailsFormScreenState extends State<UserDetailsFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();

  Map<String, dynamic> applicationData = {};

  @override
  void initState() {
    super.initState();
    applicationData = Get.arguments ?? {};
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    emailController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Personal Details',
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
                      Icons.person,
                      size: screenWidth * 0.133,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Enter Your Details',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.064,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.008),
                  Text(
                    'Please provide accurate information for loan processing',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.037,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Form Section
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.064),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Application Summary
                    if (applicationData.isNotEmpty) ...[
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.04),
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
                            _buildSummaryRow('Loan Type',
                                applicationData['loanType'] ?? '', screenWidth),
                            if (applicationData['vendor'] != null)
                              _buildSummaryRow('Vendor',
                                  applicationData['vendor'], screenWidth),
                            if (applicationData['vehicle'] != null)
                              _buildSummaryRow('Vehicle',
                                  applicationData['vehicle'], screenWidth),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                    ],

                    // Form Fields
                    Text(
                      'Personal Information',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.053,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    _buildTextField(
                      controller: nameController,
                      label: 'Full Name',
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                      screenWidth: screenWidth,
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    _buildTextField(
                      controller: addressController,
                      label: 'Address',
                      icon: Icons.location_on,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                      screenWidth: screenWidth,
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    _buildTextField(
                      controller: emailController,
                      label: 'Email Address',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      screenWidth: screenWidth,
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    _buildTextField(
                      controller: mobileController,
                      label: 'Mobile Number',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        if (value.length != 10) {
                          return 'Please enter a valid 10-digit mobile number';
                        }
                        return null;
                      },
                      screenWidth: screenWidth,
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // Submit Button
                    Container(
                      width: double.infinity,
                      height: screenHeight * 0.065,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.royalBlue,
                            AppColors.royalBlue.withOpacity(0.8)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.032),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _submitForm,
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.032),
                          child: Center(
                            child: Text(
                              'Continue to Document Upload',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    required double screenWidth,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.royalBlue),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.032),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.032),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.032),
          borderSide: BorderSide(color: AppColors.royalBlue, width: 2),
        ),
        labelStyle: GoogleFonts.poppins(
          fontSize: screenWidth * 0.037,
          color: Colors.grey[600],
        ),
      ),
      style: GoogleFonts.poppins(
        fontSize: screenWidth * 0.037,
        color: Colors.grey[800],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        ...applicationData,
        'name': nameController.text.trim(),
        'address': addressController.text.trim(),
        'email': emailController.text.trim(),
        'mobile': mobileController.text.trim(),
      };

      Get.toNamed(AppRoutes.DOCUMENT_UPLOAD, arguments: updatedData);
    }
  }
}
