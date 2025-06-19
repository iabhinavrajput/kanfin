import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kifinserv/constants/app_colors.dart';
import 'package:kifinserv/routes/app_routes.dart';
import 'package:kifinserv/services/address_service.dart';
import 'package:kifinserv/services/application_storage_service.dart';
import 'package:kifinserv/models/address_model.dart';

class AddressUpdateScreen extends StatefulWidget {
  const AddressUpdateScreen({super.key});

  @override
  State<AddressUpdateScreen> createState() => _AddressUpdateScreenState();
}

class _AddressUpdateScreenState extends State<AddressUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _residentialAddressController = TextEditingController();
  final _nearestLandmarkController = TextEditingController();
  final _permanentAddressController = TextEditingController();

  // Selected values
  String? selectedResidentialOwnership;
  String? selectedPersonWithDisability;

  // Application data
  int? applicationId;

  // Loading state
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadApplicationData();
  }

  void _loadApplicationData() {
    applicationId = ApplicationStorageService.getApplicationId();
    print('📋 Application ID: $applicationId');

    if (applicationId == null) {
      Get.snackbar(
        'Error',
        'Application ID not found. Please restart the application process.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _updateAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (applicationId == null) {
      Get.snackbar(
        'Error',
        'Application ID not found. Please restart the application process.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      setState(() {
        isSubmitting = true;
      });

      final request = AddressUpdateRequest(
        loanApplicationId: applicationId!,
        residentialOwnership: selectedResidentialOwnership!,
        residentialAddress: _residentialAddressController.text.trim(),
        nearestLandmark: _nearestLandmarkController.text.trim(),
        personWithDisability: selectedPersonWithDisability!.toLowerCase(),
        permanentAddress: _permanentAddressController.text.trim(),
      );

      final response = await AddressService.updateAddress(request);

      setState(() {
        isSubmitting = false;
      });

      // Show success dialog
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text(
                'Success!',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                response.message,
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              if (response.updatedApplication != null) ...[
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Updated Address Information:',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                          'Application ID: ${response.updatedApplication!.id}'),
                      Text(
                          'Ownership: ${response.updatedApplication!.residentialOwnership}'),
                      Text(
                          'Address: ${response.updatedApplication!.residentialAddress}'),
                      Text(
                          'Landmark: ${response.updatedApplication!.nearestLandmark}'),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 15),
              Text(
                'Next: Please complete the Digio verification to finalize your application.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog

                // Pass application data to Digio verification
                Get.toNamed(
                  AppRoutes.DIGIO_VERIFICATION,
                  arguments: {
                    'applicationId': applicationId,
                    'updatedApplication': response.updatedApplication,
                    'loanType': ApplicationStorageService.getSelectedLoanType(),
                    'vendor': ApplicationStorageService.getSelectedVendor(),
                    'vehicle': ApplicationStorageService.getSelectedVehicle(),
                  },
                );
              },
              child: Text(
                'Continue to Verification',
                style: GoogleFonts.poppins(
                  color: AppColors.royalBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      setState(() {
        isSubmitting = false;
      });

      Get.snackbar(
        'Error',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
          'Address Information',
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
                      Icons.home_outlined,
                      size: screenWidth * 0.133,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  Text(
                    'Address Details',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.064,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Please provide your residential and permanent address information',
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: screenHeight * 0.025),

                    // Application ID Info
                    if (applicationId != null)
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.043),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.032),
                          border: Border.all(color: Colors.green[100]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.green),
                            SizedBox(width: screenWidth * 0.021),
                            Text(
                              'Application ID: $applicationId',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.037,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: screenHeight * 0.03),

                    // Residential Ownership Dropdown
                    _buildDropdownField(
                      value: selectedResidentialOwnership,
                      label: 'Residential Ownership',
                      icon: Icons.home_work,
                      items: [
                        'Owned',
                        'Rented',
                        'Family Owned',
                        'Company Provided',
                        'Other'
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedResidentialOwnership = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Residential ownership is required';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Residential Address Field
                    _buildTextField(
                      controller: _residentialAddressController,
                      label: 'Residential Address',
                      icon: Icons.location_on,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Residential address is required';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Nearest Landmark Field
                    _buildTextField(
                      controller: _nearestLandmarkController,
                      label: 'Nearest Landmark',
                      icon: Icons.place,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nearest landmark is required';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Person with Disability Dropdown
                    _buildDropdownField(
                      value: selectedPersonWithDisability,
                      label: 'Person with Disability',
                      icon: Icons.accessible,
                      items: ['No', 'Yes'],
                      onChanged: (value) {
                        setState(() {
                          selectedPersonWithDisability = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select an option';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Permanent Address Field
                    _buildTextField(
                      controller: _permanentAddressController,
                      label: 'Permanent Address',
                      icon: Icons.location_city,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Permanent address is required';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Copy Residential Address Button
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _permanentAddressController.text =
                              _residentialAddressController.text;
                        });
                      },
                      icon: Icon(Icons.copy, size: screenWidth * 0.048),
                      label: Text(
                        'Copy from Residential Address',
                        style:
                            GoogleFonts.poppins(fontSize: screenWidth * 0.037),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.royalBlue,
                        side: BorderSide(color: AppColors.royalBlue),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.032),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.032,
                          vertical: screenHeight * 0.015,
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.05),

                    // Submit Button
                    Container(
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
                          onTap: isSubmitting ? null : _updateAddress,
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.032),
                          child: Center(
                            child: isSubmitting
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Update Address',
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
            ),
          ],
        ),
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
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
      style: GoogleFonts.poppins(fontSize: screenWidth * 0.037),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: Colors.grey[600],
          fontSize: screenWidth * 0.037,
        ),
        prefixIcon: Icon(icon, color: AppColors.royalBlue),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.032),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.032),
          borderSide: BorderSide(color: AppColors.royalBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.032),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.032),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      validator: validator,
      style: GoogleFonts.poppins(
        fontSize: screenWidth * 0.037,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: Colors.grey[600],
          fontSize: screenWidth * 0.037,
        ),
        prefixIcon: Icon(icon, color: AppColors.royalBlue),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.032),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.032),
          borderSide: BorderSide(color: AppColors.royalBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.032),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.032),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _residentialAddressController.dispose();
    _nearestLandmarkController.dispose();
    _permanentAddressController.dispose();
    super.dispose();
  }
}
