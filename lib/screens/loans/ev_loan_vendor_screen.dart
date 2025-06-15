import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kifinserv/routes/app_routes.dart';

class EVLoanVendorScreen extends StatefulWidget {
  const EVLoanVendorScreen({super.key});

  @override
  State<EVLoanVendorScreen> createState() => _EVLoanVendorScreenState();
}

class _EVLoanVendorScreenState extends State<EVLoanVendorScreen> {
  String? selectedVendor;

  final List<Map<String, dynamic>> eRickshawVendors = [
    {
      'name': 'Mahindra Treo',
      'logo': Icons.electric_rickshaw,
      'models': ['Treo', 'Treo Zor', 'Treo Yaari'],
      'color': Colors.red,
    },
    {
      'name': 'Bajaj RE',
      'logo': Icons.electric_rickshaw,
      'models': ['RE Compact', 'RE Maxima', 'RE Optima'],
      'color': Colors.orange,
    },
    {
      'name': 'Atul Auto',
      'logo': Icons.electric_rickshaw,
      'models': ['Atul Elite', 'Atul Gemini', 'Atul Shakti'],
      'color': Colors.blue,
    },
    {
      'name': 'Piaggio Ape',
      'logo': Icons.electric_rickshaw,
      'models': ['Ape E-City', 'Ape E-Xtra', 'Ape Auto'],
      'color': Colors.green,
    },
    {
      'name': 'TVS King',
      'logo': Icons.electric_rickshaw,
      'models': ['King Deluxe', 'King Duramax', 'King 4W'],
      'color': Colors.teal,
    },
    {
      'name': 'Force Motors',
      'logo': Icons.electric_rickshaw,
      'models': ['Tempo Traveller', 'Minidor', 'Trax'],
      'color': Colors.purple,
    },
    {
      'name': 'Lohia Auto',
      'logo': Icons.electric_rickshaw,
      'models': ['Narain', 'Humrahi', 'Comfort'],
      'color': Colors.indigo,
    },
    {
      'name': 'Champion Poly',
      'logo': Icons.electric_rickshaw,
      'models': ['Champion CNG', 'Champion Diesel'],
      'color': Colors.brown,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Select E-Rickshaw Vendor',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: screenWidth * 0.048,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
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
              color: Colors.green,
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
                  Icons.electric_rickshaw,
                  size: screenWidth * 0.16,
                  color: Colors.white,
                ),
                SizedBox(height: screenHeight * 0.015),
                Text(
                  'Choose Your E-Rickshaw Brand',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  'Select from our partnered e-rickshaw vendors',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Vendors List
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.064),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: screenWidth * 0.04,
                  mainAxisSpacing: screenHeight * 0.02,
                  childAspectRatio: 0.85,
                ),
                itemCount: eRickshawVendors.length,
                itemBuilder: (context, index) {
                  final vendor = eRickshawVendors[index];
                  final isSelected = selectedVendor == vendor['name'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedVendor = vendor['name'];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(screenWidth * 0.04),
                        border: Border.all(
                          color:
                              isSelected ? vendor['color'] : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (isSelected ? vendor['color'] : Colors.grey)
                                .withOpacity(0.1),
                            blurRadius: screenWidth * 0.02,
                            offset: Offset(0, screenHeight * 0.005),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(screenWidth * 0.04),
                              decoration: BoxDecoration(
                                color: vendor['color'].withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.03),
                              ),
                              child: Icon(
                                Icons.electric_rickshaw,
                                size: screenWidth * 0.08,
                                color: vendor['color'],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            Text(
                              vendor['name'],
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? vendor['color']
                                    : Colors.grey[800],
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: screenHeight * 0.008),
                            Text(
                              '${vendor['models'].length} Models',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.032,
                                color: Colors.grey[600],
                              ),
                            ),
                            if (isSelected) ...[
                              SizedBox(height: screenHeight * 0.01),
                              Icon(
                                Icons.check_circle,
                                color: vendor['color'],
                                size: screenWidth * 0.06,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
                  colors: selectedVendor != null
                      ? [Colors.green, Colors.green.withOpacity(0.8)]
                      : [Colors.grey, Colors.grey.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(screenWidth * 0.032),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: selectedVendor != null
                      ? () {
                          Get.toNamed(AppRoutes.EV_VEHICLE_SELECTION,
                              arguments: {
                                'vendor': eRickshawVendors.firstWhere(
                                    (v) => v['name'] == selectedVendor),
                              });
                        }
                      : null,
                  borderRadius: BorderRadius.circular(screenWidth * 0.032),
                  child: Center(
                    child: Text(
                      'Continue',
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
