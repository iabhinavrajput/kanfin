import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kifinserv/constants/app_colors.dart';
import 'package:kifinserv/routes/app_routes.dart';
import 'package:kifinserv/services/vendor_service.dart';
import 'package:kifinserv/services/application_storage_service.dart';
import 'package:kifinserv/models/vendor_model.dart';
import 'package:kifinserv/models/loan_types_model.dart';

class VendorSelectionScreen extends StatefulWidget {
  const VendorSelectionScreen({super.key});

  @override
  State<VendorSelectionScreen> createState() => _VendorSelectionScreenState();
}

class _VendorSelectionScreenState extends State<VendorSelectionScreen> {
  List<VendorData> vendors = [];
  bool isLoading = true;
  String? errorMessage;
  LoanTypeData? selectedLoanType;

  @override
  void initState() {
    super.initState();
    selectedLoanType = ApplicationStorageService.getSelectedLoanType();
    _fetchVendors();
  }

  Future<void> _fetchVendors() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      if (selectedLoanType == null) {
        throw Exception(
            'No loan type selected. Please go back and select a loan type.');
      }

      print('📤 Fetching vendors for loan type ID: ${selectedLoanType!.id}');
      final response =
          await VendorService.getVendorsByLoanType(selectedLoanType!.id);

      setState(() {
        vendors = response.data;
        isLoading = false;
      });

      print(
          '📥 Fetched ${vendors.length} vendors for ${selectedLoanType!.loanType}');
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _selectVendor(VendorData vendor) async {
    try {
      // Show loading
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: AppColors.royalBlue),
        ),
        barrierDismissible: false,
      );

      // Store selected vendor
      ApplicationStorageService.storeSelectedVendor(vendor);

      // Close loading dialog
      Get.back();

      // Show success message
      Get.snackbar(
        'Vendor Selected',
        '${vendor.companyName} has been selected',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.royalBlue,
        colorText: Colors.white,
      );

      // Navigate to next screen based on loan type
      if (selectedLoanType?.loanType.toLowerCase() == 'ev') {
        Get.toNamed(AppRoutes.EV_VEHICLE_SELECTION);
      } else if (selectedLoanType?.loanType.toLowerCase() == 'gold') {
        Get.toNamed(AppRoutes.USER_DETAILS_FORM);
      } else {
        Get.toNamed(AppRoutes.USER_DETAILS_FORM);
      }
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Select Vendor',
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
      body: RefreshIndicator(
        onRefresh: _fetchVendors,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                        Icons.store_outlined,
                        size: screenWidth * 0.133,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    Text(
                      'Choose Your Vendor',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.064,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      selectedLoanType != null
                          ? 'Select a vendor for your ${selectedLoanType!.displayName}'
                          : 'Select a vendor for your loan application',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.037,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (vendors.isNotEmpty && !isLoading)
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.015),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.032,
                            vertical: screenHeight * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.021),
                          ),
                          child: Text(
                            '${vendors.length} vendors available',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.032,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ),
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

                    // Loading, Error, or Vendors
                    if (isLoading)
                      _buildLoadingWidget(context)
                    else if (errorMessage != null)
                      _buildErrorWidget(context)
                    else if (vendors.isEmpty)
                      _buildEmptyWidget(context)
                    else
                      Column(
                        children: [
                          ...vendors.map((vendor) => Column(
                                children: [
                                  _buildVendorCard(
                                    context: context,
                                    vendor: vendor,
                                    onTap: () => _selectVendor(vendor),
                                  ),
                                  SizedBox(height: screenHeight * 0.025),
                                ],
                              )),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.1),
          const CircularProgressIndicator(color: AppColors.royalBlue),
          SizedBox(height: screenHeight * 0.02),
          Text(
            selectedLoanType != null
                ? 'Loading ${selectedLoanType!.loanType} vendors...'
                : 'Loading vendors...',
            style: GoogleFonts.poppins(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          SizedBox(height: screenHeight * 0.1),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.05),
          Icon(
            Icons.error_outline,
            size: screenWidth * 0.2,
            color: Colors.red,
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Failed to load vendors',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            errorMessage ?? 'Unknown error occurred',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.03),
          ElevatedButton.icon(
            onPressed: _fetchVendors,
            icon: const Icon(Icons.refresh),
            label: Text(
              'Retry',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.royalBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.032),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.05),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.05),
          Icon(
            Icons.store_mall_directory_outlined,
            size: screenWidth * 0.2,
            color: Colors.grey,
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'No vendors available',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            selectedLoanType != null
                ? 'No vendors found for ${selectedLoanType!.displayName}'
                : 'Please contact support for assistance',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.05),
        ],
      ),
    );
  }

  Widget _buildVendorCard({
    required BuildContext context,
    required VendorData vendor,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Get color based on loan type
    Color cardColor = vendor.loanType.loanType.toLowerCase() == 'ev'
        ? Colors.green
        : AppColors.royalBlue;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.053),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.1),
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
                        color: cardColor.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.032),
                      ),
                      child: Icon(
                        vendor.loanType.loanType.toLowerCase() == 'ev'
                            ? Icons.electric_car
                            : Icons.diamond,
                        color: cardColor,
                        size: screenWidth * 0.085,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.043),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vendor.companyName,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.048,
                              fontWeight: FontWeight.bold,
                              color: cardColor,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Row(
                            children: [
                              Text(
                                vendor.user.name,
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.037,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.021),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.021,
                                  vertical: screenHeight * 0.003,
                                ),
                                decoration: BoxDecoration(
                                  color: cardColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                      screenWidth * 0.016),
                                ),
                                child: Text(
                                  vendor.loanType.loanType,
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.027,
                                    color: cardColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: cardColor,
                      size: screenWidth * 0.053,
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.025),

                // Contact Details
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey[500],
                      size: screenWidth * 0.053,
                    ),
                    SizedBox(width: screenWidth * 0.021),
                    Expanded(
                      child: Text(
                        vendor.location,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.037,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.015),

                Row(
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      color: Colors.grey[500],
                      size: screenWidth * 0.053,
                    ),
                    SizedBox(width: screenWidth * 0.021),
                    Text(
                      vendor.user.mobile,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.037,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.015),

                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      color: Colors.grey[500],
                      size: screenWidth * 0.053,
                    ),
                    SizedBox(width: screenWidth * 0.021),
                    Expanded(
                      child: Text(
                        vendor.user.email,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.037,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.025),

                // Business Details
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.043),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(screenWidth * 0.032),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'PAN Number:',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.032,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            vendor.panNumber,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.032,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'CIN Number:',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.032,
                              color: Colors.grey[600],
                            ),
                          ),
                          Flexible(
                            child: Text(
                              vendor.cinNumber,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.032,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.025),

                // Select Button
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.06,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cardColor, cardColor.withOpacity(0.8)],
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
                          'Select Vendor',
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
