import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kifinserv/constants/app_colors.dart';
import 'package:kifinserv/controller/home/home_controller.dart';
import 'widgets/home_tab.dart';
import 'widgets/status_tab.dart';
import 'widgets/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final HomeController homeController = Get.put(HomeController());

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: screenWidth * 0.048,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.royalBlue,
        elevation: 0,
        actions: _selectedIndex == 0
            ? [
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert,
                      color: Colors.white, size: screenWidth * 0.064),
                  onSelected: (value) {
                    if (value == 'logout') {
                      homeController.logout();
                    } else if (value == 'profile') {
                      _showUserProfile();
                    } else if (value == 'token_info') {
                      _showTokenInfo();
                    } else if (value == 'refresh') {
                      homeController.refreshUserInfo();
                      setState(() {}); // Refresh the home screen data
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'profile',
                      child: Row(
                        children: [
                          Icon(Icons.person_outline, size: screenWidth * 0.053),
                          SizedBox(width: screenWidth * 0.032),
                          Text('Profile',
                              style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.037)),
                        ],
                      ),
                    ),
                    // PopupMenuItem<String>(
                    //   value: 'refresh',
                    //   child: Row(
                    //     children: [
                    //       Icon(Icons.refresh, size: screenWidth * 0.053),
                    //       SizedBox(width: screenWidth * 0.032),
                    //       Text('Refresh',
                    //           style: GoogleFonts.poppins(
                    //               fontSize: screenWidth * 0.037)),
                    //     ],
                    //   ),
                    // ),
                    // PopupMenuItem<String>(
                    //   value: 'token_info',
                    //   child: Row(
                    //     children: [
                    //       Icon(Icons.info_outline, size: screenWidth * 0.053),
                    //       SizedBox(width: screenWidth * 0.032),
                    //       Text('Token Info',
                    //           style: GoogleFonts.poppins(
                    //               fontSize: screenWidth * 0.037)),
                    //     ],
                    //   ),
                    // ),
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout,
                              size: screenWidth * 0.053, color: Colors.red),
                          SizedBox(width: screenWidth * 0.032),
                          Text(
                            'Logout',
                            style: GoogleFonts.poppins(
                                color: Colors.red,
                                fontSize: screenWidth * 0.037),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ]
            : null,
      ),
      body: _getSelectedScreen(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.royalBlue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12.sp),
        iconSize: 24.w,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Status",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return "Kanfin Dashboard";
      case 1:
        return "Application Status";
      case 2:
        return "Profile";
      default:
        return "Kanfin Dashboard";
    }
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return HomeTab(
            onTabChange: (index) => setState(() => _selectedIndex = index));
      case 1:
        return StatusTab(
            onTabChange: (index) => setState(() => _selectedIndex = index));
      case 2:
        return const ProfileTab();
      default:
        return HomeTab(
            onTabChange: (index) => setState(() => _selectedIndex = index));
    }
  }

  void _showUserProfile() {
    final userInfo = homeController.getUserInfo();
    Get.dialog(
      AlertDialog(
        title:
            Text('User Profile', style: GoogleFonts.poppins(fontSize: 18.sp)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileRow('Name', userInfo['name'] ?? 'N/A'),
            _buildProfileRow('Email', userInfo['email'] ?? 'N/A'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close', style: GoogleFonts.poppins(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  void _showTokenInfo() {
    Get.dialog(
      AlertDialog(
        title: Text('Token Information',
            style: GoogleFonts.poppins(fontSize: 18.sp)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This information is extracted from your JWT token:',
              style: GoogleFonts.poppins(fontSize: 12.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              '• Name extracted from token\n• Email extracted from token\n• Role extracted from token\n• User ID extracted from token',
              style: GoogleFonts.poppins(fontSize: 12.sp),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close', style: GoogleFonts.poppins(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}
