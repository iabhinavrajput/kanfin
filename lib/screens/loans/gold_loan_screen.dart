import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kifinserv/constants/app_colors.dart';

class GoldLoanScreen extends StatefulWidget {
  const GoldLoanScreen({super.key});

  @override
  State<GoldLoanScreen> createState() => _GoldLoanScreenState();
}

class _GoldLoanScreenState extends State<GoldLoanScreen> {
  String? selectedVendor;
  String? selectedItem;
  String? selectedPurity;
  TextEditingController weightController = TextEditingController();
  DateTime? selectedDate;

  final List<String> vendors = [
    'Tanishq',
    'Kalyan Jewellers',
    'PC Jeweller',
    'Senco Gold',
    'Joyalukkas',
    'Malabar Gold & Diamonds',
  ];

  final List<String> goldItems = [
    'Necklace',
    'Bangles',
    'Earrings',
    'Ring',
    'Chain',
    'Bracelet',
    'Pendant',
    'Coin',
    'Bar',
  ];

  final List<String> purityOptions = [
    '24K (99.9%)',
    '22K (91.6%)',
    '21K (87.5%)',
    '20K (83.3%)',
    '18K (75.0%)',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Gold Loan Details',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: screenWidth * 0.048,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.white, size: screenWidth * 0.064),
          onPressed: () => Get.back(),
        ),
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
                screenHeight * 0.03,
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.diamond,
                    size: screenWidth * 0.16,
                    color: Colors.white,
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Text(
                    'Gold Loan Application',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Provide your gold item details',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Form Section
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.064),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vendor Selection
                  _buildSectionHeader('Select Vendor', screenWidth),
                  SizedBox(height: screenHeight * 0.015),
                  _buildDropdownField(
                    context: context,
                    hint: 'Choose jewelry vendor',
                    value: selectedVendor,
                    items: vendors,
                    onChanged: (value) =>
                        setState(() => selectedVendor = value),
                    icon: Icons.store,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),

                  SizedBox(height: screenHeight * 0.025),

                  // Item Selection
                  _buildSectionHeader('Select Item Type', screenWidth),
                  SizedBox(height: screenHeight * 0.015),
                  _buildDropdownField(
                    context: context,
                    hint: 'Choose gold item',
                    value: selectedItem,
                    items: goldItems,
                    onChanged: (value) => setState(() => selectedItem = value),
                    icon: Icons.inventory_2,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),

                  SizedBox(height: screenHeight * 0.025),

                  // Purity Selection
                  _buildSectionHeader('Gold Purity (Carat)', screenWidth),
                  SizedBox(height: screenHeight * 0.015),
                  _buildDropdownField(
                    context: context,
                    hint: 'Select gold purity',
                    value: selectedPurity,
                    items: purityOptions,
                    onChanged: (value) =>
                        setState(() => selectedPurity = value),
                    icon: Icons.star,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),

                  SizedBox(height: screenHeight * 0.025),

                  // Weight Input
                  _buildSectionHeader('Weight (in grams)', screenWidth),
                  SizedBox(height: screenHeight * 0.015),
                  _buildWeightField(screenWidth, screenHeight),

                  SizedBox(height: screenHeight * 0.025),

                  // Bill Date
                  _buildSectionHeader('Bill Date', screenWidth),
                  SizedBox(height: screenHeight * 0.015),
                  _buildDateField(screenWidth, screenHeight),

                  SizedBox(height: screenHeight * 0.04),

                  // Continue Button
                  Container(
                    width: double.infinity,
                    height: screenHeight * 0.065,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isFormValid()
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
                        onTap: _isFormValid()
                            ? () {
                                Get.toNamed('/digio-verification', arguments: {
                                  'loanType': 'Gold Loan',
                                  'vendor': selectedVendor,
                                  'item': selectedItem,
                                  'purity': selectedPurity,
                                  'weight': weightController.text,
                                  'billDate': selectedDate,
                                });
                              }
                            : null,
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.032),
                        child: Center(
                          child: Text(
                            'Proceed to Verification',
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
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, double screenWidth) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: screenWidth * 0.043,
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildDropdownField({
    required BuildContext context,
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.032),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: screenWidth * 0.015,
            offset: Offset(0, screenHeight * 0.005),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(
          hint,
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.037,
            color: Colors.grey[500],
          ),
        ),
        decoration: InputDecoration(
          prefixIcon:
              Icon(icon, color: AppColors.royalBlue, size: screenWidth * 0.06),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.032),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.poppins(fontSize: screenWidth * 0.037),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildWeightField(double screenWidth, double screenHeight) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.032),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: screenWidth * 0.015,
            offset: Offset(0, screenHeight * 0.005),
          ),
        ],
      ),
      child: TextFormField(
        controller: weightController,
        keyboardType: TextInputType.number,
        style: GoogleFonts.poppins(fontSize: screenWidth * 0.037),
        decoration: InputDecoration(
          hintText: 'Enter weight in grams',
          hintStyle: GoogleFonts.poppins(
            fontSize: screenWidth * 0.037,
            color: Colors.grey[500],
          ),
          prefixIcon: Icon(
            Icons.scale,
            color: AppColors.royalBlue,
            size: screenWidth * 0.06,
          ),
          suffixText: 'grams',
          suffixStyle: GoogleFonts.poppins(
            fontSize: screenWidth * 0.035,
            color: Colors.grey[600],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.032),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDateField(double screenWidth, double screenHeight) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.032),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: screenWidth * 0.015,
            offset: Offset(0, screenHeight * 0.005),
          ),
        ],
      ),
      child: TextFormField(
        readOnly: true,
        style: GoogleFonts.poppins(fontSize: screenWidth * 0.037),
        decoration: InputDecoration(
          hintText: selectedDate != null
              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
              : 'Select bill date',
          hintStyle: GoogleFonts.poppins(
            fontSize: screenWidth * 0.037,
            color: selectedDate != null ? Colors.grey[800] : Colors.grey[500],
          ),
          prefixIcon: Icon(
            Icons.calendar_today,
            color: AppColors.royalBlue,
            size: screenWidth * 0.06,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.032),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
          );
          if (date != null) {
            setState(() => selectedDate = date);
          }
        },
      ),
    );
  }

  bool _isFormValid() {
    return selectedVendor != null &&
        selectedItem != null &&
        selectedPurity != null &&
        weightController.text.isNotEmpty &&
        selectedDate != null;
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }
}
