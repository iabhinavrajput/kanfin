import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kifinserv/models/user_counts_model.dart';
import 'package:kifinserv/routes/app_routes.dart';
import 'package:kifinserv/constants/app_colors.dart';
import 'package:kifinserv/controller/home/home_controller.dart';
import '../../../utils/time_utils.dart';
import 'shared_widgets.dart';
import 'application_stats_widget.dart';

class HomeTab extends StatefulWidget {
  final Function(int) onTabChange;

  const HomeTab({Key? key, required this.onTabChange}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  final HomeController homeController = Get.find<HomeController>();
  final box = GetStorage();

  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
    _animationController?.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  // Responsive helper methods
  bool get isTablet => MediaQuery.of(context).size.width > 600;
  bool get isLargeScreen => MediaQuery.of(context).size.width > 900;
  bool get isLandscape =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  int get crossAxisCount {
    if (isLargeScreen) return 4;
    if (isTablet) return 3;
    return 2;
  }

  double get horizontalPadding {
    if (isLargeScreen) return 40.w;
    if (isTablet) return 30.w;
    return 20.w;
  }

  double get cardSpacing {
    if (isLargeScreen) return 20.w;
    if (isTablet) return 18.w;
    return 16.w;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Obx(() {
      // Get real-time data from API
      final applicationStats = homeController.getApplicationStats();
      final totalApplications = applicationStats['total'] ?? 0;
      final pendingApplications = applicationStats['pending'] ?? 0;
      final approvedApplications = applicationStats['approved'] ?? 0;
      final evLoans = applicationStats['evLoans'] ?? 0;
      final goldLoans = applicationStats['goldLoans'] ?? 0;
      final applications =
          homeController.userCountsData.value?.applications ?? [];
      final isLoading = homeController.isLoadingApplications.value;
      final hasError = homeController.applicationError.value.isNotEmpty;

      Widget homeContent = RefreshIndicator(
        onRefresh: () => homeController.fetchUserApplications(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Enhanced Welcome Header with user info and time greeting
              _buildWelcomeHeader(screenWidth, screenHeight),

              // Show loading or error state
              if (isLoading)
                Container(
                  padding: EdgeInsets.all(horizontalPadding),
                  child: const CircularProgressIndicator(),
                )
              else if (hasError)
                Container(
                  padding: EdgeInsets.all(horizontalPadding),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, size: 48.w, color: Colors.red),
                      SizedBox(height: 16.h),
                      Text(
                        'Failed to load applications',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        homeController.applicationError.value,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () => homeController.fetchUserApplications(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              else
                // Statistics Cards Section
                _buildMainContent(
                  totalApplications,
                  pendingApplications,
                  approvedApplications,
                  evLoans,
                  goldLoans,
                  applications,
                ),
            ],
          ),
        ),
      );

      // Only apply fade animation if it's initialized
      if (_fadeAnimation != null) {
        return FadeTransition(
          opacity: _fadeAnimation!,
          child: homeContent,
        );
      } else {
        return homeContent;
      }
    });
  }

  Widget _buildWelcomeHeader(double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.royalBlue,
        // gradient: LinearGradient(
        //   colors: [
        //     AppColors.royalBlue,
        //     // AppColors.royalBlue.withOpacity(0.8),
        //   ],
        //   // begin: Alignment.topLeft,
        //   // end: Alignment.bottomRight,
        // ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(isTablet ? 40.r : 32.r),
          bottomRight: Radius.circular(isTablet ? 40.r : 32.r),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        0,
        horizontalPadding,
        isTablet ? 40.h : 30.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (isLandscape && !isTablet) {
                // Landscape layout for phones
                return Row(
                  children: [
                    Expanded(flex: 2, child: _buildWelcomeText()),
                    SizedBox(width: 20.w),
                    _buildTimeIcon(),
                  ],
                );
              } else {
                // Portrait layout or tablet
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildWelcomeText()),
                    SizedBox(width: 16.w),
                    _buildTimeIcon(),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TimeUtils.getTimeGreeting(),
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 18.sp : 16.sp,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        SizedBox(height: 5.h),
        // Obx(() => Text(
        //       homeController.userName.value,
        //       style: GoogleFonts.poppins(
        //         fontSize: 16.sp,
        //         // fontSize: isTablet ? 28.sp : 24.sp,
        //         fontWeight: FontWeight.bold,
        //         color: Colors.white,
        //       ),
        //       maxLines: 2,
        //       overflow: TextOverflow.ellipsis,
        //     )),
        // SizedBox(height: 5.h),
        Text(
          'Ready to apply for a loan?',
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 16.sp : 14.sp,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeIcon() {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16.w : 12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(isTablet ? 24.r : 20.r),
      ),
      child: Icon(
        TimeUtils.getTimeIcon(),
        color: Colors.white,
        size: isTablet ? 40.w : 32.w,
      ),
    );
  }

  Widget _buildMainContent(
    int totalApplications,
    int pendingApplications,
    int approvedApplications,
    int evLoans,
    int goldLoans,
    List<ApplicationData> applications,
  ) {
    return Padding(
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Your Dashboard"),
          SizedBox(height: cardSpacing),

          // Statistics Grid - Responsive
          _buildStatisticsGrid(
            totalApplications,
            pendingApplications,
            evLoans,
            goldLoans,
          ),

          SizedBox(height: 24),

          // Application Progress Chart
          if (totalApplications > 0) ...[
            SharedWidgets.buildProgressChart(
                totalApplications, pendingApplications, approvedApplications),
            SizedBox(height: isTablet ? 32.h : 24.h),
          ],

          // Quick Actions Section
          _buildSectionTitle("Quick Actions"),
          SizedBox(height: cardSpacing),

          // Enhanced Quick Action Cards - Responsive
          _buildQuickActionCards(),

          SizedBox(height: isTablet ? 24.h : 20.h),

          // Loan Types Section
          _buildLoanTypesSection(),

          SizedBox(height: isTablet ? 32.h : 24.h),

          // Recent Activity Section
          if (totalApplications > 0) ...[
            _buildRecentActivitySection(applications),
            SizedBox(height: isTablet ? 32.h : 24.h),
          ],

          // Main CTA Button
          _buildMainCTAButton(),

          SizedBox(height: isTablet ? 32.h : 24.h),

          // Quick Access Section
          Row(
            children: [
              Expanded(
                child: SharedWidgets.buildEnhancedActionCard(
                  icon: Icons.assignment,
                  title: 'Track Status',
                  subtitle: 'View applications',
                  color: Colors.green,
                  gradient: [Colors.green, Colors.green.withOpacity(0.7)],
                  onTap: () => Get.toNamed(AppRoutes.TRACK_APPLICATIONS),
                ),
              ),
              SizedBox(width: cardSpacing),
              Expanded(
                child: SharedWidgets.buildEnhancedActionCard(
                  icon: Icons.add_circle_outline,
                  title: 'New Loan',
                  subtitle: 'Apply now',
                  color: AppColors.royalBlue,
                  gradient: [
                    AppColors.royalBlue,
                    AppColors.royalBlue.withOpacity(0.7)
                  ],
                  onTap: () => Get.toNamed(AppRoutes.START_APPLICATION),
                ),
              ),
            ],
          ),

          SizedBox(height: isTablet ? 32.h : 24.h),

          // Support Section
          SharedWidgets.buildSupportSection(),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: ApplicationStatsWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: isTablet ? 24.sp : 20.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.royalBlue,
      ),
    );
  }

