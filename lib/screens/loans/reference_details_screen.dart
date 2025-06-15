import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kifinserv/constants/app_colors.dart';
import 'package:kifinserv/routes/app_routes.dart';

class ReferenceDetailsScreen extends StatefulWidget {
  const ReferenceDetailsScreen({super.key});

  @override
  State<ReferenceDetailsScreen> createState() => _ReferenceDetailsScreenState();
}

class _ReferenceDetailsScreenState extends State<ReferenceDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> applicationData = {};

  // Reference 1 Controllers
  final ref1NameController = TextEditingController();
  final ref1PhoneController = TextEditingController();
  String? ref1Relation;

  // Reference 2 Controllers
  final ref2NameController = TextEditingController();
  final ref2PhoneController = TextEditingController();
  String? ref2Relation;

  final List<String> relations = [
    'Father',
    'Mother',
    'Brother',
    'Sister',
    'Friend',
    'Colleague',
    'Neighbor',
    'Relative',
    'Business Partner',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    applicationData = Get.arguments ?? {};
  }

  @override
  void dispose() {
    ref1NameController.dispose();
    ref1PhoneController.dispose();
    ref2NameController.dispose();
    ref2PhoneController.dispose();
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
          'Reference Details',
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
                      Icons.people,
                      size: screenWidth * 0.133,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Add References',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.064,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.008),
                  Text(
                    'Please provide two references who can vouch for you',
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Reference 1 Section
                    _buildReferenceSection(
                      title: 'Reference 1',
                      nameController: ref1NameController,
                      phoneController: ref1PhoneController,
                      selectedRelation: ref1Relation,
                      onRelationChanged: (value) {
                        setState(() {
                          ref1Relation = value;
                        });
                      },
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      color: Colors.blue,
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Reference 2 Section
                    _buildReferenceSection(
                      title: 'Reference 2',
                      nameController: ref2NameController,
                      phoneController: ref2PhoneController,
                      selectedRelation: ref2Relation,
                      onRelationChanged: (value) {
                        setState(() {
                          ref2Relation = value;
                        });
                      },
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      color: Colors.green,
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Guidelines
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
                                'Reference Guidelines',
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
                              '• References should be known to you for at least 2 years',
                              screenWidth),
                          _buildGuidelinePoint(
                              '• Provide accurate contact information',
                              screenWidth),
                          _buildGuidelinePoint(
                              '• References may be contacted for verification',
                              screenWidth),
                          _buildGuidelinePoint(
                              '• Avoid family members as references if possible',
                              screenWidth),
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
                          onTap: _submitReferences,
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.032),
                          child: Center(
                            child: Text(
                              'Continue to Terms & Conditions',
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

  Widget _buildReferenceSection({
    required String title,
    required TextEditingController nameController,
    required TextEditingController phoneController,
    required String? selectedRelation,
    required ValueChanged<String?> onRelationChanged,
    required double screenWidth,
    required double screenHeight,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
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
                padding: EdgeInsets.all(screenWidth * 0.025),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                ),
                child: Icon(
                  Icons.person,
                  color: color,
                  size: screenWidth * 0.05,
                ),
              ),
              SizedBox(width: screenWidth * 0.032),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.043,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),

          // Name Field
          TextFormField(
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter reference name';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person_outline, color: color),
              filled: true,
              fillColor: Colors.grey[50],
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
                borderSide: BorderSide(color: color, width: 2),
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
          ),

          SizedBox(height: screenHeight * 0.015),

          // Phone Field
          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter phone number';
              }
              if (value.length != 10) {
                return 'Please enter a valid 10-digit phone number';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone, color: color),
              filled: true,
              fillColor: Colors.grey[50],
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
                borderSide: BorderSide(color: color, width: 2),
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
          ),

          SizedBox(height: screenHeight * 0.015),

          // Relation Dropdown
          DropdownButtonFormField<String>(
            value: selectedRelation,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select relation';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Relation',
              prefixIcon: Icon(Icons.family_restroom, color: color),
              filled: true,
              fillColor: Colors.grey[50],
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
                borderSide: BorderSide(color: color, width: 2),
              ),
              labelStyle: GoogleFonts.poppins(
                fontSize: screenWidth * 0.037,
                color: Colors.grey[600],
              ),
            ),
            items: relations.map((relation) {
              return DropdownMenuItem<String>(
                value: relation,
                child: Text(
                  relation,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.037,
                    color: Colors.grey[800],
                  ),
                ),
              );
            }).toList(),
            onChanged: onRelationChanged,
          ),
        ],
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

  void _submitReferences() {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        ...applicationData,
        'reference1': {
          'name': ref1NameController.text.trim(),
          'phone': ref1PhoneController.text.trim(),
          'relation': ref1Relation,
        },
        'reference2': {
          'name': ref2NameController.text.trim(),
          'phone': ref2PhoneController.text.trim(),
          'relation': ref2Relation,
        },
      };

      Get.toNamed(AppRoutes.TERMS_CONDITIONS, arguments: updatedData);
    }
  }
}
