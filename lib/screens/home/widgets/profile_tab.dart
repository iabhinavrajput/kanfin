import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kifinserv/constants/app_colors.dart';
import 'package:kifinserv/controller/home/home_controller.dart';
import 'package:kifinserv/routes/app_routes.dart';
import 'shared_widgets.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    final userInfo = homeController.getUserInfo();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
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
            screenHeight * 0.03,
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: screenWidth * 0.1,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Icon(
                  Icons.person,
                  size: screenWidth * 0.12,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              Obx(() => Text(
                    homeController.userName.value,
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
              SizedBox(height: screenHeight * 0.005),
              Obx(() => Text(
                    homeController.userEmail.value,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  )),
            ],
          ),
        ),

        // Profile Content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // Personal Information Card
                SharedWidgets.buildProfileCard(
                  'Personal Information',
                  Icons.person_outline,
                  [
                    SharedWidgets.buildProfileItem(
                        'Full Name', userInfo['name'] ?? 'N/A'),
                    SharedWidgets.buildProfileItem(
                        'Email', userInfo['email'] ?? 'N/A'),
                    // SharedWidgets.buildProfileItem(
                    //     'Role', userInfo['role'] ?? 'N/A'),
                    // SharedWidgets.buildProfileItem(
                    //     'User ID', userInfo['id']?.toString() ?? 'N/A'),
                  ],
                ),

                SizedBox(height: 20.h),

                // Account Settings Card
                SharedWidgets.buildProfileCard(
                  'Account Settings',
                  Icons.settings_outlined,
                  [
                    SharedWidgets.buildProfileAction('Edit Profile', Icons.edit,
                        () {
                      Get.snackbar('Info', 'Edit profile feature coming soon');
                    }),
                    SharedWidgets.buildProfileAction(
                        'Change Password', Icons.lock_outline, () {
                      Get.snackbar(
                          'Info', 'Change password feature coming soon');
                    }),
                    SharedWidgets.buildProfileAction(
                        'Notification Settings', Icons.notifications_outlined,
                        () {
                      Get.snackbar('Info', 'Notification settings coming soon');
                    }),
                  ],
                ),

                SizedBox(height: 20.h),

                // Support Card
                SharedWidgets.buildProfileCard(
                  'Support & Help',
                  Icons.help_outline,
                  [
                    SharedWidgets.buildProfileAction(
                        'Help Center', Icons.help_center_outlined, () {
                      Get.snackbar('Info', 'Help center coming soon');
                    }),
                    SharedWidgets.buildProfileAction(
                        'Contact Support', Icons.phone_outlined, () {
                      Get.snackbar(
                          'Info', 'Contact support feature coming soon');
                    }),
                    SharedWidgets.buildProfileAction(
                        'Terms & Conditions', Icons.description_outlined, () {
                      Get.snackbar('Info', 'Terms & conditions coming soon');
                    }),
                  ],
                ),

                SizedBox(height: 30.h),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: homeController.logout,
                    icon: Icon(Icons.logout, size: 20.w),
                    label: Text(
                      'Logout',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30.h),

                // My Applications Menu Item
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child:
                        Icon(Icons.assignment, color: Colors.green, size: 20.w),
                  ),
                  title: Text(
                    'My Applications',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'Track your loan applications',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 16.w, color: Colors.grey[400]),
                  onTap: () => Get.toNamed(AppRoutes.TRACK_APPLICATIONS),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
