import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kifinserv/constants/app_colors.dart';
import 'package:kifinserv/routes/app_routes.dart';
import 'package:kifinserv/services/application_service.dart';
import 'package:kifinserv/services/application_storage_service.dart';
import 'package:kifinserv/models/application_model.dart';
import 'package:kifinserv/models/loan_types_model.dart';
import 'package:kifinserv/models/vendor_model.dart';
import 'package:kifinserv/models/vehicle_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kifinserv/services/user_storage_service.dart';

class UserDetailsFormScreen extends StatefulWidget {
  const UserDetailsFormScreen({super.key});

  @override
  State<UserDetailsFormScreen> createState() => _UserDetailsFormScreenState();
}

class _UserDetailsFormScreenState extends State<UserDetailsFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final GetStorage _box = GetStorage();

  // Form controllers
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _nationalityController = TextEditingController(text: 'Indian');
  final _communityController = TextEditingController();
  final _educationController = TextEditingController();
  final _numOfDependentsController = TextEditingController(text: '0');
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();

  // Selected values
  String? selectedGender;
  String? selectedCategory;
  String? selectedMaritalStatus;

  // Application data
  LoanTypeData? selectedLoanType;
  VendorData? selectedVendor;
  VehicleData? selectedVehicle;

  // Loading state
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadApplicationData();
    _prefillUserData();
  }

  void _loadApplicationData() {
    selectedLoanType = ApplicationStorageService.getSelectedLoanType();
    selectedVendor = ApplicationStorageService.getSelectedVendor();
    selectedVehicle = ApplicationStorageService.getSelectedVehicle();

    print('📋 Loaded Application Data:');
    print(
        '📋 Loan Type: ${selectedLoanType?.loanType} (ID: ${selectedLoanType?.id})');
    print(
        '📋 Vendor: ${selectedVendor?.companyName} (ID: ${selectedVendor?.id})');
    print(
        '📋 Vehicle: ${selectedVehicle?.vehicleName} (ID: ${selectedVehicle?.id})');
  }

  void _prefillUserData() {
    // Pre-fill form with user data from storage
    final user = UserStorageService.getUserData();
    if (user != null) {
      _nameController.text = user.name;
      print('📋 Pre-filled user name: ${user.name}');
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1950),
      lastDate:
          DateTime.now().subtract(const Duration(days: 365 * 18)), // 18+ years
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.royalBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _submitApplication() async {
    // Debug: Check user data before proceeding
    _debugUserData();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedLoanType == null || selectedVendor == null) {
      Get.snackbar(
        'Error',
        'Missing application data. Please restart the application process.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Check if vehicle is required for EV loans
    if (selectedLoanType!.loanType.toLowerCase() == 'ev' &&
        selectedVehicle == null) {
      Get.snackbar(
        'Error',
        'Vehicle selection is required for EV loans.',
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

      // Get user ID from UserStorageService
      int? userId = UserStorageService.getUserId();
      if (userId == null) {
        throw Exception('User not found. Please login again.');
      }

      final request = ApplicationRequest(
        userId: userId,
        loanType: selectedLoanType!.id,
        confirmedLoanType: selectedLoanType!.id,
        vendorId: selectedVendor!.id,
        vehicleId: selectedVehicle?.id, // Only for EV loans
        name: _nameController.text.trim(),
        dob: _dobController.text,
        gender: selectedGender!.toLowerCase(),
        nationality: _nationalityController.text.trim(),
        community: _communityController.text.trim(),
        category: selectedCategory!,
        education: _educationController.text.trim(),
        maritalStatus: selectedMaritalStatus!,
        numOfDependents: int.parse(_numOfDependentsController.text),
        fatherName: _fatherNameController.text.trim(),
        motherName: _motherNameController.text.trim(),
      );

      final response = await ApplicationService.submitApplication(request);

      // Store the application ID
      ApplicationStorageService.storeApplicationId(response.applicationId);

      setState(() {
        isSubmitting = false;
      });

      // Show success dialog and navigate to address update
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
                      'Application Details:',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Application ID: ${response.applicationId}'),
                    Text('Status: ${response.currentStatus}'),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Next: Please provide your address information to continue.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog
                Get.toNamed(
                    AppRoutes.ADDRESS_UPDATE); // Navigate to address update
              },
              child: Text(
                'Continue',
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

  void _debugUserData() {
    print('🔍 DEBUG: Checking user data before submission...');

    // Check UserStorageService
    final userId = UserStorageService.getUserId();
    final userData = UserStorageService.getUserData();
    final authToken = UserStorageService.getAuthToken();

    print('🔍 UserStorageService.getUserId(): $userId');
    print('🔍 UserStorageService.getUserData(): ${userData?.toJson()}');
    print(
        '🔍 UserStorageService.getAuthToken(): ${authToken?.substring(0, 20)}...');
    print(
        '🔍 UserStorageService.isLoggedIn(): ${UserStorageService.isLoggedIn()}');

    // Check GetStorage directly
    final box = GetStorage();
    final directUserId = box.read('userId');
    final directUserData = box.read('userData');
    final directAuthToken = box.read('authToken');

    print('🔍 Direct GetStorage userId: $directUserId');
    print('🔍 Direct GetStorage userData: $directUserData');
    print(
        '🔍 Direct GetStorage authToken: ${directAuthToken?.substring(0, 20)}...');

    // Check application data
    print(
        '🔍 Application Summary: ${ApplicationStorageService.getApplicationSummary()}');

    if (userId == null) {
      print('❌ ERROR: User ID is null!');
      print('❌ This will cause the submission to fail.');

      // Show detailed error dialog
      Get.dialog(
        AlertDialog(
          title: Text('Debug: User Data Missing'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User ID: ${userId ?? "NULL"}'),
              Text('User Data: ${userData?.name ?? "NULL"}'),
              Text(
                  'Auth Token: ${authToken?.isNotEmpty == true ? "Present" : "NULL"}'),
              Text('Logged In: ${UserStorageService.isLoggedIn()}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                Get.offAllNamed(AppRoutes.LOGIN);
              },
              child: Text('Go to Login'),
            ),
          ],
        ),
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
                      Icons.person_outline,
                      size: screenWidth * 0.133,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  Text(
                    'Personal Information',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.064,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Please fill in your personal details to complete the application',
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

                    // Application Summary Card
                    if (selectedLoanType != null || selectedVendor != null)
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.043),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.032),
                          border: Border.all(color: Colors.blue[100]!),
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
                            if (selectedLoanType != null)
                              Text(
                                  'Loan Type: ${selectedLoanType!.displayName}'),
                            if (selectedVendor != null)
                              Text('Vendor: ${selectedVendor!.companyName}'),
                            if (selectedVehicle != null)
                              Text('Vehicle: ${selectedVehicle!.vehicleName}'),
                          ],
                        ),
                      ),

                    SizedBox(height: screenHeight * 0.03),

                    // Name Field
                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Date of Birth Field
                    _buildTextField(
                      controller: _dobController,
                      label: 'Date of Birth',
                      icon: Icons.calendar_today,
                      readOnly: true,
                      onTap: _selectDate,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Date of birth is required';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Gender Dropdown
                    _buildDropdownField(
                      value: selectedGender,
                      label: 'Gender',
                      icon: Icons.people,
                      items: ['Male', 'Female', 'Other'],
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Gender is required';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Nationality Field
                    _buildTextField(
                      controller: _nationalityController,
                      label: 'Nationality',
                      icon: Icons.flag,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nationality is required';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Community Field
                    _buildTextField(
                      controller: _communityController,
                      label: 'Community',
                      icon: Icons.group,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Community is required';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Category Dropdown
                    _buildDropdownField(
                      value: selectedCategory,
                      label: 'Category',
                      icon: Icons.category,
                      items: [
                        'Salaried',
                        'Self-Employed',
                        'Business',
                        'Farmer',
                        'Student',
                        'Retired',
                        'Other'
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Category is required';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Education Field
                    _buildTextField(
                      controller: _educationController,
                      label: 'Education',
                      icon: Icons.school,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Education is required';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Marital Status Dropdown
                    _buildDropdownField(
                      value: selectedMaritalStatus,
                      label: 'Marital Status',
                      icon: Icons.favorite,
                      items: ['Single', 'Married', 'Divorced', 'Widowed'],
                      onChanged: (value) {
                        setState(() {
                          selectedMaritalStatus = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Marital status is required';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Number of Dependents Field
                    _buildTextField(
                      controller: _numOfDependentsController,
                      label: 'Number of Dependents',
                      icon: Icons.family_restroom,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Number of dependents is required';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Father's Name Field
                    _buildTextField(
                      controller: _fatherNameController,
                      label: "Father's Name",
                      icon: Icons.man,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Father's name is required";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Mother's Name Field
                    _buildTextField(
                      controller: _motherNameController,
                      label: "Mother's Name",
                      icon: Icons.woman,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Mother's name is required";
                        }
                        return null;
                      },
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
                          onTap: isSubmitting ? null : _submitApplication,
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
    _nameController.dispose();
    _dobController.dispose();
    _nationalityController.dispose();
    _communityController.dispose();
    _educationController.dispose();
    _numOfDependentsController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    super.dispose();
  }
}