  Widget _buildStatisticsGrid(
    int totalApplications,
    int pendingApplications,
    int evLoans,
    int goldLoans,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive grid
        int columns = crossAxisCount;
        double childAspectRatio = 1.3;

        // Adjust aspect ratio based on screen size
        if (isLargeScreen) {
          childAspectRatio = 1.2;
        } else if (isTablet) {
          childAspectRatio = 1.25;
        }

        return GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: columns,
          crossAxisSpacing: cardSpacing,
          mainAxisSpacing: cardSpacing,
          childAspectRatio: childAspectRatio,
          children: [
            SharedWidgets.buildStatCard(
              'Total Applications',
              totalApplications.toString(),
              Icons.assignment,
              AppColors.royalBlue,
              'All time',
            ),
            SharedWidgets.buildStatCard(
              'Pending Review',
              pendingApplications.toString(),
              Icons.pending_actions,
              Colors.orange,
              'In progress',
            ),
            SharedWidgets.buildStatCard(
              'EV Loans',
              evLoans.toString(),
              Icons.electric_car,
              Colors.green,
              'Electric vehicles',
            ),
            SharedWidgets.buildStatCard(
              'Gold Loans',
              goldLoans.toString(),
              Icons.diamond,
              Colors.amber,
              'Gold-backed',
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickActionCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isLargeScreen) {
          // Large screen: Show cards in a row with more spacing
          return Row(
            children: [
              Expanded(
                child: SharedWidgets.buildEnhancedActionCard(
                  icon: Icons.add_circle_outline,
                  title: 'New Application',
                  subtitle: 'Start loan process',
                  color: AppColors.royalBlue,
                  gradient: [
                    AppColors.royalBlue,
                    AppColors.royalBlue.withOpacity(0.7)
                  ],
                  onTap: () => Get.toNamed(AppRoutes.START_APPLICATION),
                ),
              ),
              SizedBox(width: cardSpacing * 1.5),
              Expanded(
                child: SharedWidgets.buildEnhancedActionCard(
                  icon: Icons.track_changes,
                  title: 'Track Status',
                  subtitle: 'Check progress',
                  color: Colors.orange,
                  gradient: [Colors.orange, Colors.orange.withOpacity(0.7)],
                  onTap: () => widget.onTabChange(1),
                ),
              ),
            ],
          );
        } else if (isTablet) {
          // Tablet: Show cards in a row with medium spacing
          return Row(
            children: [
              Expanded(
                child: SharedWidgets.buildEnhancedActionCard(
                  icon: Icons.add_circle_outline,
                  title: 'New Application',
                  subtitle: 'Start loan process',
                  color: AppColors.royalBlue,
                  gradient: [
                    AppColors.royalBlue,
                    AppColors.royalBlue.withOpacity(0.7)
                  ],
                  onTap: () => Get.toNamed(AppRoutes.START_APPLICATION),
                ),
              ),
              SizedBox(width: cardSpacing),
              Expanded(
                child: SharedWidgets.buildEnhancedActionCard(
                  icon: Icons.track_changes,
                  title: 'Track Status',
                  subtitle: 'Check progress',
                  color: Colors.orange,
                  gradient: [Colors.orange, Colors.orange.withOpacity(0.7)],
                  onTap: () => widget.onTabChange(1),
                ),
              ),
            ],
          );
        } else {
          // Phone: Original layout
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SharedWidgets.buildEnhancedActionCard(
                  icon: Icons.add_circle_outline,
                  title: 'New Application',
                  subtitle: 'Start loan process',
                  color: AppColors.royalBlue,
                  gradient: [
                    AppColors.royalBlue,
                    AppColors.royalBlue.withOpacity(0.7)
                  ],
                  onTap: () => Get.toNamed(AppRoutes.START_APPLICATION),
                ),
              ),
              SizedBox(width: cardSpacing),
              Expanded(
                child: SharedWidgets.buildEnhancedActionCard(
                  icon: Icons.track_changes,
                  title: 'Track Status',
                  subtitle: 'Check progress',
                  color: Colors.orange,
                  gradient: [Colors.orange, Colors.orange.withOpacity(0.7)],
                  onTap: () => widget.onTabChange(1),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildLoanTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Loan Types Available"),
        SizedBox(height: cardSpacing),
        LayoutBuilder(
          builder: (context, constraints) {
            if (isLargeScreen) {
              // Large screen: Show in a row with more spacing
              return Row(
                children: [
                  Expanded(
                    child: SharedWidgets.buildLoanTypeCard(
                      'EV Loan',
                      'Electric Vehicle\nFinancing',
                      Icons.electric_car,
                      Colors.green,
                      '5.9% Interest',
                    ),
                  ),
                  SizedBox(width: cardSpacing * 1.5),
                  Expanded(
                    child: SharedWidgets.buildLoanTypeCard(
                      'Gold Loan',
                      'Gold-backed\nLending',
                      Icons.diamond,
                      Colors.amber,
                      '8.5% Interest',
                    ),
                  ),
                ],
              );
            } else {
              // Phone and tablet: Standard layout
              return Row(
                children: [
                  Expanded(
                    child: SharedWidgets.buildLoanTypeCard(
                      'EV Loan',
                      'Electric Vehicle\nFinancing',
                      Icons.electric_car,
                      Colors.green,
                      '5.9% Interest',
                    ),
                  ),
                  SizedBox(width: cardSpacing),
                  Expanded(
                    child: SharedWidgets.buildLoanTypeCard(
                      'Gold Loan',
                      'Gold-backed\nLending',
                      Icons.diamond,
                      Colors.amber,
                      '8.5% Interest',
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

    Widget _buildRecentActivitySection(List<ApplicationData> applications) {
    final recentApps = applications.take(isTablet ? 5 : 3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildSectionTitle("Recent Activity"),
            ),
            TextButton(
              onPressed: () => widget.onTabChange(1),
              child: Text(
                'View All',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 16.sp : 14.sp,
                  color: AppColors.royalBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: cardSpacing * 0.75),
        ...recentApps.map((app) => Padding(
              padding: EdgeInsets.only(bottom: cardSpacing * 0.75),
              child: _buildRecentActivityItem(app),
            )),
      ],
    );
  }

  Widget _buildRecentActivityItem(ApplicationData application) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  application.loanTypeName,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(application.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  application.statusDisplayName,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(application.status),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Application ID: ${application.id}',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Vendor: ${application.vendor.companyName}',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'disbursed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildMainCTAButton() {
    return Container(
      width: double.infinity,
      height: 150.h,
      // height: isTablet ? 160.h : 140.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.royalBlue,
            AppColors.royalBlue.withOpacity(0.8),
            Colors.indigo.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isTablet ? 24.r : 20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.royalBlue.withOpacity(0.4),
            blurRadius: isTablet ? 24.r : 20.r,
            offset: Offset(0, isTablet ? 12.h : 10.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(isTablet ? 24.r : 20.r),
          onTap: () => Get.toNamed(AppRoutes.START_APPLICATION),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 32.w : 24.w),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (isLandscape && !isTablet) {
                  // Landscape phone layout
                  return Row(
                    children: [
                      Expanded(flex: 3, child: _buildCTAText()),
                      SizedBox(width: 20.w),
                      _buildCTAIcon(),
                    ],
                  );
                } else {
                  // Portrait or tablet layout
                  return Row(
                    children: [
                      Expanded(child: _buildCTAText()),
                      SizedBox(width: 16.w),
                      _buildCTAIcon(),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCTAText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Apply for Loan',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10.h),
        // SizedBox(height: isTablet ? 12.h : 10.h),
        Text(
          'Quick approval • Low interest rates',
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        SizedBox(height: 14.h),
        Text(
          'Get started in minutes →',
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 14.sp : 12.sp,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCTAIcon() {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20.w : 16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(isTablet ? 24.r : 20.r),
      ),
      child: Icon(
        Icons.rocket_launch,
        color: Colors.white,
        size: isTablet ? 44.w : 36.w,
      ),
    );
  }
}
