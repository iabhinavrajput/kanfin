import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kifinserv/constants/app_colors.dart';
import 'package:kifinserv/models/application_model.dart';
import 'package:kifinserv/routes/app_routes.dart';
import 'package:kifinserv/services/application_storage_service.dart';

class StatusTab extends StatefulWidget {
  final Function(int) onTabChange;

  const StatusTab({Key? key, required this.onTabChange}) : super(key: key);

  @override
  State<StatusTab> createState() => _StatusTabState();
}

class _StatusTabState extends State<StatusTab> {
  final ApplicationStorageService _storageService = ApplicationStorageService();
  List<LoanApplication> applications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() => isLoading = true);
    try {
      final apps = await _storageService.getAllApplications();
      setState(() {
        applications = apps;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadApplications,
      child: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.royalBlue,
                  AppColors.royalBlue.withOpacity(0.8)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.assignment,
                  size: 60.w,
                  color: Colors.white,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Application Status',
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Track your loan applications',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 20.h),

                // Quick Stats
                if (!isLoading && applications.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQuickStat(
                            'Total', applications.length, Icons.apps),
                        _buildQuickStat(
                            'Pending',
                            applications
                                .where((app) =>
                                    app.status == 'submitted' ||
                                    app.status == 'under_review')
                                .length,
                            Icons.hourglass_empty),
                        _buildQuickStat(
                            'Approved',
                            applications
                                .where((app) =>
                                    app.status == 'approved' ||
                                    app.status == 'disbursed')
                                .length,
                            Icons.check_circle),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Content Section
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : applications.isEmpty
                    ? _buildEmptyState()
                    : Column(
                        children: [
                          // View All Button
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recent Applications',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () =>
                                      Get.toNamed(AppRoutes.TRACK_APPLICATIONS),
                                  icon: Icon(Icons.visibility, size: 16.w),
                                  label: Text('View All'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.royalBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Recent Applications List (show latest 3)
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              itemCount: applications.length > 3
                                  ? 3
                                  : applications.length,
                              itemBuilder: (context, index) {
                                final application = applications[index];
                                return _buildApplicationCard(application);
                              },
                            ),
                          ),

                          // Bottom Actions
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () => Get.toNamed(
                                        AppRoutes.TRACK_APPLICATIONS),
                                    icon: Icon(Icons.list_alt),
                                    label: Text('View All Applications'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.royalBlue,
                                      foregroundColor: Colors.white,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      widget
                                          .onTabChange(0); // Switch to Home tab
                                      Get.toNamed(AppRoutes.START_APPLICATION);
                                    },
                                    icon: Icon(Icons.add),
                                    label: Text('New Application'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.royalBlue,
                                      side: BorderSide(
                                          color: AppColors.royalBlue),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
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
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, int count, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24.w),
        SizedBox(height: 8.h),
        Text(
          count.toString(),
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildApplicationCard(LoanApplication application) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: application.statusColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.w),
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: application.statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            application.statusIcon,
            color: application.statusColor,
            size: 24.w,
          ),
        ),
        title: Text(
          application.loanType,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              'ID: ${application.id}',
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: application.statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                application.statusDisplayName,
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: application.statusColor,
                ),
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[400],
          size: 16.w,
        ),
        onTap: () => Get.toNamed(AppRoutes.TRACK_APPLICATIONS),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.all(32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80.w,
            color: Colors.grey[400],
          ),
          SizedBox(height: 24.h),
          Text(
            'No Applications Yet',
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Start your loan journey by applying for your first loan',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),
          ElevatedButton.icon(
            onPressed: () {
              widget.onTabChange(0);
              Get.toNamed(AppRoutes.START_APPLICATION);
            },
            icon: Icon(Icons.add),
            label: Text('Apply for Loan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.royalBlue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 16.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
