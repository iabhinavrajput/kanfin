import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kifinserv/constants/app_colors.dart';
import 'package:kifinserv/routes/app_routes.dart';

class EVVehicleSelectionScreen extends StatefulWidget {
  const EVVehicleSelectionScreen({super.key});

  @override
  State<EVVehicleSelectionScreen> createState() =>
      _EVVehicleSelectionScreenState();
}

class _EVVehicleSelectionScreenState extends State<EVVehicleSelectionScreen> {
  String? selectedModel;
  Map<String, dynamic> vendorData = {};

  @override
  void initState() {
    super.initState();
    vendorData = Get.arguments ?? {};
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final vendor = vendorData['vendor'] ?? {};
    final models = vendor['models'] ?? <String>[];
    final vendorName = vendor['name'] ?? 'E-Rickshaw';
    final vendorColor = vendor['color'] ?? Colors.blue;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Select Model',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: screenWidth * 0.048,
          ),
        ),
        centerTitle: true,
        backgroundColor: vendorColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.white, size: screenWidth * 0.064),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: vendorColor,
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
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.electric_rickshaw,
                    size: screenWidth * 0.16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                Text(
                  vendorName,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  'Choose the perfect model for your needs',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Models List
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.064),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Models',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.053,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Expanded(
                    child: ListView.builder(
                      itemCount: models.length,
                      itemBuilder: (context, index) {
                        final model = models[index];
                        final isSelected = selectedModel == model;

                        return Container(
                          margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.04),
                            border: Border.all(
                              color:
                                  isSelected ? vendorColor : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (isSelected ? vendorColor : Colors.grey)
                                    .withOpacity(0.1),
                                blurRadius: screenWidth * 0.02,
                                offset: Offset(0, screenHeight * 0.005),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedModel = model;
                                });
                              },
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.04),
                              child: Padding(
                                padding: EdgeInsets.all(screenWidth * 0.053),
                                child: Row(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.all(screenWidth * 0.04),
                                      decoration: BoxDecoration(
                                        color: vendorColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                            screenWidth * 0.03),
                                      ),
                                      child: Icon(
                                        Icons.electric_rickshaw,
                                        color: vendorColor,
                                        size: screenWidth * 0.08,
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.04),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            model,
                                            style: GoogleFonts.poppins(
                                              fontSize: screenWidth * 0.043,
                                              fontWeight: FontWeight.w600,
                                              color: isSelected
                                                  ? vendorColor
                                                  : Colors.grey[800],
                                            ),
                                          ),
                                          SizedBox(
                                              height: screenHeight * 0.005),
                                          Text(
                                            'Electric E-Rickshaw Model',
                                            style: GoogleFonts.poppins(
                                              fontSize: screenWidth * 0.035,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle,
                                        color: vendorColor,
                                        size: screenWidth * 0.064,
                                      )
                                    else
                                      Icon(
                                        Icons.radio_button_unchecked,
                                        color: Colors.grey[400],
                                        size: screenWidth * 0.064,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Continue Button
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.064),
            child: Container(
              width: double.infinity,
              height: screenHeight * 0.065,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: selectedModel != null
                      ? [vendorColor, vendorColor.withOpacity(0.8)]
                      : [Colors.grey, Colors.grey.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(screenWidth * 0.032),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: selectedModel != null
                      ? () {
                          Get.toNamed(AppRoutes.USER_DETAILS_FORM, arguments: {
                            'loanType': 'EV Loan',
                            'vendor': vendorName,
                            'vehicle': selectedModel,
                            'vendorData': vendor,
                          });
                        }
                      : null,
                  borderRadius: BorderRadius.circular(screenWidth * 0.032),
                  child: Center(
                    child: Text(
                      'Proceed to Application',
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
          ),
        ],
      ),
    );
  }
}
